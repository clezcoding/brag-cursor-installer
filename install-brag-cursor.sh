#!/usr/bin/env bash
#
#   ██████╗ ██████╗  █████╗  ██████╗
#   ██╔══██╗██╔══██╗██╔══██╗██╔════╝
#   ██████╔╝██████╔╝███████║██║  ███╗
#   ██╔══██╗██╔══██╗██╔══██║██║   ██║
#   ██████╔╝██║  ██║██║  ██║╚██████╔╝
#   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#
#  install-brag-cursor.sh — Install or uninstall /brag for Cursor on macOS.
#  Turn any project into a 15–25-second launch video, right from your editor.
#
#  Skill source:  https://github.com/latent-spaces/brag
#  This script:   https://github.com/clezcoding/brag-cursor-installer
#
# USAGE
#   chmod +x install-brag-cursor.sh
#   ./install-brag-cursor.sh                          interactive
#   ./install-brag-cursor.sh install --project        this folder only
#   ./install-brag-cursor.sh install --project /path  a specific project
#   ./install-brag-cursor.sh install --global         every Cursor project
#   ./install-brag-cursor.sh install --both /path     both at once
#   ./install-brag-cursor.sh uninstall                remove (interactive)
#   ./install-brag-cursor.sh uninstall --both --purge remove everything
#   ./install-brag-cursor.sh -y                       no prompts (install)
#
# OPTIONS
#   install | uninstall   Mode (prompted if omitted)
#   --project [DIR]       Target DIR/.cursor/skills  (default DIR: cwd)
#   --global              Target ~/.cursor/skills
#   --both [DIR]          Both --project and --global
#   --purge               (uninstall) also remove Hyperframes companion skills
#   --heygen-key KEY      Store a HeyGen API key non-interactively
#   -y, --yes             Skip all prompts, use sensible defaults
#   -h, --help            Show this help and exit
#
# WHAT GETS INSTALLED
#   Toolchain  Xcode CLT, Homebrew, Node.js 22+, FFmpeg  (auto-installed if absent)
#   Skills     latent-spaces/brag  +  Hyperframes companion packages
#   Config     .cursor/rules/brag.mdc  (fallback for Cursor < 2.4)
#   Optional   uv (high-fidelity beat-sync), HeyGen API key
#
# Safe to re-run — fully idempotent. Uninstalling only removes what this
# script placed; Node.js, FFmpeg, Homebrew, and uv are never touched.

set -euo pipefail

# ============================================================================
#  THEME — colors, typography, and terminal helpers
# ============================================================================

TTY_OK=false; [[ -t 1 ]] && TTY_OK=true
COLOR_OK=true; [[ -n "${NO_COLOR:-}" ]] && COLOR_OK=false; $TTY_OK || COLOR_OK=false

TERM_COLORS=8
if $TTY_OK && command -v tput >/dev/null 2>&1; then
  TERM_COLORS="$(tput colors 2>/dev/null || echo 8)"
fi

if $COLOR_OK && [[ "$TERM_COLORS" -ge 256 ]]; then
  RESET=$'\033[0m'  BOLD=$'\033[1m'     DIM=$'\033[2m'
  RED=$'\033[38;5;203m'   GREEN=$'\033[38;5;114m'  YELLOW=$'\033[38;5;221m'
  BLUE=$'\033[38;5;75m'   CYAN=$'\033[38;5;80m'    MAGENTA=$'\033[38;5;170m'
  PINK=$'\033[38;5;212m'  GRAY=$'\033[38;5;244m'   ORANGE=$'\033[38;5;215m'
  WHITE=$'\033[38;5;255m'
