#!/usr/bin/env bash
# ============================================================================
# helm — Engineering Orchestration for Z.ai
# Installer: one-liner setup for any Z.ai project
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/install.sh | bash
#
# Options:
#   TARGET=path       Install to specific directory (default: auto-detect)
#   FORCE=1           Overwrite existing installation
#   DRY_RUN=1         Show what would be done without executing
#   QUIET=1           Suppress non-essential output
#   SKIP_BUNDLED=1    Skip bundled skills installation
#
# Examples:
#   curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/install.sh | bash
#   TARGET=skills/helm FORCE=1 bash <(curl -fsSL https://raw.githubusercontent.com/marcelokarval/helm/main/install.sh)
#   DRY_RUN=1 bash install.sh                          # preview mode
# ============================================================================
set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ── Config ──────────────────────────────────────────────────────────────────
HELM_REPO="marcelokarval/helm"
HELM_BRANCH="main"
HELM_VERSION="1.0.0"
HELM_URL="https://github.com/${HELM_REPO}"
HELM_RAW="https://raw.githubusercontent.com/${HELM_REPO}/${HELM_BRANCH}"

# ── Helpers ─────────────────────────────────────────────────────────────────
info()    { [ "${QUIET:-0}" = "1" ] || printf "${BLUE}helm${NC} %s\n" "$*"; }
success() { [ "${QUIET:-0}" = "1" ] || printf "${GREEN}✓${NC} %s\n" "$*"; }
warn()    { [ "${QUIET:-0}" = "1" ] || printf "${YELLOW}⚠${NC} %s\n" "$*"; }
error()   { printf "${RED}✗${NC} %s\n" "$*" >&2; }
bold()    { printf "${BOLD}%s${NC}" "$1"; }
dim()     { printf "${DIM}%s${NC}" "$1"; }

die() {
  error "$@"
  printf "\n${DIM}Need help? → ${HELM_URL}${NC}\n"
  exit 1
}

run() {
  if [ "${DRY_RUN:-0}" = "1" ]; then
    dim "  $ $*"
  else
    "$@"
  fi
}

