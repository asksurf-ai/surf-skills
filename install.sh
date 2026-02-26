#!/usr/bin/env bash
set -euo pipefail

# surf-core skill installer
# Works with: Claude Code, OpenCode, Gemini CLI, GitHub Copilot, Codex
#
# What it does:
#   1. Symlinks skills to ~/.claude/skills/  (agent discovery)
#   2. Symlinks commands to ~/.surf-core/bin/ (execution via PATH)
#   3. Adds ~/.surf-core/bin to PATH         (shell rc)
#
# Usage:
#   ./install.sh            Install all skills globally
#   ./install.sh --list     List available skills
#   ./install.sh --remove   Uninstall skills + bin + PATH
#   ./install.sh --check    Verify installation status

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$SCRIPT_DIR/runtimes/cli"
SKILL_DIR="$HOME/.claude/skills"
BIN_DIR="$HOME/.surf-core/bin"
PATH_LINE='export PATH="$HOME/.surf-core/bin:$PATH"'
PATH_COMMENT="# surf-core CLI tools"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_get_skill_name() {
  grep '^name:' "$1/SKILL.md" 2>/dev/null | head -1 | sed 's/name: //'
}

_get_script_path() {
  # Find the main executable in scripts/ (the one without _ prefix)
  local d="$1"
  for f in "$d"/scripts/surf-*; do
    [ -x "$f" ] && basename "$f" | grep -qv '^_' && echo "$f" && return
  done
}

