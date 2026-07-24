# Getting Started with camelsafr

## Installation

Install the released version from CRAN:

``` r
install.packages("camelsafr")
```

Or the development version from GitHub:

``` r
remotes::install_github("s19835/camelsafr-r")
```

## Dataset overview

[`ca_info()`](https://s19835.github.io/camelsafr-r/reference/ca_info.md)
prints a summary of the four basin levels:

``` r
library(camelsafr)
ca_info()
```

## Static attributes

Load all 216 static attributes for L1 (37 basins):

``` r
dt <- ca_attrs(level = "L1")
print(dt[, 1:5])
```

## Annual timeseries

Query annual precipitation for two basins across all four products:

``` r
ts <- ca_timeseries(
  level     = "L1",
  basin_ids = c("L1_001", "L1_002"),
  freq      = "annual",
  variables = c("p_arc", "p_chirps", "p_imerg", "p_mswep")
)
print(head(ts))
```

Plot annual ARC precipitation:

``` r
library(ggplot2)

ggplot(ts, aes(x = Year, y = p_arc, colour = Basin_ID)) +
  geom_line() +
  labs(title = "Annual ARC precipitation", y = "mm/year") +
  theme_minimal()
```

## Basin metadata

``` r
meta <- ca_basins(level = "L2")
print(head(meta))
```

## Caching

Data is downloaded once to `~/.cache/camelsafr/` and reused on
subsequent calls. Free disk space with
[`ca_clear_cache()`](https://s19835.github.io/camelsafr-r/reference/ca_clear_cache.md):

``` r
dt <- ca_attrs(level = "L3", cache = TRUE)

# Remove cached L3 files
ca_clear_cache(level = "L3")
```
