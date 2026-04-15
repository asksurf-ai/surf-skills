#!/bin/bash
# update.sh — Update skill, CLI, and API spec.
#
# 1. Downloads latest SKILL.md and scripts from GitHub release
# 2. Runs surf install (update CLI binary)
# 3. Runs surf sync (refresh API spec cache)
#
# Usage: bash update.sh

set -euo pipefail

REPO="asksurf-ai/surf-skills"
SKILL_PATH="skills/surf/SKILL.md"

# ── Find local SKILL.md ──────────────────────────────────────────────

LOCAL=""
for candidate in \
    "${BASH_SOURCE[0]%/scripts/*}/SKILL.md" \
    "$HOME/.claude/skills/surf/SKILL.md" \
    ; do
    if [ -f "$candidate" ]; then
        LOCAL="$candidate"
        break
    fi
done

if [ -z "$LOCAL" ]; then
    echo "Error: cannot find local SKILL.md" >&2
    exit 1
fi

SKILL_DIR="$(dirname "$LOCAL")"

# ── Update skill from latest release ────────────────────────────────

release_tag=$(curl -sfL --max-time 5 "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | head -1 | sed 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/' || true)

if [ -n "$release_tag" ]; then
    RAW_URL="https://raw.githubusercontent.com/$REPO/$release_tag"
    remote_version="${release_tag#v}"

    echo "Updating skill to v$remote_version..."

    # Update SKILL.md
    if curl -sfL --max-time 10 "$RAW_URL/$SKILL_PATH" -o "$LOCAL.tmp" 2>/dev/null; then
        mv "$LOCAL.tmp" "$LOCAL"
    else
        rm -f "$LOCAL.tmp"
        echo "Warning: failed to download SKILL.md" >&2
    fi

    # Update scripts
    mkdir -p "$SKILL_DIR/scripts"
    for script in check-for-updates.sh update.sh; do
        curl -sfL --max-time 10 "$RAW_URL/skills/surf/scripts/$script" -o "$SKILL_DIR/scripts/$script.tmp" 2>/dev/null && \
            mv "$SKILL_DIR/scripts/$script.tmp" "$SKILL_DIR/scripts/$script" && \
            chmod +x "$SKILL_DIR/scripts/$script" || true
    done

    echo "Skill updated to v$remote_version."
else
    echo "Warning: could not fetch latest release, skipping skill update" >&2
fi

# ── Update CLI and sync ─────────────────────────────────────────────

echo ""
surf install
echo ""
surf sync