_shell_rcs() {
  local rcs=()
  # .zshenv is sourced by ALL zsh instances (interactive + non-interactive)
  # This is critical for tools like OpenCode that spawn non-interactive shells
  if [ "$(uname)" = "Darwin" ] || [ -n "${ZSH_VERSION:-}" ]; then
    rcs+=("$HOME/.zshenv")
  fi
  [ -f "$HOME/.bashrc" ] && rcs+=("$HOME/.bashrc")
  [ -f "$HOME/.bash_profile" ] && rcs+=("$HOME/.bash_profile")
  # Fallback
  if [ ${#rcs[@]} -eq 0 ]; then
    rcs+=("$HOME/.bashrc")
  fi
  echo "${rcs[@]}"
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_list() {
  echo "Available surf-core skills:"
  echo ""
  printf "  ${DIM}%-18s %-16s %s${NC}\n" "SKILL" "COMMAND" "DESCRIPTION"
  for d in "$CLI_DIR"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    local name=$(_get_skill_name "$d")
    local script=$(_get_script_path "$d")
    local cmd=""
    [ -n "$script" ] && cmd=$(basename "$script")
    local desc=$(grep '^description:' "$d/SKILL.md" | head -1 | sed 's/description: //')
    printf "  %-18s %-16s %s\n" "$name" "$cmd" "$desc"
  done
}

cmd_install() {
  echo "Installing surf-core..."
  echo ""

  # --- Step 1: Skill discovery (symlinks to ~/.claude/skills/) ---
  echo -e "${CYAN}[1/3]${NC} Skill discovery → $SKILL_DIR/"
  mkdir -p "$SKILL_DIR"
  local skill_count=0

  for d in "$CLI_DIR"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    local name=$(_get_skill_name "$d")
    local target="$SKILL_DIR/$name"

    if [ -L "$target" ]; then
      local existing=$(readlink "$target")
      if [ "$existing" = "$d" ]; then
        continue  # already correct
      fi
      rm "$target"
    elif [ -e "$target" ]; then
      echo -e "  ${YELLOW}skip${NC} $name (non-symlink exists)"
      continue
    fi

    ln -s "$d" "$target"
    echo -e "  ${GREEN}+${NC} $name"
    ((skill_count++))
  done
  [ $skill_count -eq 0 ] && echo -e "  ${DIM}all up to date${NC}"

  # --- Step 2: CLI commands (symlinks to ~/.surf-core/bin/) ---
  echo -e "${CYAN}[2/3]${NC} CLI commands → $BIN_DIR/"
  mkdir -p "$BIN_DIR"
  local bin_count=0

  for d in "$CLI_DIR"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    local script=$(_get_script_path "$d")
    [ -z "$script" ] && continue
    local cmd=$(basename "$script")
    local target="$BIN_DIR/$cmd"

    if [ -L "$target" ]; then
      local existing=$(readlink "$target")
      if [ "$existing" = "$script" ]; then
        continue
      fi
      rm "$target"
    elif [ -e "$target" ]; then
      echo -e "  ${YELLOW}skip${NC} $cmd (non-symlink exists)"
      continue
    fi

    ln -s "$script" "$target"
    echo -e "  ${GREEN}+${NC} $cmd"
    ((bin_count++))
  done
  [ $bin_count -eq 0 ] && echo -e "  ${DIM}all up to date${NC}"

  # --- Step 3: PATH ---
  echo -e "${CYAN}[3/3]${NC} PATH setup"

  if echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
    echo -e "  ${DIM}already in PATH${NC}"
  else
    local added_to=""
    for rc in $(_shell_rcs); do
      if ! grep -qF 'surf-core/bin' "$rc" 2>/dev/null; then
        echo "" >> "$rc"
        echo "$PATH_COMMENT" >> "$rc"
        echo "$PATH_LINE" >> "$rc"
        added_to="$added_to $(basename "$rc")"
      fi
    done

    if [ -n "$added_to" ]; then
      echo -e "  ${GREEN}added${NC} to$added_to"
      echo -e "  ${YELLOW}→ Run: source ~/.zshrc${NC} (or restart terminal)"
    else
      echo -e "  ${DIM}already configured${NC}"
    fi

    # Also export for current session
    export PATH="$BIN_DIR:$PATH"
  fi

  # --- Verify ---
  echo ""
  if command -v surf-session &>/dev/null || [ -x "$BIN_DIR/surf-session" ]; then
    if "$BIN_DIR/surf-session" check >/dev/null 2>&1; then
      echo -e "${GREEN}Ready.${NC} Session valid. Try: surf-market price --ids bitcoin --vs-currencies usd"
    else
      echo -e "${YELLOW}Installed, but no active session.${NC}"
      echo "  Run: surf-session login"
    fi
  else
    echo -e "${GREEN}Installed.${NC}"
  fi
}

cmd_remove() {
  echo "Removing surf-core..."
  echo ""

  # Remove skill symlinks
  local removed=0
  for d in "$CLI_DIR"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    local name=$(_get_skill_name "$d")
    local target="$SKILL_DIR/$name"
    if [ -L "$target" ] && [[ "$(readlink "$target")" == *"surf-core"* ]]; then
      rm "$target"
      echo -e "  ${RED}-${NC} skill: $name"
      ((removed++))
    fi
  done

  # Remove bin symlinks
  if [ -d "$BIN_DIR" ]; then
    for f in "$BIN_DIR"/surf-*; do
      [ -L "$f" ] || continue
      echo -e "  ${RED}-${NC} bin: $(basename "$f")"
      rm "$f"
      ((removed++))
    done
    rmdir "$BIN_DIR" 2>/dev/null || true
  fi

  # Remove PATH from shell rcs
  for rc in $(_shell_rcs); do
    if grep -qF 'surf-core/bin' "$rc" 2>/dev/null; then
      # Remove the PATH line and comment
      sed -i.bak '/# surf-core CLI tools/d' "$rc"
      sed -i.bak '/surf-core\/bin/d' "$rc"
      rm -f "${rc}.bak"
      echo -e "  ${RED}-${NC} PATH from $(basename "$rc")"
      ((removed++))
    fi
  done

  echo ""
  echo "Removed $removed items. Session file (~/.surf-core/session.json) kept."
}

cmd_check() {
  echo "surf-core installation status:"
  echo ""

  # Check skills
  local skill_ok=0 skill_broken=0
  for d in "$CLI_DIR"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    local name=$(_get_skill_name "$d")
    local target="$SKILL_DIR/$name"
    if [ -L "$target" ] && [ -e "$target" ]; then
      ((skill_ok++))
    else
      echo -e "  ${RED}missing${NC} skill: $name"
      ((skill_broken++))
    fi
  done
  echo -e "  Skills: ${GREEN}$skill_ok${NC} installed, ${RED}$skill_broken${NC} missing"

  # Check bin
  local bin_ok=0 bin_broken=0
  for d in "$CLI_DIR"/*/; do
    local script=$(_get_script_path "$d" 2>/dev/null)
    [ -z "$script" ] && continue
    local cmd=$(basename "$script")
    if [ -L "$BIN_DIR/$cmd" ] && [ -e "$BIN_DIR/$cmd" ]; then
      ((bin_ok++))
    else
      echo -e "  ${RED}missing${NC} bin: $cmd"
      ((bin_broken++))
    fi
  done
  echo -e "  Commands: ${GREEN}$bin_ok${NC} installed, ${RED}$bin_broken${NC} missing"

  # Check PATH
  if echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
    echo -e "  PATH: ${GREEN}configured${NC}"
  else
    echo -e "  PATH: ${RED}not configured${NC} (run: source ~/.zshrc)"
  fi

  # Check session
  if "$BIN_DIR/surf-session" check >/dev/null 2>&1; then
    echo -e "  Session: ${GREEN}valid${NC}"
  else
    echo -e "  Session: ${YELLOW}not connected${NC} (run: surf-session login)"
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

case "${1:---install}" in
  --list|-l)       cmd_list ;;
  --remove|--uninstall) cmd_remove ;;
  --check|--status) cmd_check ;;
  --help|-h)
    echo "Usage: ./install.sh [--install|--list|--remove|--check]"
    echo ""
    echo "  --install   Install skills + CLI commands + PATH (default)"
    echo "  --list      List available skills"
    echo "  --remove    Uninstall everything"
    echo "  --check     Verify installation status"
    ;;
  --install|*)     cmd_install ;;
esac
