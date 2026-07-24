# camelsafr <small style="font-size:0.5em;font-weight:400;color:#6b7280;">R package</small>

One-line access to the [CAMELS-Afr](https://github.com/s19835/camelsafr-r) African basin hydrological database — 12,129 basins, 216 attributes, 44 years of daily climate data.

## Install

```r
# Development version
remotes::install_github("s19835/camelsafr-r")
```

## Core functions

<div class="ca-cards">
  <div class="ca-card">
    <div class="ca-card-fn">ca_attrs()</div>
    <div class="ca-card-desc">Static basin attributes — 216 columns across climate, hydrology, soil, geology, land cover, and location for L1–L4.</div>
  </div>
  <div class="ca-card">
    <div class="ca-card-fn">ca_timeseries()</div>
    <div class="ca-card-desc">Daily, monthly, or annual climate series. Filter by basin IDs and select variables. Returns a data.table.</div>
  </div>
  <div class="ca-card">
    <div class="ca-card-fn">ca_basins()</div>
    <div class="ca-card-desc">Basin metadata — Basin_ID, centroid lat/lng, country, country_iso3 for any level.</div>
  </div>
</div>

[Read the quickstart →](articles/quickstart.html)
