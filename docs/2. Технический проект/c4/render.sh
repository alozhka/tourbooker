#!/usr/bin/env bash
# This script renders all PlantUML diagrams in the current directory to SVG files

set -euo pipefail

# Usage: bash render.sh /absolute/path/to/plantuml-1.2025.2.jar
jar="${1:-${PLANTUML_JAR:-}}"
if [[ -z "$jar" || ! -f "$jar" ]]; then
  echo "Usage: bash render.sh /path/to/plantuml-1.2025.2.jar" >&2
  exit 1
fi
jar="$(cd "$(dirname "$jar")" && pwd)/$(basename "$jar")"
cd "$(dirname "$0")"
# Validate every source before updating SVG files.
java -Djava.awt.headless=true -jar "$jar" -charset UTF-8 -checkonly 0*.puml
mkdir -p svg
for source in 0*.puml; do
  output="svg/${source%.puml}.svg"
  # Pipe output ignores optional diagram names after @startuml.
  java -Djava.awt.headless=true -jar "$jar" \
    -charset UTF-8 -tsvg -pipe < "$source" > "$output.tmp"
  mv "$output.tmp" "$output"
done
