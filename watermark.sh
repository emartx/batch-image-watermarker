#!/bin/bash

INPUT="input"
OUTPUT="output"
WATERMARK="watermark.png"

mkdir -p "$OUTPUT"

for img in "$INPUT"/*.{jpg,jpeg,png,webp}; do
  [ -e "$img" ] || continue

  filename=$(basename "$img")
  width=$(magick identify -format "%w" "$img")

  wm_width=$((width * 20 / 100))
  margin_x=$((width * 4 / 100))
  margin_y=$((width * 2 / 100))

  magick "$img" \
    \( "$WATERMARK" \
       -resize "${wm_width}x" \
       -channel A -evaluate multiply 0.45 +channel \
    \) \
    -gravity southwest \
    -geometry "+${margin_x}+${margin_y}" \
    -composite \
    "$OUTPUT/$filename"
done
