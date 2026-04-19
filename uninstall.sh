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
#   CLEAN_ALL=1   Also remove bundled skills installed by helm
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
dim()   { printf "${DIM}%s${NC}" "$1"; }

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

# ── Detect bundled skills ──────────────────────────────────────────────────
detect_bundled_skills() {
  local helm_target="$1"
  local skills_dir
  skills_dir="$(dirname "$(realpath "$helm_target")")"
  local bundled_manifest="${helm_target}/bundled-skills"
  local found=()

  # Check if the installed helm has a bundled-skills directory listing
  # We detect bundled skills by checking if they exist in skills/ and have
  # a matching entry in the helm repo's bundled-skills/ directory
  if [ -d "$bundled_manifest" ]; then
    for skill_dir in "$bundled_manifest"/*/; do
      [ -d "$skill_dir" ] || continue
      local name
      name="$(basename "$skill_dir")"
      local dest="${skills_dir}/${name}"
      if [ -d "$dest" ] && [ -f "$dest/SKILL.md" ]; then
        found+=("$dest")
      fi
    done
  fi

  # Also check by known bundled skill names from the installed helm version
  for name in dispatching-parallel-agents; do
    local dest="${skills_dir}/${name}"
    if [ -d "$dest" ] && [ -f "$dest/SKILL.md" ]; then
      # Check if it's a bundled skill (has helm origin in metadata)
      if grep -q "origin: adapted-from" "$dest/SKILL.md" 2>/dev/null; then
        # Avoid duplicates
        local dup=0
        for existing in "${found[@]}"; do
          if [ "$existing" = "$dest" ]; then dup=1; break; fi
        done
        [ "$dup" = "0" ] && found+=("$dest")
      fi
    fi
  done

  echo "${found[@]}"
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

confirm_clean_all() {
  if [ "${FORCE:-0}" = "1" ]; then
    return 0
  fi

  printf "\n"
  printf "${YELLOW}⚠${NC} CLEAN_ALL=1: This will also remove bundled skills:\n"
  for skill in "$@"; do
    printf "  ${RED}✗${NC} %s\n" "$skill"
  done
  printf "\n"
  printf "  Remove these as well? [y/N] "
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

  # Handle bundled skills cleanup
  if [ "${CLEAN_ALL:-0}" = "1" ]; then
    # We need to detect bundled skills BEFORE removing helm.
    # Since helm is already removed, use a fallback detection method.
    local skills_dir
    skills_dir="$(dirname "$(dirname "$(realpath "${TARGET:-$PWD}")")")/skills"

    if [ -d "$skills_dir" ]; then
      local found=()
      # Detect known bundled skills by their metadata signature
      for skill_dir in "$skills_dir"/*/; do
        [ -d "$skill_dir" ] || continue
        [ -f "$skill_dir/SKILL.md" ] || continue
        if grep -q "origin: adapted-from" "$skill_dir/SKILL.md" 2>/dev/null; then
          found+=("$skill_dir")
        fi
      done

      if [ ${#found[@]} -gt 0 ]; then
        if [ "${FORCE:-0}" != "1" ]; then
          confirm_clean_all "${found[@]}"
        fi

        for skill in "${found[@]}"; do
          rm -rf "$skill"
          printf "${GREEN}✓${NC} Removed bundled skill: ${DIM}${skill}${NC}\n"
        done
      else
        info "No bundled skills found to remove"
      fi
    fi
  fi

  printf "\n"
  printf "${DIM}To reinstall: curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/install.sh | bash${NC}\n"
  printf "\n"
}

main "$@"
