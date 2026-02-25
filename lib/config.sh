#!/usr/bin/env bash
# config.sh — Configuration loader for surf-core CLI tools
# Sources HERMOD_URL and HERMOD_TOKEN from environment.

set -euo pipefail

# Resolve lib directory regardless of where the script is called from
SURF_CORE_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SURF_CORE_ROOT="$(cd "$SURF_CORE_LIB_DIR/.." && pwd)"

# Required environment variables
: "${HERMOD_URL:=https://api.asksurf.ai/gateway}"
: "${HERMOD_TOKEN:=}"

# Validate configuration
surf_check_setup() {
  local errors=0

  if [[ -z "$HERMOD_TOKEN" ]]; then
    echo '{"error": "HERMOD_TOKEN is not set. Export it before running this command."}' >&2
    errors=1
  fi

  if [[ -z "$HERMOD_URL" ]]; then
    echo '{"error": "HERMOD_URL is not set. Export it before running this command."}' >&2
    errors=1
  fi

  if [[ $errors -gt 0 ]]; then
    return 1
  fi

  echo "{\"status\": \"ok\", \"hermod_url\": \"$HERMOD_URL\"}"
  return 0
}
