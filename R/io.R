#' @keywords internal
cache_path <- function(level, filename) {
  root <- tools::R_user_dir("camelsafr", "cache")
  file.path(root, level, filename)
}

#' @keywords internal
download_parquet <- function(url, dest) {
  dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
  utils::download.file(url, dest, mode = "wb", quiet = TRUE)
  invisible(NULL)
}

#' Read a Parquet file from URL with optional local cache
#'
#' @param url Character. Full URL to a Parquet file.
#' @param col_select Character vector of columns to read, or NULL for all.
#' @param filters Named list of equality filters, e.g. `list(Basin_ID = c("L1_001"))`.
#' @param cache Logical. Cache downloaded file locally? Default FALSE.
#' @return A `data.table`.
#' @keywords internal
read_parquet_url <- function(url, col_select = NULL, filters = NULL, cache = FALSE) {
  if (cache) {
    filename <- basename(url)
    level    <- strsplit(filename, "_")[[1L]][[1L]]
    local    <- cache_path(level, filename)
    if (!file.exists(local)) {
      download_parquet(url, local)
    }
    source <- local
  } else {
    source <- url
  }

  tbl <- arrow::read_parquet(source, col_select = col_select, as_data_frame = FALSE)

  if (!is.null(filters)) {
    # ponytail: simple equality-only filter; use arrow dplyr for range/complex filters if needed
    for (col in names(filters)) {
      vals <- filters[[col]]
      tbl  <- dplyr::filter(tbl, .data[[col]] %in% vals)
    }
  }

  data.table::as.data.table(tbl)
}

#' Clear the camelsafr local Parquet cache
#'
#' @param level Character. If NULL (default), clears the entire cache.
#'   Otherwise clears only the cache for the given level (e.g. "L1").
#' @return Invisible NULL.
#' @export
ca_clear_cache <- function(level = NULL) {
  root <- tools::R_user_dir("camelsafr", "cache")
  path <- if (is.null(level)) root else file.path(root, level)
  unlink(path, recursive = TRUE)
  invisible(NULL)
}
