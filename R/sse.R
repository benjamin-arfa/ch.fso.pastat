# Minimal SDMX client for the Swiss Stats Explorer (stats.swiss) API.
#
# Modelled on BFS::bfs_get_sse_*() (CRAN package BFS >= 0.7.0) but deliberately
# limited to httr2 + xml2. Depending on BFS itself would pull in
# pxweb, rvest, janitor, dplyr, tidyr and purrr for three HTTP calls and some
# XPath; keeping the dependency surface small keeps CI fast and the archive
# easy to install. This file is dataset-agnostic and can be copied verbatim
# into any other ch.fso.<dataset> archive. See docs/PLAYBOOK.md.

SSE_BASE <- "https://disseminate.stats.swiss/rest"

# Catalogue is fetched at most once per session.
.sse_cache <- new.env(parent = emptyenv())

#' Fetch the SSE Dataflow Catalogue
#'
#' @return A data.frame with columns `agency`, `flow`, `version`.
#' @noRd
sse_catalogue <- function() {
  if (!is.null(.sse_cache$catalogue)) {
    return(.sse_cache$catalogue)
  }

  req <- httr2::request(paste0(SSE_BASE, "/dataflow"))
  req <- httr2::req_headers(req, Accept = "application/json")
  req <- httr2::req_retry(req, max_tries = 3)
  # check_type = FALSE: the NSI web service labels responses with SDMX media
  # types (application/vnd.sdmx.*) that httr2 does not recognise as JSON/XML.
  body <- httr2::resp_body_json(httr2::req_perform(req), check_type = FALSE,
                                simplifyVector = FALSE)

  urns <- names(body$references)
  if (is.null(urns) || !length(urns)) {
    stop("The SSE catalogue returned no dataflow references.")
  }

  # urn:sdmx:org.sdmx.infomodel.datastructure.Dataflow=CH1.PASTA:DF_X(1.0.0)
  ids <- sub(".*Dataflow=", "", urns)
  ids <- sub("\\)$", "", ids)

  out <- data.frame(
    agency  = sub(":.*", "", ids),
    flow    = sub("\\(.*", "", sub("^[^:]+:", "", ids)),
    version = sub(".*\\(", "", ids),
    stringsAsFactors = FALSE
  )
  out <- out[!duplicated(out), ]
  .sse_cache$catalogue <- out
  out
}

#' Resolve a Dataflow Id to Agency and Version
#'
#' @param flow_id SDMX dataflow id, e.g. "DF_PASTA_552_MONTHLY".
#' @return A one-row data.frame with `agency`, `flow`, `version`.
#' @noRd
sse_ref <- function(flow_id) {
  flows <- sse_catalogue()
  hit <- flows[flows$flow == flow_id, , drop = FALSE]
  if (!nrow(hit)) {
    stop(sprintf("Dataflow '%s' does not exist in the SSE catalogue.", flow_id))
  }
  # Several versions can coexist; take the highest.
  hit[order(numeric_version(hit$version), decreasing = TRUE), ][1, ]
}

#' Read the Codelists of an SSE Dataflow
#'
#' Returns the data structure definition of `flow_id` flattened into one row per
#' (dimension, code) pair, restricted to the codes that are actually present in
#' the cube. This is the input for building `data-raw/metadata.yaml`.
#'
#' @param flow_id SDMX dataflow id, e.g. "DF_PASTA_552_MONTHLY".
#' @param lang Label language, one of "de", "fr", "it", "en".
#' @return A data.frame with columns `dimension`, `position`, `codelist_id`,
#'   `code`, `label`, `parent`.
#' @export
sse_codelists <- function(flow_id, lang = c("en", "de", "fr", "it")) {
  lang <- match.arg(lang)
  ref <- sse_ref(flow_id)

  url <- sprintf(
    "%s/dataflow/%s/%s/%s?references=all",
    SSE_BASE, ref$agency, ref$flow, ref$version
  )
  req <- httr2::request(url)
  req <- httr2::req_headers(req, Accept = "application/xml",
                            `Accept-Language` = lang)
  req <- httr2::req_retry(req, max_tries = 3)
  doc <- httr2::resp_body_xml(httr2::req_perform(req), check_type = FALSE)

  # --- dimensions -----------------------------------------------------------
  dim_nodes <- xml2::xml_find_all(
    doc, ".//structure:DimensionList/structure:Dimension"
  )
  dims <- data.frame(
    dimension   = xml2::xml_attr(dim_nodes, "id"),
    position    = as.integer(xml2::xml_attr(dim_nodes, "position")),
    codelist_id = xml2::xml_attr(
      xml2::xml_find_first(dim_nodes, ".//structure:Enumeration/Ref"), "id"
    ),
    stringsAsFactors = FALSE
  )
  dims <- dims[order(dims$position), ]

  # --- codes, per codelist --------------------------------------------------
  cl_nodes <- xml2::xml_find_all(doc, ".//structure:Codelist")
  codes <- do.call(rbind, lapply(cl_nodes, function(cl) {
    code_nodes <- xml2::xml_find_all(cl, ".//structure:Code")
    if (!length(code_nodes)) return(NULL)
    data.frame(
      codelist_id = xml2::xml_attr(cl, "id"),
      code        = xml2::xml_attr(code_nodes, "id"),
      label       = vapply(code_nodes, xml_name_in, character(1), lang = lang),
      parent      = xml2::xml_attr(
        xml2::xml_find_first(code_nodes, "./structure:Parent/Ref"), "id"
      ),
      stringsAsFactors = FALSE
    )
  }))

  out <- merge(dims, codes, by = "codelist_id", all.x = TRUE)

  # --- restrict to codes present in the cube --------------------------------
  # A codelist is normally much larger than the cube that references it; the
  # ContentConstraint's CubeRegion says which codes carry data.
  kv_nodes <- xml2::xml_find_all(doc, ".//structure:CubeRegion/common:KeyValue")
  if (length(kv_nodes)) {
    present <- do.call(rbind, lapply(kv_nodes, function(kv) {
      vals <- xml2::xml_find_all(kv, "./common:Value")
      if (!length(vals)) return(NULL)
      data.frame(
        dimension = xml2::xml_attr(kv, "id"),
        code      = xml2::xml_text(vals),
        stringsAsFactors = FALSE
      )
    }))
    keep <- paste(out$dimension, out$code) %in%
      paste(present$dimension, present$code)
    out <- out[keep, , drop = FALSE]
  }

  out <- out[order(out$position, out$code), ]
  rownames(out) <- NULL
  out[, c("dimension", "position", "codelist_id", "code", "label", "parent")]
}