# ── Prerequisites ───────────────────────────────────────────────────────────
check_prerequisites() {
  local missing=()

  command -v git >/dev/null 2>&1 || missing+=("git")
  command -v curl >/dev/null 2>&1 || missing+=("curl")

  if [ ${#missing[@]} -gt 0 ]; then
    die "Missing required tools: ${missing[*]}\nInstall with: sudo apt-get install ${missing[*]}"
  fi
}

# ── Auto-detect target directory ────────────────────────────────────────────
detect_target() {
  # Explicit target from env
  if [ -n "${TARGET:-}" ]; then
    echo "$TARGET"
    return
  fi

  # Walk up to find the project root (has worklog.md or is git root or has skills/)
  local dir="$PWD"

  while [ "$dir" != "/" ]; do
    # If skills/ directory exists, install there
    if [ -d "$dir/skills" ]; then
      echo "$dir/skills/helm"
      return
    fi

    # If worklog.md exists, we're in a Z.ai project root
    if [ -f "$dir/worklog.md" ]; then
      echo "$dir/skills/helm"
      return
    fi

    # If .git exists, we're in a git project
    if [ -d "$dir/.git" ]; then
      echo "$dir/skills/helm"
      return
    fi

    dir="$(dirname "$dir")"
  done

  # Fallback: current directory
  echo "$PWD/skills/helm"
}

# ── Version check ───────────────────────────────────────────────────────────
check_existing() {
  local target="$1"

  if [ -d "$target" ]; then
    if [ -f "$target/SKILL.md" ]; then
      # Extract version from SKILL.md if available
      local installed_version=""
      installed_version=$(grep -oP 'version:\s*\K[0-9.]+' "$target/SKILL.md" 2>/dev/null || echo "unknown")

      if [ "${FORCE:-0}" = "1" ]; then
        warn "Existing helm v${installed_version} found — overwriting (FORCE=1)"
        return 0
      else
        error "helm is already installed at ${target} (v${installed_version})"
        printf "\n${DIM}To overwrite: FORCE=1 bash install.sh${NC}\n"
        printf "${DIM}To uninstall:  curl -fsSL ${HELM_RAW}/uninstall.sh | bash${NC}\n"
        exit 1
      fi
    fi
  fi

  return 0
}

# ── Download and install ────────────────────────────────────────────────────
CLONED_DIR=""

install_helm() {
  local target="$1"

  info "Installing $(bold helm) v${HELM_VERSION}..."
  printf "\n"

  # Create parent directory
  local parent
  parent="$(dirname "$target")"
  if [ ! -d "$parent" ]; then
    run mkdir -p "$parent"
    success "Created $(dim "$parent")"
  fi

  # Clone using git (sparse checkout for speed)
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  info "Downloading from $(dim "${HELM_URL}")..."
  run git clone --depth 1 --branch "${HELM_BRANCH}" \
    "https://github.com/${HELM_REPO}.git" "$tmp_dir/helm" 2>/dev/null

  if [ ! -d "$tmp_dir/helm" ]; then
    rm -rf "$tmp_dir"
    die "Failed to download helm from GitHub"
  fi

  # Copy files (excluding .git)
  if [ -d "$target" ]; then
    run rm -rf "$target"
  fi
  run cp -r "$tmp_dir/helm" "$target"

  # Save cloned dir for bundled skills (cleaned up later)
  CLONED_DIR="$tmp_dir"

  success "Downloaded to $(dim "$target")"
}

# ── Install bundled skills ──────────────────────────────────────────────────
install_bundled_skills() {
  local target="$1"
  local skills_dir
  skills_dir="$(dirname "$target")"
  local bundled_source="${CLONED_DIR}/helm/bundled-skills"

  if [ "${SKIP_BUNDLED:-0}" = "1" ]; then
    info "Skipping bundled skills (SKIP_BUNDLED=1)"
    return
  fi

  if [ ! -d "$bundled_source" ]; then
    info "No bundled-skills directory found — skipping"
    return
  fi

  local installed=0
  local skipped=0
  local names=()

  for skill_dir in "$bundled_source"/*/; do
    [ -d "$skill_dir" ] || continue
    local name
    name="$(basename "$skill_dir")"
    local dest="${skills_dir}/${name}"

    # Skip if already exists with a SKILL.md (don't overwrite user's custom skills)
    # Unless FORCE=1 (update mode) — then overwrite bundled skills
    if [ -d "$dest" ] && [ -f "$dest/SKILL.md" ] && [ "${FORCE:-0}" != "1" ]; then
      names+=("${name} (existing, skipped)")
      skipped=$((skipped + 1))
      continue
    fi

    # Check if it's a bundled skill before overwriting (only overwrite bundled, not user-created)
    if [ -d "$dest" ] && [ -f "$dest/SKILL.md" ] && [ "${FORCE:-0}" = "1" ]; then
      if grep -q 'origin: adapted-from' "$dest/SKILL.md" 2>/dev/null; then
        # This is a bundled skill — safe to overwrite
        run rm -rf "$dest"
        run cp -r "$skill_dir" "$dest"
        names+=("${name} (updated)")
        installed=$((installed + 1))
        success "Updated bundled skill: $(dim "${name}")"
        continue
      else
        # User-created skill — don't overwrite
        names+=("${name} (user custom, skipped)")
        skipped=$((skipped + 1))
        continue
      fi
    fi

    # Copy the bundled skill
    if [ -d "$dest" ]; then
      run rm -rf "$dest"
    fi
    run cp -r "$skill_dir" "$dest"
    names+=("${name}")
    installed=$((installed + 1))
    success "Installed bundled skill: $(dim "${name}")"
  done

  if [ ${#names[@]} -gt 0 ]; then
    printf "\n"
    info "Bundled skills: ${#names[@]} found, ${installed} installed, ${skipped} skipped"
    for name in "${names[@]}"; do
      dim "  • ${name}"
      printf "\n"
    done
  fi

  BUNDLED_INSTALLED=$installed
  BUNDLED_SKIPPED=$skipped
}

# ── Configure enforcement (worklog reference) ──────────────────────────────
configure_worklog() {
  local project_root
  project_root="$(dirname "$(dirname "$(realpath "${TARGET:-$PWD/skills/helm}")")")"
  local worklog="$project_root/worklog.md"

  if [ -f "$worklog" ]; then
    # Check if helm reference already exists
    if grep -q "helm" "$worklog" 2>/dev/null; then
      info "worklog.md already references helm — skipping"
    else
      run bash -c "cat >> '$worklog'" << 'EOF'

---
## Repo Configuration
This project uses **helm** (engineering orchestration for Z.ai).
Before any implementation work, consult `skills/helm/SKILL.md`.
EOF
      success "Added helm reference to $(dim "worklog.md")"
    fi
  else
    info "No worklog.md found — skipping enforcement setup"
  fi
}

# ── Summary ─────────────────────────────────────────────────────────────────
print_summary() {
  local target="$1"
  local project_root
  project_root="$(dirname "$(dirname "$(realpath "$target")")")"
  local file_count
  file_count=$(find "$target" -name "*.md" | wc -l)
  local word_count
  word_count=$(find "$target" -name "*.md" -exec cat {} + 2>/dev/null | wc -w)

  printf "\n"
  printf "${BOLD}${CYAN}  ⎈ helm v${HELM_VERSION} installed${NC}\n"
  if [ "${SKIP_BUNDLED:-0}" != "1" ] && [ "${BUNDLED_INSTALLED:-0}" -gt 0 ]; then
    printf "  ${DIM}+ %s bundled skill(s)${NC}\n" "$BUNDLED_INSTALLED"
  fi
  printf "\n"
  printf "  ${DIM}Location${NC}    %s\n" "$target"
  printf "  ${DIM}Files${NC}       %s markdown modules\n" "$file_count"
  printf "  ${DIM}Content${NC}     %s words\n" "$word_count"
  printf "\n"
  printf "  ${GREEN}●${NC} Classification & branch routing\n"
  printf "  ${GREEN}●${NC} 5 subagent types mapped (full-stack, Plan, Explore, etc.)\n"
  printf "  ${GREEN}●${NC} 25 named workflows + proof stack (5 layers)\n"
  printf "  ${GREEN}●${NC} 3 Z.ai adapters (enforcement, workflow, runtime)\n"
  printf "  ${GREEN}●${NC} 11 executive personas with mandatory skills\n"
  printf "\n"
  printf "  ${DIM}Key files:${NC}\n"
  printf "    skills/helm/SKILL.md                        ${DIM}← constitution${NC}\n"
  printf "    skills/helm/AGENTS.md                       ${DIM}← repo laws${NC}\n"
  printf "    skills/helm/README.md                       ${DIM}← operational guide${NC}\n"
  printf "    skills/helm/core/control-plane/             ${DIM}← branch matrix${NC}\n"
  printf "    skills/helm/core/workflows/                 ${DIM}← 25 workflows${NC}\n"
  printf "    skills/helm/adapters/enforcement/           ${DIM}← Z.ai enforcement${NC}\n"
  printf "\n"
  printf "  ${DIM}Next steps:${NC}\n"
  printf "    1. Read $(bold "skills/helm/SKILL.md") for the constitution\n"
  printf "    2. For crons, read $(bold "adapters/runtime/cron-governance.md") FIRST\n"
  printf "       ${DIM}Crons must NEVER invent tasks or propose features.${NC}\n"
  printf "    3. Check updates: $(bold "curl -fsSL ${HELM_RAW}/install.sh | bash")\n"
  printf "\n"
  printf "  ${DIM}Uninstall: curl -fsSL ${HELM_RAW}/uninstall.sh | bash${NC}\n"
  printf "\n"
}

# ── Main ────────────────────────────────────────────────────────────────────
main() {
  printf "\n"
  printf "${BOLD}${CYAN}⎈ helm installer${NC} ${DIM}v${HELM_VERSION}${NC}\n"
  printf "\n"

  check_prerequisites

  local target
  target="$(detect_target)"

  if [ "${DRY_RUN:-0}" = "1" ]; then
    info "Preview mode (DRY_RUN=1)"
    printf "\n"
    printf "  Target: ${BOLD}${target}${NC}\n"
    printf "\n"
    info "Would clone ${HELM_URL} (branch: ${HELM_BRANCH})"
    info "Would install to ${target}"
    if [ "${SKIP_BUNDLED:-0}" != "1" ]; then
      info "Would also install bundled skills to ${BOLD}$(dirname "$target")/${NC}"
    else
      info "Would skip bundled skills (SKIP_BUNDLED=1)"
    fi
    info "Would configure worklog.md enforcement"
    printf "\n"
    printf "${DIM}Remove DRY_RUN=1 to execute.${NC}\n"
    printf "\n"
    exit 0
  fi

  check_existing "$target"
  install_helm "$target"
  install_bundled_skills "$target"

  # Cleanup cloned dir after bundled skills are installed
  if [ -n "$CLONED_DIR" ] && [ -d "$CLONED_DIR" ]; then
    rm -rf "$CLONED_DIR"
  fi

  configure_worklog
  print_summary "$target"
}

main "$@"
