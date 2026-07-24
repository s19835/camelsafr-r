One-line access to the
[CAMELS-Afr](https://github.com/s19835/camelsafr-r) African basin
hydrological database — 12,129 basins, 216 attributes, 44 years of daily
climate data.

## Install

``` r
# Development version
remotes::install_github("s19835/camelsafr-r")
```

## Core functions

``` R
<div class="ca-card-fn">ca_attrs()</div>
<div class="ca-card-desc">Static basin attributes — 216 columns across climate, hydrology, soil, geology, land cover, and location for L1–L4.</div>
```

``` R
<div class="ca-card-fn">ca_timeseries()</div>
<div class="ca-card-desc">Daily, monthly, or annual climate series. Filter by basin IDs and select variables. Returns a data.table.</div>
```

``` R
<div class="ca-card-fn">ca_basins()</div>
<div class="ca-card-desc">Basin metadata — Basin_ID, centroid lat/lng, country, country_iso3 for any level.</div>
```

[Read the quickstart
→](https://s19835.github.io/camelsafr-r/articles/quickstart.md)
