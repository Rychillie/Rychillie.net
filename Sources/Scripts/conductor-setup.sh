#!/bin/zsh

set -e
set -u
set -o pipefail

if ! command -v swift >/dev/null 2>&1; then
  echo "Swift was not found in PATH."
  exit 1
fi

if ! command -v saga >/dev/null 2>&1; then
  echo "Saga CLI was not found in PATH."
  echo "Install it with: brew install loopwerk/tap/saga"
  exit 1
fi

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick was not found in PATH."
  echo "Install it with: brew install imagemagick"
  exit 1
fi

SWIFT_VERSION="$(swift --version 2>&1 | sed -n '1p')"

echo "Swift: $SWIFT_VERSION"
echo "Saga CLI: $(command -v saga)"
echo "ImageMagick: $(command -v magick)"
echo "Conductor setup complete."