elif $COLOR_OK; then
  RESET=$'\033[0m'  BOLD=$'\033[1m'     DIM=$'\033[2m'
  RED=$'\033[0;31m'  GREEN=$'\033[0;32m'  YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m' CYAN=$'\033[0;36m'   MAGENTA=$'\033[0;35m'
  PINK=$'\033[0;35m' GRAY=$'\033[0;90m'   ORANGE=$'\033[0;33m'
  WHITE=$'\033[0;37m'
else
  RESET="" BOLD="" DIM="" RED="" GREEN="" YELLOW="" BLUE=""
  CYAN="" MAGENTA="" PINK="" GRAY="" ORANGE="" WHITE=""
fi

COLS=80
if $TTY_OK && command -v tput >/dev/null 2>&1; then
  COLS="$(tput cols 2>/dev/null || echo 80)"
fi
RULE_WIDTH=$COLS
[[ "$RULE_WIDTH" -gt 78 ]] && RULE_WIDTH=78
[[ "$RULE_WIDTH" -lt 40 ]] && RULE_WIDTH=40

# Horizontal rule.  rule [char] [color]
rule() {
  local ch="${1:-─}" clr="${2:-$GRAY}" line="" i=0
  while [[ $i -lt $RULE_WIDTH ]]; do line+="$ch"; i=$((i + 1)); done
  printf "%b%s%b\n" "$clr" "$line" "${RESET}"
}

# ── banner ────────────────────────────────────────────────────────────────────
banner() {
  local mode_label="${1:-}"
  printf "\n"
  rule "─" "${GRAY}"
  printf "\n"

  if [[ "$RULE_WIDTH" -ge 66 ]]; then
    printf "  %b██████╗ ██████╗  █████╗  ██████╗%b" "${PINK}${BOLD}" "${RESET}"
    printf "   %b/brag%b %b·%b %bfor Cursor%b\n" \
      "${CYAN}${BOLD}" "${RESET}" "${GRAY}" "${RESET}" "${WHITE}${BOLD}" "${RESET}"
    printf "  %b██╔══██╗██╔══██╗██╔══██╗██╔════╝%b\n" "${MAGENTA}" "${RESET}"
    printf "  %b██████╔╝██████╔╝███████║██║  ███╗%b" "${PINK}" "${RESET}"
    printf "   %bTurn your project into%b\n" "${DIM}" "${RESET}"
    printf "  %b██╔══██╗██╔══██╗██╔══██║██║   ██║%b" "${MAGENTA}" "${RESET}"
    printf "   %ba shareable launch video.%b\n" "${DIM}" "${RESET}"
    printf "  %b██████╔╝██║  ██║██║  ██║╚██████╔╝%b\n" "${PINK}" "${RESET}"
    printf "  %b╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝%b" "${MAGENTA}" "${RESET}"
    printf "   %b★%b  %blatent-spaces/brag%b\n" \
      "${ORANGE}" "${RESET}" "${DIM}" "${RESET}"
  else
    printf "  %b/brag%b  %b·%b  %bfor Cursor%b\n" \
      "${CYAN}${BOLD}" "${RESET}" "${GRAY}" "${RESET}" "${WHITE}${BOLD}" "${RESET}"
    printf "  %bTurn your project into a shareable launch video.%b\n" "${DIM}" "${RESET}"
    printf "  %b★  latent-spaces/brag%b\n" "${ORANGE}" "${RESET}"
  fi

  printf "\n"
  rule "─" "${GRAY}"
  if [[ -n "$mode_label" ]]; then
    printf "  %b%s%b\n" "${BOLD}${ORANGE}" "$mode_label" "${RESET}"
    rule "─" "${GRAY}"
  fi
  printf "\n"
}

# ── section header ────────────────────────────────────────────────────────────
section() {
  local title="$1" tail="" i=0
  local needed=$(( RULE_WIDTH - ${#title} - 6 ))
  [[ $needed -lt 0 ]] && needed=0
  while [[ $i -lt $needed ]]; do tail+="─"; i=$((i + 1)); done
  printf "\n  %b┌─ %s %s%b\n" "${CYAN}${BOLD}" "$title" "$tail" "${RESET}"
}

# ── menu box ──────────────────────────────────────────────────────────────────
print_menu() {
  local title="$1"; shift
  local tail="" i=0
  local needed=$(( RULE_WIDTH - ${#title} - 6 ))
  [[ $needed -lt 0 ]] && needed=0
  while [[ $i -lt $needed ]]; do tail+="─"; i=$((i + 1)); done
  printf "\n  %b┌─ %s %s%b\n" "${MAGENTA}${BOLD}" "$title" "$tail" "${RESET}"
  printf "  %b│%b\n" "${MAGENTA}${BOLD}" "${RESET}"
  for item in "$@"; do
    printf "  %b│%b  %s\n" "${MAGENTA}${BOLD}" "${RESET}" "$item"
  done
  printf "  %b│%b\n" "${MAGENTA}${BOLD}" "${RESET}"
}

# ── step counter ──────────────────────────────────────────────────────────────
STEP_TOTAL=1
STEP_CUR=0
step() {
  STEP_CUR=$((STEP_CUR + 1))
  local barlen=14 filled=$(( STEP_CUR * 14 / STEP_TOTAL ))
  [[ $filled -gt $barlen ]] && filled=$barlen
  local bar="" i=0
  while [[ $i -lt $barlen ]]; do
    if [[ $i -lt $filled ]]; then bar+="▰"; else bar+="▱"; fi
    i=$((i + 1))
  done
  printf "\n  %b[%02d/%02d]%b %b%s%b  %b%s%b\n" \
    "${BOLD}${CYAN}" "$STEP_CUR" "$STEP_TOTAL" "${RESET}" \
    "${MAGENTA}${DIM}" "$bar" "${RESET}" \
    "${BOLD}" "$1" "${RESET}"
}

# ── output helpers ────────────────────────────────────────────────────────────
info() { printf "   %b→%b  %s\n" "${BLUE}" "${RESET}" "$1"; }
ok()   { printf "   %b✔%b  %s\n" "${GREEN}" "${RESET}" "$1"; }
warn() { printf "   %b⚠%b  %s\n" "${YELLOW}" "${RESET}" "$1"; }
err()  { printf "   %b✘%b  %s\n" "${RED}" "${RESET}" "$1" >&2; }
skip() { printf "   %b·%b  %s\n" "${GRAY}" "${RESET}" "$1"; }

# ── spinner ───────────────────────────────────────────────────────────────────
run_with_spinner() {
  local label="$1"; shift
  local logfile; logfile="$(mktemp)"
  "$@" >"$logfile" 2>&1 &
  local pid=$!
  if $TTY_OK; then
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') i=0
    while kill -0 "$pid" 2>/dev/null; do
      printf "\r   %b%s%b  %s" "${CYAN}" "${frames[$((i % 10))]}" "${RESET}" "$label"
      i=$((i + 1)); sleep 0.1
    done
  fi
  local status=0; wait "$pid" || status=$?
  if [[ $status -eq 0 ]]; then
    printf "\r   %b✔%b  %-60s\n" "${GREEN}" "${RESET}" "$label"
  else
    printf "\r   %b✘%b  %-60s\n" "${RED}" "${RESET}" "$label"
    printf "   %b┊ last 20 lines of output:%b\n" "${DIM}" "${RESET}"
    tail -n 20 "$logfile" | sed 's/^/   ┊ /'
  fi
  rm -f "$logfile"
  return $status
}

# ── confirm ───────────────────────────────────────────────────────────────────
confirm() {
  local question="$1" default="${2:-n}" answer
  local hint="y/N"; [[ "$default" == "y" ]] && hint="Y/n"
  if $NONINTERACTIVE || ! $TTY_OK; then
    [[ "$default" == "y" ]] && return 0 || return 1
  fi
  read -r -p "   ${question} [${hint}]: " answer
  answer="${answer:-$default}"
  [[ "$answer" =~ ^[jJyY] ]]
}

# ============================================================================
#  ARGUMENTS
# ============================================================================

MODE=""
INSTALL_PROJECT=false
INSTALL_GLOBAL=false
PROJECT_DIR=""
NONINTERACTIVE=false
PURGE=false
HEYGEN_KEY_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    install|uninstall) MODE="$1" ;;
    --project)
      INSTALL_PROJECT=true
      if [[ -n "${2:-}" && "$2" != --* ]]; then PROJECT_DIR="$2"; shift; fi ;;
    --global) INSTALL_GLOBAL=true ;;
    --both)
      INSTALL_PROJECT=true; INSTALL_GLOBAL=true
      if [[ -n "${2:-}" && "$2" != --* ]]; then PROJECT_DIR="$2"; shift; fi ;;
    --purge) PURGE=true ;;
    --heygen-key) HEYGEN_KEY_ARG="${2:-}"; shift ;;
    -y|--yes) NONINTERACTIVE=true ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//' | sed -n '2,50p'; exit 0 ;;
    *)
      if [[ -d "$1" ]]; then
        INSTALL_PROJECT=true; PROJECT_DIR="$1"
      else
        warn "Ignoring unknown argument: $1"
      fi ;;
  esac
  shift
