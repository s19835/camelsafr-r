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
