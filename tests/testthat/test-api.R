# ── ca_attrs ─────────────────────────────────────────────────────────────────

test_that("ca_attrs rejects invalid level", {
  expect_error(ca_attrs("L99"), "level must be one of")
})

test_that("ca_attrs merges 6 static files", {
  mockery::stub(ca_attrs, "read_parquet_url", function(url, ...) {
    fake_dt[, .(Basin_ID, p_mean)]  # minimal per-file return
  })
  result <- ca_attrs("L1")
  expect_s3_class(result, "data.table")
  expect_true("Basin_ID" %in% names(result))
})

test_that("ca_attrs skips files that error", {
  call_count <- 0L
  mockery::stub(ca_attrs, "read_parquet_url", function(url, ...) {
    call_count <<- call_count + 1L
    if (call_count == 1L) stop("HTTP 404")
    fake_dt[, .(Basin_ID, p_mean)]
  })
  expect_warning(result <- ca_attrs("L1"), regexp = "Skipping category")
  expect_s3_class(result, "data.table")
})

test_that("ca_attrs stops when all 6 files fail", {
  mockery::stub(ca_attrs, "read_parquet_url", function(...) stop("HTTP 500"))
  expect_error(ca_attrs("L1"), "No static data")
})

# ── ca_basins ─────────────────────────────────────────────────────────────────

test_that("ca_basins rejects invalid level", {
  expect_error(ca_basins("L0"), "level must be one of")
})

test_that("ca_basins returns Basin_ID lat lng country columns", {
  mockery::stub(ca_basins, "read_parquet_url", function(...) fake_dt)
  result <- ca_basins("L1")
  expect_true(all(c("Basin_ID", "lat", "lng", "country") %in% names(result)))
})

# ── ca_info ───────────────────────────────────────────────────────────────────

test_that("ca_info prints without error", {
  expect_output(ca_info(), "L1")
  expect_output(ca_info(), "37")
  expect_output(ca_info(), "1980")
})

# ── ca_clear_cache ────────────────────────────────────────────────────────────

test_that("ca_clear_cache removes all cache files", {
  tmp <- tempfile()
  dir.create(file.path(tmp, "L1"), recursive = TRUE)
  file.create(file.path(tmp, "L1", "test.parquet"))
  mockery::stub(ca_clear_cache, "tools::R_user_dir", function(...) tmp)
  ca_clear_cache()
  expect_false(dir.exists(tmp))
})

test_that("ca_clear_cache with level removes only that level", {
  tmp <- tempfile()
  dir.create(file.path(tmp, "L1"), recursive = TRUE)
  dir.create(file.path(tmp, "L2"), recursive = TRUE)
  mockery::stub(ca_clear_cache, "tools::R_user_dir", function(...) tmp)
  ca_clear_cache(level = "L1")
  expect_false(dir.exists(file.path(tmp, "L1")))
  expect_true(dir.exists(file.path(tmp, "L2")))
})

test_that("ca_clear_cache on empty cache is safe", {
  mockery::stub(ca_clear_cache, "tools::R_user_dir", function(...) tempfile())
  expect_invisible(ca_clear_cache())
})

# ── ca_timeseries ─────────────────────────────────────────────────────────────

test_that("ca_timeseries rejects invalid level", {
  expect_error(ca_timeseries(level = "L99"), "level must be one of")
})

test_that("ca_timeseries rejects invalid freq", {
  expect_error(ca_timeseries(level = "L1", freq = "decadal"), "freq must be one of")
})

test_that("ca_timeseries returns data.table", {
  mockery::stub(ca_timeseries, "read_parquet_url",
                function(...) fake_arrow_table(fake_annual_dt))
  result <- ca_timeseries(level = "L1", freq = "annual")
  expect_s3_class(result, "data.table")
})

test_that("ca_timeseries filters by basin_ids", {
  mockery::stub(ca_timeseries, "read_parquet_url",
                function(...) fake_arrow_table(fake_annual_dt))
  result <- ca_timeseries(level = "L1", freq = "annual", basin_ids = "L1_001")
  expect_true(all(result$Basin_ID == "L1_001"))
  expect_equal(nrow(result), 2L)  # fake_annual_dt has 2 rows for L1_001
})

test_that("ca_timeseries selects variables + Basin_ID + time col", {
  mockery::stub(ca_timeseries, "read_parquet_url",
                function(url, cache = FALSE, col_select = NULL) {
                  tbl <- fake_arrow_table(fake_annual_dt)
                  if (!is.null(col_select)) tbl <- tbl$select(col_select)
                  tbl
                })
  result <- ca_timeseries(level = "L1", freq = "annual", variables = "p_arc")
  expect_true("Basin_ID" %in% names(result))
  expect_true("Year" %in% names(result))
  expect_true("p_arc" %in% names(result))
  expect_false("pet_mean" %in% names(result))
})

test_that("ca_timeseries uses correct URL for annual", {
  captured_url <- NULL
  mockery::stub(ca_timeseries, "read_parquet_url", function(url, ...) {
    captured_url <<- url
    fake_arrow_table(fake_annual_dt)
  })
  ca_timeseries(level = "L2", freq = "annual")
  expect_true(grepl("L2_climate_annual\\.parquet$", captured_url))
})

test_that("ca_timeseries daily uses Date as time column", {
  daily_dt <- data.table::data.table(
    Basin_ID = "L1_001", Date = as.Date("1980-01-01"), p_arc = 1.2
  )
  mockery::stub(ca_timeseries, "read_parquet_url",
                function(...) fake_arrow_table(daily_dt))
  result <- ca_timeseries(level = "L1", freq = "daily", variables = "p_arc")
  expect_true("Date" %in% names(result))
  expect_false("Year" %in% names(result))
})

test_that("ca_timeseries stops with URL on fetch error", {
  mockery::stub(ca_timeseries, "read_parquet_url", function(...) stop("connection refused"))
  expect_error(ca_timeseries("L1", freq = "annual"), regexp = "Failed to fetch")
})
