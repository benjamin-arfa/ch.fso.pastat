# Asserts that data-raw/metadata.yaml is internally consistent:
#   * every dimension in dim_order appears in hierarchy and in labels$dimnames
#   * every code nested in hierarchy has a label
#   * every label carries all four Swiss official languages
#   * units and aggregate are declared for every indicator code
# Run by .github/workflows/check.yaml. Dataset-agnostic apart from INDICATOR_DIM.

INDICATOR_DIM <- "indicator"
LANGS <- c("en", "de", "fr", "it")

meta <- yaml::read_yaml("data-raw/metadata.yaml")
fail <- character(0)

flatten_codes <- function(node) {
  if (is.null(node)) return(character(0))
  unlist(lapply(names(node), function(nm) c(nm, flatten_codes(node[[nm]]))),
         use.names = FALSE)
}

dimnames_lbl <- meta$labels$dimnames

for (d in meta$dim_order) {
  if (is.null(meta$hierarchy[[d]])) {
    fail <- c(fail, sprintf("dimension '%s' is in dim_order but not in hierarchy", d))
  }
  if (is.null(dimnames_lbl[[d]])) {
    fail <- c(fail, sprintf("dimension '%s' has no label", d))
  }
}

codes <- unique(unlist(lapply(meta$dim_order, function(d)
  flatten_codes(meta$hierarchy[[d]])), use.names = FALSE))

for (code in codes) {
  lbl <- dimnames_lbl[[code]]
  if (is.null(lbl)) {
    fail <- c(fail, sprintf("code '%s' has no label", code))
    next
  }
  missing <- setdiff(LANGS, names(lbl))
  if (length(missing)) {
    fail <- c(fail, sprintf("code '%s' is missing label language(s): %s",
                            code, paste(missing, collapse = ", ")))
  }
}

for (d in meta$dim_order) {
  lbl <- dimnames_lbl[[d]]
  missing <- setdiff(LANGS, names(lbl))
  if (length(missing)) {
    fail <- c(fail, sprintf("dimension '%s' is missing label language(s): %s",
                            d, paste(missing, collapse = ", ")))
  }
}

indicators <- flatten_codes(meta$hierarchy[[INDICATOR_DIM]])
for (ind in indicators) {
  if (is.null(meta$units[[ind]]) && is.null(meta$units[["all"]])) {
    fail <- c(fail, sprintf("no unit declared for indicator '%s'", ind))
  }
  if (is.null(meta$aggregate[[ind]]) && is.null(meta$aggregate[["all"]])) {
    fail <- c(fail, sprintf("no aggregation rule declared for indicator '%s'", ind))
  }
}

# After sealing, inst/metadata.json must carry a SHA-256 hash. Guards against a
# regression to storing the raw series there (see R/handle_update.R).
json_path <- file.path("inst", "metadata.json")
if (file.exists(json_path)) {
  stored <- jsonlite::fromJSON(json_path)$update_checksum
  if (!is.character(stored) || length(stored) != 1L ||
      !grepl("^[a-f0-9]{64}$", stored)) {
    fail <- c(fail, sprintf(
      "inst/metadata.json update_checksum is not a SHA-256 hash (got %s of length %d)",
      class(stored)[[1]], length(stored)
    ))
  } else {
    cat("update_checksum is a SHA-256 hash\n")
  }
}

# Once data exists, every key on disk must decompose into declared codes. This
# is what catches a source that quietly gained a new code between two runs.
csv_dir <- file.path("data-raw", "csv")
csv_files <- list.files(csv_dir, pattern = "\\.csv$")
if (length(csv_files)) {
  declared <- lapply(meta$dim_order, function(d) flatten_codes(meta$hierarchy[[d]]))
  names(declared) <- meta$dim_order
  for (f in csv_files) {
    parts <- strsplit(sub("\\.csv$", "", f), ".", fixed = TRUE)[[1]]
    if (length(parts) != length(meta$dim_order)) {
      fail <- c(fail, sprintf("key '%s' has %d segments, dim_order declares %d",
                              f, length(parts), length(meta$dim_order)))
      next
    }
    for (i in seq_along(parts)) {
      d <- meta$dim_order[[i]]
      if (!parts[[i]] %in% declared[[d]]) {
        fail <- c(fail, sprintf("key '%s': '%s' is not a declared code of dimension '%s'",
                                f, parts[[i]], d))
      }
    }
  }
  cat(sprintf("checked %d series keys against the declared hierarchy\n",
              length(csv_files)))
}

if (length(fail)) {
  cat(paste0("  - ", fail, collapse = "\n"), "\n")
  stop(sprintf("metadata.yaml consistency check failed (%d problem(s))",
               length(fail)))
}

cat(sprintf("metadata.yaml consistent: %d dimensions, %d codes, %d languages\n",
            length(meta$dim_order), length(codes), length(LANGS)))
