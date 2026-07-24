# Clear the camelsafr local Parquet cache

Clear the camelsafr local Parquet cache

## Usage

``` r
ca_clear_cache(level = NULL)
```

## Arguments

- level:

  Character. If NULL (default), clears the entire cache. Otherwise
  clears only the cache for the given level (e.g. "L1").

## Value

Invisible NULL.

## Examples

``` r
ca_clear_cache()
```
