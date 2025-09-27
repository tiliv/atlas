#!/usr/bin/env bash

set -euo pipefail
CITY_JSON=${1:-docs/_data/city.yml}
OUT=docs/_data/boundary.geo.json
mkdir -p data

name=$(ruby -ryaml -e 'p YAML.load_file(ARGV[0])["name"] rescue nil' "$CITY_JSON")
qid=$(ruby -ryaml -e 'p YAML.load_file(ARGV[0])["wikidata"] rescue nil' "$CITY_JSON")

if [[ -n "${qid}" && "${qid}" != "nil" ]]; then
  Q="${qid}"
  QUERY=$(ruby -ryaml -e 'cfg=YAML.load_file("docs/_data/layers.yml"); puts cfg["layers"]["city_boundary"]["overpass"].gsub("{{wikidata}}", '"$Q"')')
else
  N="${name:?provide name or wikidata in config/city.yml}"
  read -r -d '' QUERY <<EOF || true
[out:json][timeout:50];
area["name"="${N}"]["boundary"="administrative"]->.a;
rel(area.a)[type=boundary][boundary=administrative];
(._;>;); out body;
EOF
fi

curl -sS -G https://overpass-api.de/api/interpreter --data-urlencode "data=${QUERY}" \
| npx -y osmtogeojson > "$OUT"

echo "Boundary → $OUT"
