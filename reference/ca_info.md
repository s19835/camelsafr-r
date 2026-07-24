# Print a summary of the CAMELS-Afr dataset

Prints basin counts, attribute count, date range, and CDN URL to the
console.

## Usage

``` r
ca_info()
```

## Value

Invisibly returns `NULL`. Called for its side effect.

## Examples

``` r
ca_info()
#> CAMELS-Afr dataset summary
#>   Levels:
#>     L1:  37 basins
#>     L2:  238 basins
#>     L3:  3,533 basins
#>     L4:  12,129 basins
#>   Static attributes: 216 per basin (climate, hydrology, location, geology, soil, land cover)
#>   Timeseries: daily / monthly / annual (1980-2024)
#>   Precipitation products: ARC, CHIRPS, IMERG, MSWEP
#>   CDN: https://d3w56ds7wplvdd.cloudfront.net/parquet/ 
#>   Cache: /home/runner/.cache/R/camelsafr 
```
