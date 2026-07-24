# Return basin metadata for the given level

Reads the location static file which contains basin identifiers and
spatial/administrative metadata.

## Usage

``` r
ca_basins(level = "L1", cache = FALSE)
```

## Arguments

- level:

  Character. One of `"L1"`, `"L2"`, `"L3"`, `"L4"`.

- cache:

  Logical. Default `FALSE`.

## Value

A `data.table` with columns `Basin_ID`, `lat`, `lng`, `country`,
`country_iso3` (plus any additional location columns).

## Examples

``` r
if (FALSE) { # \dontrun{
meta <- ca_basins(level = "L1")
} # }
```
