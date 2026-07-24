test_that("cache_path returns correct path", {
  withr::with_envvar(list(R_USER_CACHE_DIR = tempdir()), {
    p <- cache_path("L1", "L1_climate_static.parquet")
    expect_true(grepl("camelsafr", p))
    expect_true(grepl("L1", p))
    expect_true(grepl("L1_climate_static\\.parquet$", p))
  })
})

test_that("read_parquet_url streams when cache=FALSE", {
  mock_tbl <- arrow::as_arrow_table(as.data.frame(fake_dt))
  mockery::stub(read_parquet_url, "arrow::read_parquet", function(...) mock_tbl)
  result <- read_parquet_url("https://example.com/fake.parquet", cache = FALSE)
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 2L)
})

test_that("read_parquet_url uses cache on second call", {
  tmp <- tempfile(fileext = ".parquet")
  arrow::write_parquet(as.data.frame(fake_dt), tmp)

  mockery::stub(read_parquet_url, "cache_path", function(...) tmp)
  # file already exists — download_parquet should NOT be called
  download_called <- FALSE
  mockery::stub(read_parquet_url, "download_parquet",
                function(...) { download_called <<- TRUE })

  result <- read_parquet_url("https://example.com/fake.parquet", cache = TRUE)
  expect_false(download_called)
  expect_s3_class(result, "data.table")
})

test_that("read_parquet_url downloads on cache miss", {
  tmp <- tempfile(fileext = ".parquet")  # does not exist yet

  mockery::stub(read_parquet_url, "cache_path", function(...) tmp)
  mockery::stub(read_parquet_url, "download_parquet", function(url, dest) {
    arrow::write_parquet(as.data.frame(fake_dt), dest)
  })

  result <- read_parquet_url("https://example.com/fake.parquet", cache = TRUE)
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 2L)
})

test_that("read_parquet_url applies col_select", {
  mock_tbl <- arrow::as_arrow_table(as.data.frame(fake_dt))
  mockery::stub(read_parquet_url, "arrow::read_parquet", function(...) mock_tbl)
  result <- read_parquet_url("https://example.com/fake.parquet",
                             col_select = c("Basin_ID", "lat"), cache = FALSE)
  expect_true("Basin_ID" %in% names(result))
  expect_true("lat" %in% names(result))
})

test_that("ca_clear_cache removes level cache", {
  root <- tools::R_user_dir("camelsafr", "cache")
  dir.create(file.path(root, "L1"), recursive = TRUE, showWarnings = FALSE)
  ca_clear_cache("L1")
  expect_false(dir.exists(file.path(root, "L1")))
})

test_that("ca_clear_cache with NULL removes entire cache", {
  root <- tools::R_user_dir("camelsafr", "cache")
  dir.create(file.path(root, "L2"), recursive = TRUE, showWarnings = FALSE)
  ca_clear_cache()
  expect_false(dir.exists(root))
})

test_that("download_parquet creates directory and calls download.file", {
  tmp_dir <- tempfile()
  dest <- file.path(tmp_dir, "test.parquet")
  called_with <- NULL
  mockery::stub(download_parquet, "utils::download.file",
                function(url, destfile, mode, quiet) {
                  called_with <<- list(url = url, dest = destfile)
                  invisible(0L)
                })
  download_parquet("https://example.com/test.parquet", dest)
  expect_true(dir.exists(tmp_dir))
  expect_equal(called_with$url, "https://example.com/test.parquet")
  expect_equal(called_with$dest, dest)
})
