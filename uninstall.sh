#!/usr/bin/env bash
# ============================================================================
# helm — Uninstaller
# Removes helm from a Z.ai project
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/uninstall.sh | bash
#
# Options:
#   TARGET=path   Uninstall from specific directory (default: auto-detect)
#   FORCE=1       Skip confirmation prompt
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

info()  { printf "${BLUE}helm${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}⚠${NC} %s\n" "$*"; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }

# ── Auto-detect ─────────────────────────────────────────────────────────────
detect_target() {
  if [ -n "${TARGET:-}" ]; then
    echo "$TARGET"
    return
  fi

  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/skills/helm" ] && [ -f "$dir/skills/helm/SKILL.md" ]; then
      echo "$dir/skills/helm"
      return
    fi
    dir="$(dirname "$dir")"
  done

  error "helm not found in any parent directory"
  exit 1
}

# ── Confirm ─────────────────────────────────────────────────────────────────
confirm() {
  if [ "${FORCE:-0}" = "1" ]; then
    return 0
  fi

  printf "${YELLOW}⚠${NC} This will remove helm from ${BOLD}${1}${NC}\n"
  printf "  Continue? [y/N] "
  read -r answer
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) echo "Aborted."; exit 0 ;;
  esac
}

# ── Main ────────────────────────────────────────────────────────────────────
main() {
  printf "\n"
  printf "${BOLD}${CYAN}⎈ helm uninstaller${NC}\n"
  printf "\n"

  local target
  target="$(detect_target)"

  confirm "$target"

  rm -rf "$target"
  printf "\n"
  printf "${GREEN}✓${NC} helm removed from ${DIM}${target}${NC}\n"
  printf "\n"
  printf "${DIM}To reinstall: curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/install.sh | bash${NC}\n"
  printf "\n"
}

main "$@"
