#' @keywords internal
CDN_BASE <- "https://d3w56ds7wplvdd.cloudfront.net/parquet"

#' @keywords internal
url_static <- function(level, category) {
  validate_level(level)
  if (!category %in% STATIC_CATEGORIES) {
    stop(sprintf('category must be one of %s, got "%s"',
                 paste(STATIC_CATEGORIES, collapse = ", "), category),
         call. = FALSE)
  }
  sprintf("%s/%s_%s_static.parquet", CDN_BASE, level, category)
}

#' @keywords internal
url_timeseries <- function(level, freq) {
  validate_level(level)
  validate_freq(freq)
  sprintf("%s/%s_%s.parquet", CDN_BASE, level, FREQ_TO_FILE[[freq]])
}
