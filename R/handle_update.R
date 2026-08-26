#' Handle Data Update
#'
#' Orchestrates the update process: checks if an update is needed, processes
#' data, writes output, and stores the new checksum.
#'
#' Unlike the KOF-sourced OpenTSI archives this function takes no API key --
#' the Swiss Stats Explorer API is public.
#'
#' @return Invisibly returns NULL.
#' @importFrom opentimeseries is_update_needed update_checksum
#' @importFrom digest digest
#' @export
handle_update <- function() {

  checksum_input <- generate_checksum_input()

  if (!is_update_needed(checksum_input)) {
    message("No update needed, series up-to-date.")
    return(invisible(NULL))
  }

  # `opentimeseries::update_checksum()` stores verbatim whatever it is handed,
  # while `is_update_needed()` compares the stored value against
  # digest(input, "sha256"). Passing the raw object -- as the boilerplate and
  # the KOF-sourced archives do -- therefore writes the entire series into
  # inst/metadata.json and makes every subsequent run report an update. Hashing
  # here keeps the file small and the comparison meaningful, and matches what
  # deloRean::archive_seal() writes when the archive is sealed.
  upd <- update_checksum(digest(checksum_input, algo = "sha256"))
  if (upd) {
    process_data()
  } else {
    message("Checksum initialized. Data untouched.")
  }
  message("Update complete, checksum stored.")
}


#' User Written Function to Create Input for Checksum Comparison
#'
#' Returns a small, representative slice of the dataset whose content changes
#' exactly when the FSO publishes: total overnight stays (indicator 20201,
#' weighted sum) for both accommodation types, all origins combined. By OpenTSI
#' definition every series of a dataset shares a publication date, so a
#' revision anywhere in the cube shows up here.
#'
#' The SDMX key lists dimension values in structure order:
#' `FREQ.ACCOMMODATION_TYPE.INDICATOR.COUNTRY_ORIGIN.STATISTICAL_OPERATION`.
#'
#' @return A data.frame as returned by [sse_data()].
generate_checksum_input <- function() {
  sse_data(PASTA_FLOW_ID, key = "M.552001+552002.20201._T.SUMW")
}
