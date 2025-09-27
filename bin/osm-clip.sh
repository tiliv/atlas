#!/usr/bin/env bash

set -euo pipefail
BASE_PBF="docs/_data/base.osm.pbf"
POLY="docs/_data/boundary.geo.json"
CLIPPED="docs/_data/city.osm.pbf"

mkdir -p data
# Convert boundary GeoJSON → .poly (osmium accepts GeoJSON too, but .poly is robust)
npx -y @mapbox/geojson-area >/dev/null 2>&1 || true  # warm cache (no-op)
echo "Clipping base extract to boundary…"
osmium extract --polygon "$POLY" -o "$CLIPPED" "$BASE_PBF"
echo "Clipped → $CLIPPED"