done

# macOS only
if [[ "$(uname)" != "Darwin" ]]; then
  printf "✘  This script is macOS-only.\n" >&2; exit 1
fi

# ── mode selection ────────────────────────────────────────────────────────────
if [[ -z "$MODE" ]]; then
  if $NONINTERACTIVE || ! $TTY_OK; then
    MODE="install"
  else
    banner ""
    print_menu "WHAT WOULD YOU LIKE TO DO?" \
      "1)  ${BOLD}install${RESET}    — set up /brag and everything it needs" \
      "2)  ${BOLD}uninstall${RESET}  — cleanly remove /brag from a project or globally"
    choice=""
    while [[ -z "$choice" ]]; do
      read -r -p "   Choice [1-2]: " choice
      case "$choice" in
        1) MODE="install" ;;
        2) MODE="uninstall" ;;
        *) warn "Please type 1 or 2."; choice="" ;;
      esac
    done
  fi
fi

# ── target selection (shared between install & uninstall) ─────────────────────
choose_targets() {
  if ! $INSTALL_PROJECT && ! $INSTALL_GLOBAL; then
    if $NONINTERACTIVE || ! $TTY_OK; then
      INSTALL_PROJECT=true
    else
      print_menu "WHERE SHOULD /brag LIVE?" \
        "1)  ${BOLD}this project only${RESET}  — .cursor/skills/ in your project folder" \
        "2)  ${BOLD}global${RESET}              — ~/.cursor/skills/ for all Cursor projects" \
        "3)  ${BOLD}both${RESET}                — recommended: local copy + global fallback"
      choice=""
      while [[ -z "$choice" ]]; do
        read -r -p "   Choice [1-3]: " choice
        case "$choice" in
          1) INSTALL_PROJECT=true ;;
          2) INSTALL_GLOBAL=true ;;
          3) INSTALL_PROJECT=true; INSTALL_GLOBAL=true ;;
          *) warn "Please type 1, 2, or 3."; choice="" ;;
        esac
      done
    fi
  fi

  if $INSTALL_PROJECT && [[ -z "$PROJECT_DIR" ]]; then
    if $NONINTERACTIVE || ! $TTY_OK; then
      PROJECT_DIR="$(pwd)"
    else
      read -r -e -p "   Project path [$(pwd)]: " PROJECT_DIR
      PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
    fi
  fi

  if $INSTALL_PROJECT; then
    if [[ ! -d "$PROJECT_DIR" ]]; then
      err "Directory not found: $PROJECT_DIR"; exit 1
    fi
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
  fi

  printf "\n"
  printf "   %bTarget(s):%b\n" "${BOLD}" "${RESET}"
  $INSTALL_PROJECT && printf "   %b→%b  %s/.cursor/skills  %b(project-local)%b\n" \
    "${CYAN}" "${RESET}" "$PROJECT_DIR" "${DIM}" "${RESET}"
  $INSTALL_GLOBAL  && printf "   %b→%b  %s/.cursor/skills  %b(global)%b\n" \
    "${CYAN}" "${RESET}" "$HOME" "${DIM}" "${RESET}"
}

