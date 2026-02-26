#!/usr/bin/env bash
# build-skills.sh — Build runtime SKILL.md files by combining templates with knowledge.
#
# For each runtime/{type}/{domain}/:
#   1. Read build.conf for INCLUDE list and template variables
#   2. Copy SKILL.md template, replacing {{VAR}} placeholders
#   3. Append knowledge files listed in INCLUDE after the "## Knowledge" marker
#   4. Write result to dist/{type}/{domain}/SKILL.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RUNTIMES_DIR="$ROOT/runtimes"
KNOWLEDGE_DIR="$ROOT/knowledge"
DIST_DIR="$ROOT/dist"

built=0
errors=0

for conf_file in "$RUNTIMES_DIR"/*/*/build.conf; do
  [[ -f "$conf_file" ]] || continue

  runtime_dir="$(dirname "$conf_file")"
  # e.g., runtimes/http/market -> type=http, domain=market
  domain="$(basename "$runtime_dir")"
  type_dir="$(basename "$(dirname "$runtime_dir")")"

  template="$runtime_dir/SKILL.md"
  if [[ ! -f "$template" ]]; then
    echo "WARN: No SKILL.md in $runtime_dir — skipping"
    continue
  fi

  # Parse build.conf
  INCLUDE=""
  BASE_URL_VAR=""
  AUTH_NOTE=""
  while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$key" ]] && continue
    key="$(echo "$key" | xargs)"
    value="$(echo "$value" | xargs)"
    case "$key" in
      INCLUDE) INCLUDE="$value" ;;
      BASE_URL_VAR) BASE_URL_VAR="$value" ;;
      AUTH_NOTE) AUTH_NOTE="$value" ;;
    esac
  done < "$conf_file"

  # Build output
  out_dir="$DIST_DIR/$type_dir/$domain"
  mkdir -p "$out_dir"

  # Read template and replace variables
  content="$(cat "$template")"
  if [[ -n "$BASE_URL_VAR" ]]; then
    content="${content//\$\{\{BASE_URL_VAR\}\}/\$$BASE_URL_VAR}"
  fi
  if [[ -n "$AUTH_NOTE" ]]; then
    content="${content//\{\{AUTH_NOTE\}\}/$AUTH_NOTE}"
  fi

  # Split at "## Knowledge" marker — keep everything before it (inclusive)
  if echo "$content" | grep -q "^## Knowledge"; then
    header="$(echo "$content" | sed '/^## Knowledge/q')"
  else
    header="$content"
  fi

  # Append knowledge files
  knowledge_section=""
  if [[ -n "$INCLUDE" ]]; then
    for f in $INCLUDE; do
      kfile="$KNOWLEDGE_DIR/$domain/$f"
      if [[ -f "$kfile" ]]; then
        knowledge_section="${knowledge_section}
---

$(cat "$kfile")"
      else
        echo "WARN: Knowledge file not found: $kfile"
        ((errors++)) || true
      fi
    done
  fi

  # Write final output
  echo "${header}${knowledge_section}" > "$out_dir/SKILL.md"

  # Copy scripts if they exist in runtime dir
  if [[ -d "$runtime_dir/scripts" ]]; then
    cp -r "$runtime_dir/scripts" "$out_dir/"
  fi

  ((built++)) || true
  echo "OK: $type_dir/$domain"
done

echo ""
echo "Build complete: $built skills built, $errors warnings"

if [[ $errors -gt 0 ]]; then
  exit 1
fi
