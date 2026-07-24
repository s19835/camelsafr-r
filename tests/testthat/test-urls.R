test_that("url_static builds correct URL", {
  expect_equal(
    url_static("L1", "climate"),
    "https://d3w56ds7wplvdd.cloudfront.net/parquet/L1_climate_static.parquet"
  )
  expect_equal(
    url_static("L3", "soil"),
    "https://d3w56ds7wplvdd.cloudfront.net/parquet/L3_soil_static.parquet"
  )
})

test_that("url_timeseries builds correct URL", {
  expect_equal(
    url_timeseries("L2", "annual"),
    "https://d3w56ds7wplvdd.cloudfront.net/parquet/L2_climate_annual.parquet"
  )
  expect_equal(
    url_timeseries("L4", "daily"),
    "https://d3w56ds7wplvdd.cloudfront.net/parquet/L4_climate_daily.parquet"
  )
})

test_that("url_static covers all static categories", {
  urls <- vapply(STATIC_CATEGORIES, url_static, character(1), level = "L1")
  expect_length(urls, 6L)
  expect_true(all(grepl("_static\\.parquet$", urls)))
})

test_that("url_timeseries covers all freqs", {
  urls <- vapply(VALID_FREQS, url_timeseries, character(1), level = "L1")
  expect_length(urls, 3L)
  expect_true(all(grepl("\\.parquet$", urls)))
})
