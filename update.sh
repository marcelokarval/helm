#!/usr/bin/env bash
# ============================================================================
# helm — Updater
# Updates helm to the latest version
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/update.sh | bash
#
# Options:
#   TARGET=path   Update specific installation
# ============================================================================

BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

info()    { printf "${BLUE}helm${NC} %s\n" "$*"; }
success() { printf "${GREEN}✓${NC} %s\n" "$*"; }

HELM_REPO="marcelokarval/helm"
HELM_BRANCH="main"

# ── Detect ──────────────────────────────────────────────────────────────────
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

  echo ""
}

# ── Main ────────────────────────────────────────────────────────────────────
main() {
  printf "\n"
  printf "${BOLD}${CYAN}⎈ helm updater${NC}\n"
  printf "\n"

  local target
  target="$(detect_target)"

  if [ -z "$target" ]; then
    info "helm not found — installing fresh..."
    printf "\n"
    curl -fsSL "https://raw.githubusercontent.com/${HELM_REPO}/${HELM_BRANCH}/install.sh" | FORCE=1 bash
    return
  fi

  # Get current version
  local current_version=""
  current_version=$(grep -oP 'version:\s*\K[0-9.]+' "$target/SKILL.md" 2>/dev/null || echo "unknown")

  info "Current version: ${BOLD}${current_version}${NC}"
  info "Updating from $(dim "github.com/${HELM_REPO}")..."
  printf "\n"

  # Reinstall with FORCE
  TARGET="$target" FORCE=1 bash <(curl -fsSL "https://raw.githubusercontent.com/${HELM_REPO}/${HELM_BRANCH}/install.sh")

  printf "\n"
  info "$(bold helm) updated successfully."
  printf "\n"
}

main "$@"
