#!/usr/bin/env bash

set -euo pipefail
OUT="docs/map/city.pmtiles"
# Tippecanoe: turn selected GeoJSONs into a PMTiles pack
tippecanoe -o "$OUT" -Z8 -z16 --force \
  -L highways_major:docs/map/layers/highways_major.geo.json \
  -L bikeways:docs/map/layers/bikeways.geo.json \
  -L parks:docs/map/layers/parks.geo.json \
  -L water:docs/map/layers/water.geo.json \
  -L buildings:docs/map/layers/buildings.geo.json
echo "PMTiles → $OUT"
