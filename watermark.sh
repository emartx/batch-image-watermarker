#!/bin/bash

INPUT="input"
OUTPUT="output"
WATERMARK="watermark.png"
LOG_FILE="$OUTPUT/watermark.log"

mkdir -p "$OUTPUT"

processed=0
failed=0

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Start a fresh log file
: > "$LOG_FILE"

log "=== Watermark process started ==="
log "Input: $INPUT"
log "Output: $OUTPUT"
log "Watermark: $WATERMARK"

for img in "$INPUT"/*.{jpg,jpeg,png,webp}; do
  [ -e "$img" ] || continue

  filename=$(basename "$img")

  width=$(magick identify -format "%w" "$img" 2>/dev/null)

  if [ -z "$width" ]; then
    log "ERROR: Could not read image: $filename"
    ((failed++))
    continue
  fi

  wm_width=$((width * 20 / 100))
  margin_x=$((width * 4 / 100))
  margin_y=$((width * 2 / 100))

  log "Processing: $filename"
  log "  Image width: ${width}px"
  log "  Watermark width: ${wm_width}px"
  log "  Margin X: ${margin_x}px"
  log "  Margin Y: ${margin_y}px"

  if magick "$img" \
    \( "$WATERMARK" \
       -resize "${wm_width}x" \
       -channel A -evaluate multiply 0.45 +channel \
    \) \
    -gravity southwest \
    -geometry "+${margin_x}+${margin_y}" \
    -composite \
    "$OUTPUT/$filename"
  then
    log "  OK → $OUTPUT/$filename"
    ((processed++))
  else
    log "  ERROR: Failed to process $filename"
    ((failed++))
  fi
done

log "=== Process finished ==="
log "Successfully processed: $processed"
log "Failed: $failed"