#' Extract a Name in a Given Language, Falling Back to the First One
#' @noRd
xml_name_in <- function(node, lang) {
  hit <- xml2::xml_find_first(
    node, sprintf("./common:Name[@xml:lang='%s']", lang)
  )
  if (is.na(hit)) {
    hit <- xml2::xml_find_first(node, "./common:Name")
  }
  if (is.na(hit)) NA_character_ else xml2::xml_text(hit)
}

#' Read Observations from an SSE Dataflow
#'
#' @param flow_id SDMX dataflow id, e.g. "DF_PASTA_552_MONTHLY".
#' @param key SDMX key: dimension values in structure order, joined by ".",
#'   "+" for alternatives, an empty segment for "all values of that dimension".
#'   The default "all" requests the whole cube.
#' @param start_period,end_period Optional period bounds, e.g. "2020" or
#'   "2020-01".
#' @return A long data.frame with one column per dimension (including
#'   `TIME_PERIOD`) plus a numeric `value` column.
#' @export
sse_data <- function(flow_id, key = "all",
                     start_period = NULL, end_period = NULL) {
  ref <- sse_ref(flow_id)

  query <- c(
    if (!is.null(start_period)) paste0("startPeriod=", start_period),
    if (!is.null(end_period)) paste0("endPeriod=", end_period),
    "dimensionAtObservation=AllDimensions"
  )
  url <- sprintf(
    "%s/data/%s,%s,%s/%s?%s",
    SSE_BASE, ref$agency, ref$flow, ref$version, key, paste(query, collapse = "&")
  )

  req <- httr2::request(url)
  req <- httr2::req_headers(req, Accept = "application/xml")
  req <- httr2::req_retry(req, max_tries = 3)
  doc <- httr2::resp_body_xml(httr2::req_perform(req), check_type = FALSE)

  obs <- xml2::xml_find_all(doc, ".//generic:Obs")
  if (!length(obs)) {
    stop(sprintf("No observations returned for '%s' (key '%s').", flow_id, key))
  }

  # Every observation carries the same set of dimensions, so the flat list of
  # ObsKey values can be reshaped into a matrix in one pass.
  kv <- xml2::xml_find_all(obs, ".//generic:ObsKey/generic:Value")
  ids <- xml2::xml_attr(kv, "id")
  vals <- xml2::xml_attr(kv, "value")

  n_dim <- length(xml2::xml_find_all(obs[[1]], ".//generic:ObsKey/generic:Value"))
  if (length(kv) != n_dim * length(obs)) {
    stop("Ragged observation keys returned by the SSE API; cannot reshape.")
  }

  dim_names <- ids[seq_len(n_dim)]
  # The reshape below assumes every observation lists its dimensions in the same
  # order. That is what the NSI web service does, but a silent violation would
  # scramble columns, so it is checked rather than trusted.
  if (!identical(ids, rep(dim_names, length(obs)))) {
    stop("Observation keys are not in a consistent dimension order.")
  }
  m <- matrix(vals, ncol = n_dim, byrow = TRUE, dimnames = list(NULL, dim_names))

  out <- as.data.frame(m, stringsAsFactors = FALSE)
  out$value <- as.numeric(
    xml2::xml_attr(xml2::xml_find_first(obs, "./generic:ObsValue"), "value")
  )
  out
}
