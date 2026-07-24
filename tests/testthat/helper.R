# Shared test fixtures — loaded automatically by testthat

fake_dt <- data.table::data.table(
  Basin_ID     = c("L1_001", "L1_002"),
  p_mean       = c(450.2, 612.8),
  area_km2     = c(12340.5, 8901.2),
  lat          = c(-1.5, 3.2),
  lng          = c(28.4, 31.1),
  country      = c("Democratic Republic of the Congo", "Uganda"),
  country_iso3 = c("COD", "UGA")
)

fake_annual_dt <- data.table::data.table(
  Basin_ID = c("L1_001", "L1_001", "L1_002"),
  Year     = c(1980L, 1981L, 1980L),
  p_arc    = c(412.1, 398.7, 603.2),
  pet_mean = c(1201.4, 1198.3, 1344.5)
)

#' Create a minimal Arrow Table from a data.table for mocking
fake_arrow_table <- function(dt = fake_dt) {
  arrow::as_arrow_table(as.data.frame(dt))
}
