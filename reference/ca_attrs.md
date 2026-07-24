# Return all static attributes for every basin at the given level

Reads and merges the six static-attribute Parquet files (climate,
hydrology, location, geology, soil, landcover) into a single wide
`data.table`. Files that fail (e.g. HTTP 404) are skipped with a
[`warning()`](https://rdrr.io/r/base/warning.html); if every file fails
the function stops with a friendly message.

## Usage

``` r
ca_attrs(level = "L1", cache = FALSE)
```

## Arguments

- level:

  Character. One of `"L1"`, `"L2"`, `"L3"`, `"L4"`.

- cache:

  Logical. Cache Parquet locally on first call. Default `FALSE`.

## Value

A `data.table` with one row per basin and 216+ attribute columns.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- ca_attrs(level = "L1")
} # }
```
