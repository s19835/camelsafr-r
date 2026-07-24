#' @keywords internal
VALID_LEVELS <- c("L1", "L2", "L3", "L4")

#' @keywords internal
VALID_FREQS <- c("daily", "monthly", "annual")

#' @keywords internal
STATIC_CATEGORIES <- c("climate", "hydrology", "location", "geology", "soil", "landcover")

#' @keywords internal
FREQ_TO_FILE <- c(daily = "climate_daily", monthly = "climate_monthly", annual = "climate_annual")

#' @keywords internal
validate_level <- function(level) {
  if (!level %in% VALID_LEVELS) {
    stop(sprintf('level must be one of %s, got "%s"',
                 paste(VALID_LEVELS, collapse = ", "), level),
         call. = FALSE)
  }
  invisible(level)
}

#' @keywords internal
validate_freq <- function(freq) {
  if (!freq %in% VALID_FREQS) {
    stop(sprintf('freq must be one of %s, got "%s"',
                 paste(VALID_FREQS, collapse = ", "), freq),
         call. = FALSE)
  }
  invisible(freq)
}
