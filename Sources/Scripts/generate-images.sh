#!/bin/zsh

set -e
set -u
set -o pipefail

OUTPUT_ROOT="${1:-deploy}"
SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h:h}"
SOURCE_DIR="$REPO_ROOT/content/static/images"

if [[ "$OUTPUT_ROOT" = /* ]]; then
  OUTPUT_DIR="$OUTPUT_ROOT/static/images"
else
  OUTPUT_DIR="$REPO_ROOT/$OUTPUT_ROOT/static/images"
fi

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick was not found in PATH."
  echo "Install it with: brew install imagemagick"
  exit 1
fi

if [[ "${OUTPUT_DIR:A}" == "${SOURCE_DIR:A}" ]]; then
  echo "Refusing to write generated images into the source image directory."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

generated_sources=()

cleanup_variants() {
  local output_name="$1"

  rm -f "$OUTPUT_DIR/$output_name"-*.gif(N)
  rm -f "$OUTPUT_DIR/$output_name"-*.png(N)
  rm -f "$OUTPUT_DIR/$output_name"-*.webp(N)
}

generate_variant() {
  local source_name="$1"
  local output_name="$2"
  local width="$3"
  local height="$4"
  local source_path="$SOURCE_DIR/$source_name"
  local png_path="$OUTPUT_DIR/$output_name-$width.png"
  local webp_path="$OUTPUT_DIR/$output_name-$width.webp"

  if [[ ! -f "$source_path" ]]; then
    echo "Missing source image: $source_path"
    exit 1
  fi

  magick "$source_path" \
    -auto-orient \
    -resize "${width}x${height}^" \
    -gravity center \
    -extent "${width}x${height}" \
    -strip \
    -define png:compression-level=9 \
    "$png_path"

  magick "$png_path" \
    -quality 82 \
    "$webp_path"
}

generate_responsive_set() {
  local source_name="$1"
  local output_name="$2"
  local small_width="$3"
  local small_height="$4"
  local large_width="$5"
  local large_height="$6"

  cleanup_variants "$output_name"

  generate_variant "$source_name" "$output_name" "$small_width" "$small_height"
  generate_variant "$source_name" "$output_name" "$large_width" "$large_height"

  generated_sources+=("$source_name")
}

generate_wave_animation() {
  local source_name="wave.gif"
  local output_name="wave"
  local source_path="$SOURCE_DIR/$source_name"
  local gif_path="$OUTPUT_DIR/$output_name-58.gif"
  local webp_path="$OUTPUT_DIR/$output_name-58.webp"

  if [[ ! -f "$source_path" ]]; then
    echo "Missing source image: $source_path"
    exit 1
  fi

  cleanup_variants "$output_name"

  magick "$source_path" \
    -coalesce \
    -resize "58x56" \
    -layers Optimize \
    -strip \
    "$gif_path"

  magick "$source_path" \
    -coalesce \
    -resize "58x56" \
    -layers Optimize \
    -strip \
    -quality 80 \
    "$webp_path"

  generated_sources+=("$source_name")
}

remove_generated_sources() {
  local source_name

  for source_name in "${generated_sources[@]}"; do
    rm -f "$OUTPUT_DIR/$source_name"
  done
}

generate_responsive_set "bento-portrait-1.png" "bento-portrait-1" 312 448 624 896
generate_responsive_set "bento-portrait-2.png" "bento-portrait-2" 312 448 624 896
generate_responsive_set "bento-wide-1.png" "bento-wide-1" 312 216 624 432
generate_responsive_set "bento-wide-2.png" "bento-wide-2" 312 216 624 432
generate_responsive_set "youtube-avatar.png" "youtube-avatar" 64 64 128 128
generate_responsive_set "discord-avatar.png" "discord-avatar" 64 64 128 128
generate_responsive_set "chargeblast.png" "chargeblast" 48 48 96 96
generate_wave_animation

remove_generated_sources
