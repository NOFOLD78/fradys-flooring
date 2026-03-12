#!/usr/bin/env bash
set -e

SRC_DIR="$(pwd)"
OUT_DIR="$SRC_DIR/final-webp"

mkdir -p "$OUT_DIR"

# Resize & convert JPG/PNG to WebP
TMP_DIR="$SRC_DIR/resized-tmp"
mkdir -p "$TMP_DIR"

for f in *.jpg *.jpeg *.png; do
  [ -e "$f" ] || continue
  convert "$f" -resize 1920x1920\> "$TMP_DIR/$f"
done

cd "$TMP_DIR"
for f in *.jpg *.jpeg *.png; do
  [ -e "$f" ] || continue
  cwebp -q 80 -mt "$f" -o "$OUT_DIR/${f%.*}.webp"
done
cd "$SRC_DIR"
rm -rf "$TMP_DIR"

# Re-compress existing WEBP files
for f in *.webp; do
  [ -e "$f" ] || continue
  cwebp -q 80 -mt "$f" -o "$OUT_DIR/$f"
done

echo "Done. WebP files are in: $OUT_DIR"

