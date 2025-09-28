#!/usr/bin/env bash

set -euo pipefail
PBF="docs/_data/city.osm.pbf"
CFG="docs/_data/layers.yml"
OUTDIR="docs/map/osm"
mkdir -p "$OUTDIR"

ruby -ryaml -e '
cfg = YAML.load_file(ARGV[0])["osm"]
cfg.each do |key, spec|
  next if key == "city_boundary"
  tf  = spec["tags_filter"]
  geom= (spec["geometry"] || "auto")
  puts [key, tf, geom].join("\t")
end
' "$CFG" | while IFS=$'\t' read -r KEY TF GEOM; do
  echo "Layer $KEY …"
  TMP="docs/_data/tmp_${KEY}.osm.pbf"
  osmium tags-filter -o "$TMP" "$PBF" $TF --overwrite
  # export to GeoJSON (lines/polys preserved); add bbox + properties
  osmium export "$TMP" -o "$OUTDIR/$KEY.geo.json" --overwrite
  rm -f "$TMP"
done

# Also export the boundary as a layer for convenience
cp docs/_data/boundary.geo.json "$OUTDIR/city_boundary.geo.json"
echo "Layers in $OUTDIR"
