#' Return all static attributes for every basin at the given level
#'
#' Reads and merges the six static-attribute Parquet files (climate, hydrology,
#' location, geology, soil, landcover) into a single wide \code{data.table}.
#' Files that fail (e.g. HTTP 404) are skipped with a \code{warning()}; if
#' every file fails the function stops with a friendly message.
#'
#' @param level Character. One of \code{"L1"}, \code{"L2"}, \code{"L3"}, \code{"L4"}.
#' @param cache Logical. Cache Parquet locally on first call. Default \code{FALSE}.
#' @return A \code{data.table} with one row per basin and 216+ attribute columns.
#' @export
#' @examples
#' \dontrun{
#' dt <- ca_attrs(level = "L1")
#' }
ca_attrs <- function(level = "L1", cache = FALSE) {
  validate_level(level)
  frames <- list()
  for (cat in STATIC_CATEGORIES) {
    url <- url_static(level, cat)
    tryCatch({
      tbl          <- read_parquet_url(url, cache = cache)
      frames[[cat]] <- data.table::as.data.table(tbl)
    }, error = function(e) {
      warning(sprintf("Skipping category '%s': %s", cat, conditionMessage(e)))
    })
  }
  if (length(frames) == 0L) {
    stop(sprintf("No static data found for level %s. Check network or CDN.", level),
         call. = FALSE)
  }
  dt <- frames[[1L]]
  for (other in frames[-1L]) {
    dup_cols <- setdiff(intersect(names(dt), names(other)), "Basin_ID")
    if (length(dup_cols) > 0L) {
      other <- other[, !names(other) %in% dup_cols, with = FALSE]
    }
    dt <- merge(dt, other, by = "Basin_ID", all = TRUE)
  }
  dt
}

#' Return basin metadata for the given level
#'
#' Reads the location static file which contains basin identifiers and
#' spatial/administrative metadata.
#'
#' @param level Character. One of \code{"L1"}, \code{"L2"}, \code{"L3"}, \code{"L4"}.
#' @param cache Logical. Default \code{FALSE}.
#' @return A \code{data.table} with columns \code{Basin_ID}, \code{lat}, \code{lng},
#'   \code{country}, \code{country_iso3} (plus any additional location columns).
#' @export
#' @examples
#' \dontrun{
#' meta <- ca_basins(level = "L1")
#' }
ca_basins <- function(level = "L1", cache = FALSE) {
  validate_level(level)
  url <- url_static(level, "location")
  tbl <- read_parquet_url(url, cache = cache)
  dt  <- data.table::as.data.table(tbl)
  keep <- intersect(c("Basin_ID", "lat", "lng", "country", "country_iso3"), names(dt))
  dt[, ..keep]
}

#' Print a summary of the CAMELS-Afr dataset
#'
#' Prints basin counts, attribute count, date range, and CDN URL to the console.
#'
#' @return Invisibly returns \code{NULL}. Called for its side effect.
#' @export
#' @examples
#' ca_info()
ca_info <- function() {
  cat("CAMELS-Afr dataset summary\n")
  cat("  Levels:\n")
  cat("    L1:  37 basins\n")
  cat("    L2:  238 basins\n")
  cat("    L3:  3,533 basins\n")
  cat("    L4:  12,129 basins\n")
  cat("  Static attributes: 216 per basin (climate, hydrology, location, geology, soil, land cover)\n")
  cat("  Timeseries: daily / monthly / annual (1980-2024)\n")
  cat("  Precipitation products: ARC, CHIRPS, IMERG, MSWEP\n")
  cat("  CDN:", "https://d3w56ds7wplvdd.cloudfront.net/parquet/", "\n")
  cat("  Cache:", tools::R_user_dir("camelsafr", "cache"), "\n")
  invisible(NULL)
}

#' Return climate timeseries for the given level and frequency
#'
#' @param level Character. One of \code{"L1"}, \code{"L2"}, \code{"L3"}, \code{"L4"}.
#' @param basin_ids Character vector or \code{NULL}. Filter to specific basins.
#'   \code{NULL} returns all basins.
#' @param freq Character. One of \code{"daily"}, \code{"monthly"}, \code{"annual"}.
#'   Default \code{"annual"}.
#' @param variables Character vector or \code{NULL}. Columns to return (excluding
#'   \code{Basin_ID} and the time column, which are always included). \code{NULL}
#'   returns all columns.
#' @param cache Logical. Default \code{FALSE}.
#' @return A \code{data.table}.
#' @export
#' @examples
#' \dontrun{
#' ts <- ca_timeseries("L1", basin_ids = c("L1_001"), freq = "annual",
#'                     variables = c("p_arc", "pet_mean"))
#' }
ca_timeseries <- function(level = "L1", basin_ids = NULL, freq = "annual",
                           variables = NULL, cache = FALSE) {
  validate_level(level)
  validate_freq(freq)

  time_col   <- if (freq == "annual") "Year" else "Date"
  url        <- url_timeseries(level, freq)
  col_select <- if (is.null(variables)) NULL else c("Basin_ID", time_col, variables)

  tbl <- tryCatch(
    read_parquet_url(url, cache = cache, col_select = col_select),
    error = function(e) {
      stop(sprintf("Failed to fetch timeseries from %s: %s", url, conditionMessage(e)),
           call. = FALSE)
    }
  )

  if (!is.null(basin_ids)) {
    tbl <- dplyr::filter(tbl, Basin_ID %in% basin_ids)
  }

  data.table::as.data.table(tbl)
}
