#!/usr/bin/env bash

set -euo pipefail
OUT="docs/map/osm/city.pmtiles"
# Tippecanoe: turn selected GeoJSONs into a PMTiles pack
tippecanoe -o "$OUT" -Z8 -z16 --force \
  -L highways_major:docs/map/osm/highways_major.geo.json \
  -L bikeways:docs/map/osm/bikeways.geo.json \
  -L parks:docs/map/osm/parks.geo.json \
  -L water:docs/map/osm/water.geo.json \
  -L buildings:docs/map/osm/buildings.geo.json
echo "PMTiles → $OUT"