# ── relevant Hyperframes skill dirs ──────────────────────────────────────────
hf_relevant_skill_dirs() {
  local store="$1"
  [[ -d "$store" ]] || return 0
  for d in "$store"/*/; do
    [[ -e "$d" ]] || continue
    local name; name="$(basename "$d")"
    if [[ "$name" == "hyperframes" || "$name" == hyperframes-* || \
          "$name" == "general-video" ]]; then
      printf "%s\n" "$name"
    fi
  done
}

# ============================================================================
#  INSTALL
# ============================================================================
do_install() {
  SUMMARY_PROJECT_PATH=""
  SUMMARY_GLOBAL=false
  SUMMARY_HF_COUNT=0
  SUMMARY_UV="skipped"
  SUMMARY_HEYGEN="skipped"

  banner "INSTALLING"
  info "macOS $(sw_vers -productVersion 2>/dev/null || echo "(version unknown)")"
  choose_targets

  STEP_TOTAL=15

  section "TOOLCHAIN"

  step "Xcode Command Line Tools"
  if ! xcode-select -p >/dev/null 2>&1; then
    info "Launching the Xcode Tools installer — approve the dialog that pops up."
    xcode-select --install || true
    printf "\n"
    warn "Once the install finishes, re-run this script to continue."
    exit 1
  else
    ok "already on your system"
  fi

  step "Homebrew"
  if ! command -v brew >/dev/null 2>&1; then
    run_with_spinner "Fetching and installing Homebrew" \
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi
  else
    ok "found — $(brew --version | head -1)"
  fi

  step "Node.js 22+"
  NEED_NODE=true
  if command -v node >/dev/null 2>&1; then
    NODE_MAJOR="$(node -v | sed 's/^v//' | cut -d. -f1)"
    if [[ "$NODE_MAJOR" -ge 22 ]]; then
      NEED_NODE=false; ok "Node.js $(node -v) — good to go"
    else
      warn "Node.js $(node -v) found, but /brag requires v22+"
    fi
  fi
  if $NEED_NODE; then
    run_with_spinner "Installing Node.js 22 via Homebrew" brew install node@22
    brew link --overwrite --force node@22 >/dev/null 2>&1 || true
    hash -r
    ok "Node.js $(node -v 2>/dev/null || echo 'installed')"
  fi

  step "FFmpeg"
  if ! command -v ffmpeg >/dev/null 2>&1; then
    run_with_spinner "Installing FFmpeg via Homebrew" brew install ffmpeg
  else
    ok "found — $(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f1-3)"
  fi

  step "git"
  if ! command -v git >/dev/null 2>&1; then
    err "git not found — should ship with the Xcode Command Line Tools"; exit 1
  else
    ok "found — $(git --version)"
  fi

  step "Cursor.app"
  if [[ -d "/Applications/Cursor.app" ]]; then
    ok "found in /Applications"
  else
    warn "not found in /Applications (fine if installed elsewhere)"
  fi

  section "THE SKILL"

  step "Cloning latent-spaces/brag"
  WORK_DIR="$(mktemp -d)"
  trap 'rm -rf "$WORK_DIR"' EXIT
  run_with_spinner "Cloning the /brag repo (shallow)" \
    git clone --depth 1 --quiet https://github.com/latent-spaces/brag.git "$WORK_DIR/brag"
  ok "cloned to scratch directory"

  step "Hyperframes companion skills (global — that's how the upstream CLI ships them)"
  if run_with_spinner "Running: npx hyperframes@latest skills update" \
      npx --yes hyperframes@latest skills update; then
    :
  else
    warn "Hyperframes CLI install failed — you can retry manually:"
    warn "  npx hyperframes skills update"
    warn "  (if hitting GitHub rate limits: gh auth login  or  export GITHUB_TOKEN=...)"
  fi

  HF_UNIVERSAL="$HOME/.agents/skills"
  HF_CLAUDE="$HOME/.claude/skills"
  HF_STORE=""
  [[ -d "$HF_UNIVERSAL" ]] && HF_STORE="$HF_UNIVERSAL"
  [[ -z "$HF_STORE" ]] && [[ -d "$HF_CLAUDE" ]] && HF_STORE="$HF_CLAUDE"

  if [[ -n "$HF_STORE" ]]; then
    ok "found Hyperframes skill store at $HF_STORE"
  else
    warn "Hyperframes skill store not found — /brag's video-composition handoff may be incomplete"
  fi

  step "Mirroring Hyperframes skills into ~/.cursor/skills"
  if [[ -n "$HF_STORE" ]]; then
    mkdir -p "$HOME/.cursor/skills"
    HF_COUNT=0
    while IFS= read -r name; do
      [[ -z "$name" ]] && continue
      rm -rf "$HOME/.cursor/skills/$name"
      cp -R "$HF_STORE/$name" "$HOME/.cursor/skills/$name"
      HF_COUNT=$((HF_COUNT + 1))
    done < <(hf_relevant_skill_dirs "$HF_STORE")
    SUMMARY_HF_COUNT=$HF_COUNT
    ok "$HF_COUNT package(s) mirrored — Cursor can now find Hyperframes globally"
  else
    skip "nothing to mirror"
  fi

  step "Installing /brag into the target(s)"
  deploy_brag() {
    local dest="$1"
    mkdir -p "$dest"
    rm -rf "$dest/brag"
    cp -R "$WORK_DIR/brag/skills/brag" "$dest/brag"
  }

  if $INSTALL_PROJECT; then
    deploy_brag "$PROJECT_DIR/.cursor/skills"
    ok "/brag → $PROJECT_DIR/.cursor/skills/brag"
    SUMMARY_PROJECT_PATH="$PROJECT_DIR"
    if [[ -n "$HF_STORE" ]]; then
      HF_COUNT=0
      while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        rm -rf "$PROJECT_DIR/.cursor/skills/$name"
        cp -R "$HF_STORE/$name" "$PROJECT_DIR/.cursor/skills/$name"
        HF_COUNT=$((HF_COUNT + 1))
      done < <(hf_relevant_skill_dirs "$HF_STORE")
      ok "+ $HF_COUNT Hyperframes package(s) copied in — project is fully self-contained"
    fi
  fi
  if $INSTALL_GLOBAL; then
    deploy_brag "$HOME/.cursor/skills"
    ok "/brag → $HOME/.cursor/skills/brag"
    SUMMARY_GLOBAL=true
  fi

  step "Fallback rule for Cursor versions without native Skills support (< 2.4)"
  if $INSTALL_PROJECT; then
    RULES_DIR="$PROJECT_DIR/.cursor/rules"
    mkdir -p "$RULES_DIR"
    cat > "$RULES_DIR/brag.mdc" <<'EOF'
---
description: Turn the current project into a short, shareable launch video with /brag
alwaysApply: false
---

When the user writes "/brag", "let's brag about this", "make a launch video",
or anything to that effect:

1. Read `.cursor/skills/brag/SKILL.md` in full and follow its steps and
   reference files (`.cursor/skills/brag/references/*.md`) exactly.
2. For the video composition step, also read the Hyperframes skills under
   `.cursor/skills/` — start with the `hyperframes` skill.
3. Prerequisites: Node.js 22+, FFmpeg on PATH, `npx hyperframes doctor` clean.

This rule is a compatibility fallback for Cursor versions without native Skills
support (< 2.4). If your Cursor auto-discovers `.cursor/skills/brag/`, this
rule fires alongside it — harmlessly.
EOF
    ok "written to $RULES_DIR/brag.mdc"
  else
    skip "no project target selected — rules are always project-scoped"
  fi

  section "RENDER PIPELINE"

  step "Headless Chrome (required for frame capture)"
  CHECK_DIR="${PROJECT_DIR:-$HOME}"
  (cd "$CHECK_DIR" && run_with_spinner "Fetching headless Chrome via Hyperframes" \
    npx --yes hyperframes browser ensure) \
    || warn "Chrome fetch failed — will be retried automatically on first render"

  step "Environment check (hyperframes doctor)"
  (cd "$CHECK_DIR" && npx --yes hyperframes doctor) \
    || warn "hyperframes doctor flagged something above ↑ — fix it before running /brag"

  section "OPTIONAL EXTRAS"

  step "uv — high-fidelity beat detection for your own music tracks"
  if command -v uv >/dev/null 2>&1; then
    ok "already on your system — $(uv --version)"
    SUMMARY_UV="already present"
  else
    info "Without uv, /brag uses 'npx hyperframes beats' for beat-sync — works great."
    if confirm "Install uv for higher-accuracy beat detection on custom tracks?" n; then
      run_with_spinner "Installing uv via Homebrew" brew install uv
      SUMMARY_UV="installed"
    else
      skip "skipped — the built-in beat engine has you covered"
    fi
  fi

  step "HeyGen API key — needed for AI presenter overlays (optional)"
  HEYGEN_KEY="$HEYGEN_KEY_ARG"
  if [[ -z "$HEYGEN_KEY" ]] && ! $NONINTERACTIVE && $TTY_OK; then
    info "Get a key at https://app.heygen.com/settings?tab=API (free tier available)"
    read -r -p "   Paste your HeyGen API key — or hit Enter to skip: " HEYGEN_KEY
  fi
  if [[ -n "$HEYGEN_KEY" ]]; then
    if echo "$HEYGEN_KEY" | npx --yes hyperframes auth login --api-key; then
      ok "saved to ~/.heygen/credentials"
      SUMMARY_HEYGEN="configured"
    else
      warn "something went wrong — try: npx hyperframes auth login"
    fi
  else
    skip "skipped — local rendering works great without a HeyGen account"
  fi

  printf "\n"
  rule "═" "${GREEN}"
  printf "  %b✨  Done. You built something worth bragging about.%b\n" "${GREEN}${BOLD}" "${RESET}"
  rule "─" "${GRAY}"
  printf "\n"

  printf "  %bInstalled:%b\n" "${BOLD}" "${RESET}"
  if [[ -n "$SUMMARY_PROJECT_PATH" ]]; then
    printf "   %b✔%b  %s/.cursor/skills/brag\n" "${GREEN}" "${RESET}" "$SUMMARY_PROJECT_PATH"
    printf "   %b✔%b  %s/.cursor/rules/brag.mdc  %b(Cursor < 2.4 fallback)%b\n" \
      "${GREEN}" "${RESET}" "$SUMMARY_PROJECT_PATH" "${DIM}" "${RESET}"
  fi
  if $SUMMARY_GLOBAL; then
    printf "   %b✔%b  %s/.cursor/skills/brag  %b(global)%b\n" \
      "${GREEN}" "${RESET}" "$HOME" "${DIM}" "${RESET}"
  fi
  [[ $SUMMARY_HF_COUNT -gt 0 ]] && \
    printf "   %b✔%b  %d Hyperframes companion package(s)\n" \
      "${GREEN}" "${RESET}" "$SUMMARY_HF_COUNT"
  [[ "$SUMMARY_UV" != "skipped" ]] && \
    printf "   %b✔%b  uv  %b(%s)%b\n" "${GREEN}" "${RESET}" "${DIM}" "$SUMMARY_UV" "${RESET}"
  [[ "$SUMMARY_HEYGEN" != "skipped" ]] && \
    printf "   %b✔%b  HeyGen API key configured\n" "${GREEN}" "${RESET}"

  printf "\n"
  rule "─" "${GRAY}"
  printf "\n"

  printf "  %bNext steps:%b\n" "${BOLD}" "${RESET}"
  if [[ -n "$SUMMARY_PROJECT_PATH" ]]; then
    printf "   %b→%b  Open %b%s%b in Cursor\n" \
      "${CYAN}" "${RESET}" "${BOLD}" "$SUMMARY_PROJECT_PATH" "${RESET}"
    printf "   %b→%b  In the agent panel, type:  %b/brag%b\n" \
      "${CYAN}" "${RESET}" "${BOLD}" "${RESET}"
  elif $SUMMARY_GLOBAL; then
    printf "   %b→%b  Open any project in Cursor → agent panel → %b/brag%b\n" \
      "${CYAN}" "${RESET}" "${BOLD}" "${RESET}"
  fi
  printf "   %b→%b  Try a tone:  %b/brag --tone chaotic%b\n" \
    "${CYAN}" "${RESET}" "${BOLD}" "${RESET}"
  printf "   %b→%b  Other tones: %bpolished  deadpan  cinematic  yc-parody  app-store%b\n" \
    "${CYAN}" "${RESET}" "${DIM}" "${RESET}"

  printf "\n"
  printf "  %bMore installs:%b\n" "${DIM}" "${RESET}"
  printf "   %b\$%b  ./install-brag-cursor.sh install --project /path/to/other-project\n" \
    "${GRAY}" "${RESET}"
  printf "   %b\$%b  ./install-brag-cursor.sh install --global\n" "${GRAY}" "${RESET}"
  printf "  %bUninstall:%b\n" "${DIM}" "${RESET}"
  printf "   %b\$%b  ./install-brag-cursor.sh uninstall\n" "${GRAY}" "${RESET}"
  printf "\n"
  rule "═" "${GREEN}"
  printf "\n"
}

# ============================================================================
#  UNINSTALL
# ============================================================================
do_uninstall() {
  SUMMARY_REMOVED_PROJECT=""
  SUMMARY_REMOVED_GLOBAL=false
  SUMMARY_REMOVED_HF=0
  SUMMARY_REMOVED_RULE=false
  SUMMARY_REMOVED_HEYGEN=false

  banner "UNINSTALLING"
  choose_targets

  if ! $PURGE; then
    printf "\n"
    if confirm "Also remove the Hyperframes companion skills from these location(s)?" n; then
      PURGE=true
    fi
  fi

  STEP_TOTAL=1
  $INSTALL_PROJECT && STEP_TOTAL=$((STEP_TOTAL + 2))
  $INSTALL_GLOBAL  && STEP_TOTAL=$((STEP_TOTAL + 1))

  section "REMOVING"

  remove_from() {
    local dest="$1" label="$2"
    step "Cleaning $label"

    if [[ -d "$dest/brag" ]]; then
      rm -rf "$dest/brag"
      ok "removed $dest/brag"
    else
      skip "brag not found in $dest — nothing to remove"
    fi

    if $PURGE; then
      local n=0 name
      for d in "$dest"/*/; do
        [[ -e "$d" ]] || continue
        name="$(basename "$d")"
        if [[ "$name" == "hyperframes" || "$name" == hyperframes-* || \
              "$name" == "general-video" ]]; then
          rm -rf "$dest/$name"
          n=$((n + 1))
        fi
      done
      if [[ $n -gt 0 ]]; then
        ok "removed $n Hyperframes companion package(s)"
        SUMMARY_REMOVED_HF=$((SUMMARY_REMOVED_HF + n))
      else
        skip "no Hyperframes packages found in $dest"
      fi
    fi
  }

  if $INSTALL_PROJECT; then
    remove_from "$PROJECT_DIR/.cursor/skills" "project skills ($PROJECT_DIR)"
    SUMMARY_REMOVED_PROJECT="$PROJECT_DIR"

    step "Removing the Cursor fallback rule"
    if [[ -f "$PROJECT_DIR/.cursor/rules/brag.mdc" ]]; then
      rm -f "$PROJECT_DIR/.cursor/rules/brag.mdc"
      ok "removed $PROJECT_DIR/.cursor/rules/brag.mdc"
      SUMMARY_REMOVED_RULE=true
    else
      skip "no brag.mdc found in $PROJECT_DIR/.cursor/rules/"
    fi
  fi

  if $INSTALL_GLOBAL; then
    remove_from "$HOME/.cursor/skills" "global skills (~/.cursor/skills)"
    SUMMARY_REMOVED_GLOBAL=true
  fi

  step "HeyGen credentials"
  if [[ -f "$HOME/.heygen/credentials" ]]; then
    if confirm "Remove your saved HeyGen API key too? (shared with the heygen CLI)" n; then
      rm -f "$HOME/.heygen/credentials"
      ok "removed ~/.heygen/credentials"
      SUMMARY_REMOVED_HEYGEN=true
    else
      skip "kept ~/.heygen/credentials"
    fi
  else
    skip "no HeyGen credentials file found"
  fi

  printf "\n"
  rule "═" "${CYAN}"
  printf "  %b🧹  All clean. /brag has left the building.%b\n" "${CYAN}${BOLD}" "${RESET}"
  rule "─" "${GRAY}"
  printf "\n"

  printf "  %bRemoved:%b\n" "${BOLD}" "${RESET}"
  if [[ -n "$SUMMARY_REMOVED_PROJECT" ]]; then
    printf "   %b✔%b  %s/.cursor/skills/brag\n" "${GREEN}" "${RESET}" "$SUMMARY_REMOVED_PROJECT"
    $SUMMARY_REMOVED_RULE && printf "   %b✔%b  %s/.cursor/rules/brag.mdc\n" \
      "${GREEN}" "${RESET}" "$SUMMARY_REMOVED_PROJECT"
  fi
  $SUMMARY_REMOVED_GLOBAL && printf "   %b✔%b  %s/.cursor/skills/brag  %b(global)%b\n" \
    "${GREEN}" "${RESET}" "$HOME" "${DIM}" "${RESET}"
  [[ $SUMMARY_REMOVED_HF -gt 0 ]] && printf "   %b✔%b  %d Hyperframes package(s)  %b(--purge)%b\n" \
    "${GREEN}" "${RESET}" "$SUMMARY_REMOVED_HF" "${DIM}" "${RESET}"
  $SUMMARY_REMOVED_HEYGEN && printf "   %b✔%b  HeyGen API key\n" "${GREEN}" "${RESET}"

  printf "\n"
  printf "  %bLeft untouched (these belong to your machine, not /brag):%b\n" "${DIM}" "${RESET}"
  printf "   %b·%b  Node.js, FFmpeg, Homebrew, uv\n" "${GRAY}" "${RESET}"

  printf "\n"
  rule "─" "${GRAY}"
  printf "\n"
  printf "  %bReinstate at any time:%b\n" "${DIM}" "${RESET}"
  printf "   %b\$%b  ./install-brag-cursor.sh install\n" "${GRAY}" "${RESET}"
  printf "\n"
  rule "═" "${CYAN}"
  printf "\n"
}

# ============================================================================
#  GO
# ============================================================================
if [[ "$MODE" == "uninstall" ]]; then
  do_uninstall
else
  do_install
fi
