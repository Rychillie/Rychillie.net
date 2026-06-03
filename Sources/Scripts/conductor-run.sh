#!/bin/zsh

set -e
set -u
set -o pipefail

PORT="${CONDUCTOR_PORT:-3000}"

exec saga dev --port "$PORT"
