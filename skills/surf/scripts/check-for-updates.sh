#!/bin/bash
# check-for-updates.sh — Check if skill or CLI updates are needed.
#
# 1. Compares local SKILL.md metadata.version against latest GitHub release tag
# 2. Checks if installed surf CLI version meets the compatibility requirement
#
# Only prints messages when action is needed. Does NOT perform updates.
#
# Usage: bash check-for-updates.sh

set -euo pipefail

REPO="asksurf-ai/surf-skills"

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
    exit 0
fi

SKILL_DIR="$(dirname "$LOCAL")"

# ── Parse local frontmatter ──────────────────────────────────────────

local_version=$(grep -A1 'metadata:' "$LOCAL" 2>/dev/null | grep 'version:' | head -1 | sed 's/.*version:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}/\1/' || true)
compat=$(grep 'compatibility:' "$LOCAL" 2>/dev/null | head -1 | sed 's/.*compatibility:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}/\1/' || true)

# ── Check CLI compatibility ──────────────────────────────────────────

if [ -n "$compat" ]; then
    required_version=$(echo "$compat" | sed 's/.*>=[[:space:]]*//')
    if [ -n "$required_version" ] && command -v surf &>/dev/null; then
        installed_version=$(surf version 2>/dev/null | sed 's/surf[[:space:]]*//')
        if [ -n "$installed_version" ] && [[ "$installed_version" < "$required_version" ]]; then
            echo "⚠ Surf CLI update required: $installed_version → $required_version"
            echo "  Run: surf install"
        fi
    fi
fi

# ── Check skill version ─────────────────────────────────────────────

if [ -n "$local_version" ]; then
    release_tag=$(curl -sfL --max-time 3 "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | head -1 | sed 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/' || true)
    remote_version="${release_tag#v}"

    if [ -n "$remote_version" ] && [ "$local_version" != "$remote_version" ]; then
        echo "⚠ Surf skill update available: v$local_version → v$remote_version"
        echo "  Run: bash $SKILL_DIR/scripts/update.sh"
    fi
fi
