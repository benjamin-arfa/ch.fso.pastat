# ---- dataset-specific constants --------------------------------------------
# These five lines, plus generate_checksum_input() in R/handle_update.R, are
# everything that changes when this archive is cloned for another stats.swiss
# dataflow. See docs/PLAYBOOK.md section 5.

PASTA_FLOW_ID <- "DF_PASTA_552_MONTHLY"

# The dataflow also publishes Q and A observations. One OpenTSI dataset holds
# exactly one frequency, so the annual and quarterly rows are dropped here.
PASTA_FREQ <- "M"

# SDMX dimensions that make up the OpenTSI key, in key order.
PASTA_KEY_DIMS <- c("ACCOMMODATION_TYPE", "INDICATOR", "COUNTRY_ORIGIN",
                    "STATISTICAL_OPERATION")

# SDMX codes that need a friendlier spelling in the key. "_T" is the SDMX total
# code; OpenTSI archives spell totals "tot" (cf. opentsi/ch.fso.besta).
PASTA_CODE_MAP <- c("_T" = "tot")

#' Rewrite SDMX Codes as OpenTSI Key Segments
#'
#' @param x Character vector of SDMX codes.
#' @return Character vector of key segments.
#' @noRd
pasta_key_segment <- function(x) {
  mapped <- PASTA_CODE_MAP[x]
  out <- ifelse(is.na(mapped), x, mapped)
  tolower(out)
}

#' Convert SDMX TIME_PERIOD to a Date
#'
#' Monthly periods are published as "YYYY-MM"; OpenTSI CSVs carry the first day
#' of the period.
#'
#' @param x Character vector of SDMX time periods.
#' @return A Date vector.
#' @noRd
pasta_period_to_date <- function(x) {
  if (!all(grepl("^[0-9]{4}-[0-9]{2}$", x))) {
    bad <- unique(x[!grepl("^[0-9]{4}-[0-9]{2}$", x)])
    stop(sprintf(
      "Unexpected monthly TIME_PERIOD values: %s",
      paste(utils::head(bad, 5), collapse = ", ")
    ))
  }
  as.Date(paste0(x, "-01"))
}

#' Process FSO PASTA Data
#'
#' Fetches the whole `DF_PASTA_552_MONTHLY` cube from the Swiss Stats Explorer,
#' keeps the monthly observations, and writes one `data-raw/csv/<key>.csv` per
#' series, where the key is
#' `<accommodation>.<indicator>.<origin>.<operation>`. Also regenerates
#' `data-raw/index.md`.
#'
#' @return Invisibly returns a character vector of output file paths.
#' @export
process_data <- function() {
  dat <- sse_data(PASTA_FLOW_ID)

  missing_dims <- setdiff(c("FREQ", "TIME_PERIOD", PASTA_KEY_DIMS), names(dat))
  if (length(missing_dims)) {
    stop(sprintf(
      "The SSE response is missing expected dimensions: %s. The dataflow structure changed; re-run the discover workflow.",
      paste(missing_dims, collapse = ", ")
    ))
  }

  dat <- dat[dat$FREQ == PASTA_FREQ, , drop = FALSE]
  if (!nrow(dat)) {
    stop(sprintf("No observations with FREQ == '%s' in %s.",
                 PASTA_FREQ, PASTA_FLOW_ID))
  }

  segments <- lapply(PASTA_KEY_DIMS, function(d) pasta_key_segment(dat[[d]]))
  dat$key <- do.call(paste, c(segments, list(sep = ".")))
  dat$time <- pasta_period_to_date(dat$TIME_PERIOD)

  csv_dir <- file.path("data-raw", "csv")
  dir.create(csv_dir, showWarnings = FALSE, recursive = TRUE)

  keys <- sort(unique(dat$key))
  out_paths <- vapply(keys, function(k) {
    series <- dat[dat$key == k, c("time", "value"), drop = FALSE]
    series <- series[order(series$time), ]
    output_path <- file.path(csv_dir, paste0(k, ".csv"))
    utils::write.csv(series, file = output_path, row.names = FALSE,
                     quote = FALSE)
    output_path
  }, character(1))

  message(sprintf("Written %d series to %s", length(out_paths), csv_dir))

  orphans <- setdiff(
    list.files(csv_dir, pattern = "\\.csv$"),
    paste0(keys, ".csv")
  )
  if (length(orphans)) {
    warning(sprintf(
      "%d CSV file(s) in %s are no longer produced by the source: %s",
      length(orphans), csv_dir, paste(orphans, collapse = ", ")
    ))
  }

  write_index(keys)

  invisible(unname(out_paths))
}

#' Regenerate data-raw/index.md
#'
#' @param keys Character vector of series keys.
#' @return Invisibly returns the index path.
#' @noRd
write_index <- function(keys) {
  index_path <- file.path("data-raw", "index.md")
  lines <- c(
    "",
    "## Index of Time Series in ch.fso.pasta",
    "",
    sprintf("- [%s](csv/%s.csv)", keys, keys),
    ""
  )
  writeLines(lines, index_path)
  message(sprintf("Written: %s (%d series)", index_path, length(keys)))
  invisible(index_path)
}
