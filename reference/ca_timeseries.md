# Return climate timeseries for the given level and frequency

Return climate timeseries for the given level and frequency

## Usage

``` r
ca_timeseries(
  level = "L1",
  basin_ids = NULL,
  freq = "annual",
  variables = NULL,
  cache = FALSE
)
```

## Arguments

- level:

  Character. One of `"L1"`, `"L2"`, `"L3"`, `"L4"`.

- basin_ids:

  Character vector or `NULL`. Filter to specific basins. `NULL` returns
  all basins.

- freq:

  Character. One of `"daily"`, `"monthly"`, `"annual"`. Default
  `"annual"`.

- variables:

  Character vector or `NULL`. Columns to return (excluding `Basin_ID`
  and the time column, which are always included). `NULL` returns all
  columns.

- cache:

  Logical. Default `FALSE`.

## Value

A `data.table`.

## Examples

``` r
if (FALSE) { # \dontrun{
ts <- ca_timeseries("L1", basin_ids = c("L1_001"), freq = "annual",
                    variables = c("p_arc", "pet_mean"))
} # }
```
