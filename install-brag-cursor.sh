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
#  ────────────────────────────────────────────────────────────────────────
#  HOBBY PROJECT — This installer was written as a convenience wrapper.
#  The /brag skill itself was NOT developed by the author of this script.
#  All credit goes to latent-spaces: https://github.com/latent-spaces/brag
#  ────────────────────────────────────────────────────────────────────────
#
#  Skill:   https://github.com/latent-spaces/brag  (by latent-spaces)
#  Script:  https://github.com/clezcoding/brag-cursor-installer
#
# USAGE
#   chmod +x install-brag-cursor.sh
#   ./install-brag-cursor.sh                          interactive menu
#   ./install-brag-cursor.sh update                   self-update
#   ./install-brag-cursor.sh install --project        this folder only
#   ./install-brag-cursor.sh install --project /path  specific project
#   ./install-brag-cursor.sh install --global         all Cursor projects
#   ./install-brag-cursor.sh install --both           both (recommended)
#   ./install-brag-cursor.sh install -y               no prompts
#   ./install-brag-cursor.sh uninstall                remove (interactive)
#   ./install-brag-cursor.sh uninstall --both --purge remove everything
#
# OPTIONS
#   install | uninstall | update   Mode (prompted if omitted)
#   --project [DIR]       Target DIR/.cursor/skills  (default: cwd)
#   --global              Target ~/.cursor/skills
#   --both [DIR]          Both --project and --global
#   --purge               (uninstall) also remove Hyperframes companion skills
#   --heygen-key KEY      Save a HeyGen API key non-interactively
#   -y, --yes             Skip all prompts, use sensible defaults
#   -h, --help            Show this help and exit
#
# Safe to re-run — fully idempotent.

SCRIPT_VERSION="20260704.3"
SCRIPT_URL="https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh"

set -euo pipefail

ORIG_ARGS=("$@")  # saved before arg parsing — used to re-exec after update

# ═════════════════════════════════════════════════════════════════════════════
#  TERMINAL DETECTION
# ═════════════════════════════════════════════════════════════════════════════

# stdin must be a TTY for interactive prompts; stdout for colors.
# When piped (curl | bash), stdin is the pipe — NOT a TTY — skip prompts.
TTY_OK=false; [[ -t 0 ]] && [[ -t 1 ]] && TTY_OK=true
COLOR_OK=true; [[ -n "${NO_COLOR:-}" ]] && COLOR_OK=false; [[ -t 1 ]] || COLOR_OK=false

TERM_COLORS=8
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
  TERM_COLORS="$(tput colors 2>/dev/null || echo 8)"
fi

if $COLOR_OK && [[ "$TERM_COLORS" -ge 256 ]]; then
  RESET=$'\033[0m'    BOLD=$'\033[1m'         DIM=$'\033[2m'
  RED=$'\033[38;5;203m'    GREEN=$'\033[38;5;114m'  YELLOW=$'\033[38;5;221m'
  BLUE=$'\033[38;5;75m'    CYAN=$'\033[38;5;80m'    MAGENTA=$'\033[38;5;170m'
  PINK=$'\033[38;5;212m'   GRAY=$'\033[38;5;244m'   ORANGE=$'\033[38;5;215m'
  WHITE=$'\033[38;5;255m'
elif $COLOR_OK; then
  RESET=$'\033[0m'  BOLD=$'\033[1m'  DIM=$'\033[2m'
  RED=$'\033[0;31m'  GREEN=$'\033[0;32m'  YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m' CYAN=$'\033[0;36m'   MAGENTA=$'\033[0;35m'
  PINK=$'\033[0;35m' GRAY=$'\033[0;90m'   ORANGE=$'\033[0;33m'
  WHITE=$'\033[0;37m'
else
  RESET="" BOLD="" DIM="" RED="" GREEN="" YELLOW="" BLUE=""
  CYAN="" MAGENTA="" PINK="" GRAY="" ORANGE="" WHITE=""
fi

COLS=80
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
  COLS="$(tput cols 2>/dev/null || echo 80)"
fi
W=$COLS; [[ "$W" -gt 82 ]] && W=82; [[ "$W" -lt 40 ]] && W=40

# ═════════════════════════════════════════════════════════════════════════════
#  LAYOUT PRIMITIVES
# ═════════════════════════════════════════════════════════════════════════════

rule() {
  local ch="${1:-─}" clr="${2:-$GRAY}" line="" i=0
  while [[ $i -lt $W ]]; do line+="$ch"; i=$((i+1)); done
  printf "%b%s%b\n" "$clr" "$line" "$RESET"
}

banner() {
  local subtitle="${1:-}"
  printf "\n"
  if [[ $W -ge 70 ]]; then
    printf "  %b██████╗ ██████╗  █████╗  ██████╗%b" "${PINK}${BOLD}" "$RESET"
    printf "   %b/brag%b %b·%b %bfor Cursor%b\n" \
      "${CYAN}${BOLD}" "$RESET" "${GRAY}" "$RESET" "${WHITE}${BOLD}" "$RESET"
    printf "  %b██╔══██╗██╔══██╗██╔══██╗██╔════╝%b\n" "$MAGENTA" "$RESET"
    printf "  %b██████╔╝██████╔╝███████║██║  ███╗%b" "$PINK" "$RESET"
    printf "   %bTurn any project into a launch video%b\n" "$DIM" "$RESET"
    printf "  %b██╔══██╗██╔══██╗██╔══██║██║   ██║%b" "$MAGENTA" "$RESET"
    printf "   %bSkill by latent-spaces · hobby installer%b\n" "$DIM" "$RESET"
    printf "  %b██████╔╝██║  ██║██║  ██║╚██████╔╝%b\n" "$PINK" "$RESET"
    printf "  %b╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝%b" "$MAGENTA" "$RESET"
    printf "   %b★ latent-spaces/brag%b  %bv%s%b\n" \
      "$DIM" "$RESET" "$GRAY$DIM" "$SCRIPT_VERSION" "$RESET"
  else
    printf "  %b/brag%b  %b·%b  %bfor Cursor%b\n" \
      "${CYAN}${BOLD}" "$RESET" "${GRAY}" "$RESET" "${WHITE}${BOLD}" "$RESET"
    printf "  %blatent-spaces/brag · v%s%b\n" "$DIM" "$SCRIPT_VERSION" "$RESET"
  fi
  printf "\n"
  rule "─" "$GRAY"
  if [[ -n "$subtitle" ]]; then
    printf "  %b%s%b\n" "${BOLD}${ORANGE}" "$subtitle" "$RESET"
    rule "─" "$GRAY"
  fi
  printf "\n"
}

section() {
  local title="$1"
  local pad=$(( (W - ${#title} - 6) / 2 )) i=0
  [[ $pad -lt 1 ]] && pad=1
  local dashes=""
  while [[ $i -lt $pad ]]; do dashes+="─"; i=$((i+1)); done
  printf "\n  %b%s  %s  %s%b\n\n" "$CYAN$DIM" "$dashes" "$title" "$dashes" "$RESET"
}

print_menu() {
  local title="$1"; shift
  local tlen=${#title} bar="" i=0
  local needed=$(( W - tlen - 7 )); [[ $needed -lt 0 ]] && needed=0
  while [[ $i -lt $needed ]]; do bar+="─"; i=$((i+1)); done
  printf "\n  %b┌─ %s %s%b\n  %b│%b\n" \
    "${MAGENTA}${BOLD}" "$title" "$bar" "$RESET" \
    "${MAGENTA}${BOLD}" "$RESET"
  for item in "$@"; do
    printf "  %b│%b  %s\n" "${MAGENTA}${BOLD}" "$RESET" "$item"
  done
  printf "  %b│%b\n\n" "${MAGENTA}${BOLD}" "$RESET"
}

# ═════════════════════════════════════════════════════════════════════════════
#  STEP TRACKING
# ═════════════════════════════════════════════════════════════════════════════

STEP_TOTAL=15
STEP_CUR=0
STEP_NAMES=()
STEP_RESULTS=()    # ok | fail | skip | warn

step_start() {
  STEP_CUR=$((STEP_CUR + 1))
  local idx=$((STEP_CUR - 1))
  STEP_NAMES[$idx]="$1"
  STEP_RESULTS[$idx]="running"

  local pct=$(( STEP_CUR * 100 / STEP_TOTAL ))
  local barw=22 filled=$(( STEP_CUR * barw / STEP_TOTAL ))
  local bar="" i=0
  while [[ $i -lt $barw ]]; do
    [[ $i -lt $filled ]] && bar+="█" || bar+="░"
    i=$((i+1))
  done

  printf "\n"
  printf "  %b[%02d/%02d]%b  %b%s%b  %b%3d%%%b  %s\n" \
    "${DIM}" "$STEP_CUR" "$STEP_TOTAL" "$RESET" \
    "${CYAN}${DIM}" "$bar" "$RESET" \
    "${BOLD}" "$pct" "$RESET" \
    "$1"
}

_set_step() {
  local status="$1" icon="$2" clr="$3" msg="${4:-}"
  local idx=$((STEP_CUR - 1))
  STEP_RESULTS[$idx]="$status"
  [[ -n "$msg" ]] && printf "  %b%s%b  %s\n" "${clr}${BOLD}" "$icon" "$RESET" "$msg"
}

step_ok()   { _set_step ok   "✓" "$GREEN"  "${1:-}"; }
step_fail() { _set_step fail "✗" "$RED"    "${1:-}"; }
step_skip() { _set_step skip "·" "$GRAY"   "${1:-}"; }
step_warn() { _set_step warn "⚠" "$YELLOW" "${1:-}"; }

info()   { printf "     %b→%b  %s\n"  "$BLUE"   "$RESET" "$1"; }
detail() { printf "       %b%s%b\n"   "$DIM"    "$1"     "$RESET"; }
note()   { printf "  %b⚠%b  %s\n"    "$YELLOW" "$RESET" "$1"; }
err()    { printf "  %b✗%b  %s\n"    "$RED"    "$RESET" "$1" >&2; }

confirm() {
  local question="$1" default="${2:-n}" answer
  local hint="y/N"; [[ "$default" == "y" ]] && hint="Y/n"
  if $NONINTERACTIVE || ! $TTY_OK; then
    [[ "$default" == "y" ]] && return 0 || return 1
  fi
  read -r -p "  ${question} [${hint}]: " answer
  answer="${answer:-$default}"
  [[ "$answer" =~ ^[jJyY] ]]
}

run_with_spinner() {
  local label="$1"; shift
  local logfile; logfile="$(mktemp)"
  "$@" >"$logfile" 2>&1 &
  local pid=$!
  if $TTY_OK; then
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') i=0
    while kill -0 "$pid" 2>/dev/null; do
      printf "\r     %b%s%b  %b%s%b" "$CYAN" "${frames[$((i%10))]}" "$RESET" "$DIM" "$label" "$RESET"
      i=$((i+1)); sleep 0.1
    done
    printf "\r%-${W}s\r" ""
  fi
  local rc=0; wait "$pid" || rc=$?
  if [[ $rc -ne 0 ]]; then
    printf "  %b┌─ output (last 15 lines) %b\n" "$DIM$RED" "$RESET"
    tail -n 15 "$logfile" | while IFS= read -r line; do
      printf "  %b│%b  %s\n" "$DIM$RED" "$RESET" "$line"
    done
    printf "  %b└%b\n" "$DIM$RED" "$RESET"
  fi
  rm -f "$logfile"
  return $rc
}

print_summary_card() {
  local ok=0 fail=0 skip=0 warn=0 i
  for ((i=0; i<${#STEP_RESULTS[@]}; i++)); do
    case "${STEP_RESULTS[$i]:-}" in
      ok)   ok=$((ok+1))   ;;
      fail) fail=$((fail+1));;
      skip) skip=$((skip+1));;
      warn) warn=$((warn+1));;
    esac
  done
  local done_count=$((ok + warn))

  printf "\n  "
  printf "%b%d/%d%b " "$BOLD$GREEN" "$done_count" "$STEP_TOTAL" "$RESET"
  printf "%bsteps%b" "$DIM" "$RESET"
  [[ $fail -gt 0 ]] && printf "  %b·%b  %b%d failed%b"   "$GRAY" "$RESET" "$RED$BOLD"    "$fail"   "$RESET"
  [[ $warn -gt 0 ]] && printf "  %b·%b  %b%d warned%b"   "$GRAY" "$RESET" "$YELLOW$BOLD" "$warn"   "$RESET"
  [[ $skip -gt 0 ]] && printf "  %b·%b  %b%d skipped%b"  "$GRAY" "$RESET" "$GRAY"        "$skip"   "$RESET"
  printf "\n\n"

  local total=${#STEP_NAMES[@]}
  local half=$(( (total + 1) / 2 ))
  local col=30

  for ((i=0; i<half; i++)); do
    local j=$((i + half))
    local li="${STEP_RESULTS[$i]:-?}" ln="${STEP_NAMES[$i]:-}"
    local num_l; num_l=$(printf "%02d" $((i+1)))
    local icon_l clr_l
    case "$li" in
      ok)   icon_l="✓"; clr_l="$GREEN" ;;
      fail) icon_l="✗"; clr_l="$RED"   ;;
      skip) icon_l="·"; clr_l="$GRAY"  ;;
      warn) icon_l="⚠"; clr_l="$YELLOW";;
      *)    icon_l="?"; clr_l="$GRAY"  ;;
    esac

    local icon_r="" clr_r="" num_r="" rn=""
    if [[ $j -lt $total ]]; then
      local rj="${STEP_RESULTS[$j]:-?}"
      rn="${STEP_NAMES[$j]:-}"
      num_r=$(printf "%02d" $((j+1)))
      case "$rj" in
        ok)   icon_r="✓"; clr_r="$GREEN" ;;
        fail) icon_r="✗"; clr_r="$RED"   ;;
        skip) icon_r="·"; clr_r="$GRAY"  ;;
        warn) icon_r="⚠"; clr_r="$YELLOW";;
        *)    icon_r="?"; clr_r="$GRAY"  ;;
      esac
    fi

    printf "    %b%s%b %b%s%b %-${col}s" \
      "${clr_l}${BOLD}" "$icon_l" "$RESET" \
      "$DIM" "$num_l" "$RESET" \
      "$ln"

    if [[ -n "$icon_r" ]]; then
      printf "  %b%s%b %b%s%b %s" \
        "${clr_r}${BOLD}" "$icon_r" "$RESET" \
        "$DIM" "$num_r" "$RESET" \
        "$rn"
    fi
    printf "\n"
  done
}

# ═════════════════════════════════════════════════════════════════════════════
#  AUTO-UPDATE
# ═════════════════════════════════════════════════════════════════════════════

do_update() {
  local explicit="${1:-false}"

  local selfpath="$0"
  if [[ "$selfpath" == "bash" || "$selfpath" == "-bash" || ! -f "$selfpath" ]]; then
    if $explicit; then
      printf "  %b·%b  Running via pipe — save the script first:\n" "$GRAY" "$RESET"
      printf "     curl -fsSL %s -o /tmp/install-brag.sh\n" "$SCRIPT_URL"
      printf "     chmod +x /tmp/install-brag.sh && /tmp/install-brag.sh update\n"
    fi
    return 0
  fi

  $explicit && printf "\n" && rule "─" "$GRAY"
  printf "  %bChecking for updates…%b\n" "$DIM" "$RESET"

  local remote_ver
  remote_ver=$(curl -fsSL --max-time 5 "$SCRIPT_URL" 2>/dev/null \
    | grep '^SCRIPT_VERSION=' | head -1 \
    | tr -d '"' | cut -d= -f2 || echo "")

  if [[ -z "$remote_ver" ]]; then
    printf "  %b⚠%b  Could not reach GitHub — check your connection.\n" "$YELLOW" "$RESET"
    $explicit && printf "\n" && rule "─" "$GRAY" && printf "\n"
    return 0
  fi

  if [[ "$remote_ver" == "$SCRIPT_VERSION" ]]; then
    printf "  %b✓%b  Already up to date  %bv%s%b\n" "$GREEN" "$RESET" "$DIM" "$SCRIPT_VERSION" "$RESET"
    $explicit && printf "\n" && rule "─" "$GRAY" && printf "\n"
    return 0
  fi

  printf "  %b↑%b  New version available  %bv%s%b → %bv%s%b\n" \
    "$CYAN$BOLD" "$RESET" \
    "$DIM" "$SCRIPT_VERSION" "$RESET" \
    "$BOLD$CYAN" "$remote_ver" "$RESET"

  if ! confirm "  Update now and restart?" y; then
    printf "  %b·%b  Skipping — continuing with v%s\n" "$GRAY" "$RESET" "$SCRIPT_VERSION"
    $explicit && printf "\n" && rule "─" "$GRAY" && printf "\n"
    return 0
  fi

  local tmp; tmp="$(mktemp)"
  if ! curl -fsSL "$SCRIPT_URL" -o "$tmp" 2>/dev/null; then
    printf "  %b✗%b  Download failed — try again later.\n" "$RED" "$RESET"
    rm -f "$tmp"
    $explicit && exit 1 || return 0
  fi

  cp "$tmp" "$selfpath"
  chmod +x "$selfpath"
  rm -f "$tmp"
  printf "  %b✓%b  Updated to v%s — restarting…\n\n" "$GREEN$BOLD" "$RESET" "$remote_ver"

  if $explicit; then
    exec "$selfpath"
  else
    exec "$selfpath" "${ORIG_ARGS[@]}"
  fi
}

# ═════════════════════════════════════════════════════════════════════════════
#  ARGUMENTS
# ═════════════════════════════════════════════════════════════════════════════

MODE=""
INSTALL_PROJECT=false
INSTALL_GLOBAL=false
PROJECT_DIR=""
NONINTERACTIVE=false
PURGE=false
HEYGEN_KEY_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    install|uninstall|update) MODE="$1" ;;
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
      grep '^#' "$0" | sed 's/^# \{0,1\}//' | sed -n '2,40p'; exit 0 ;;
    *)
      if [[ -d "$1" ]]; then
        INSTALL_PROJECT=true; PROJECT_DIR="$1"
      else
        printf "  %b·%b  Ignoring unknown argument: %s\n" "$GRAY" "$RESET" "$1"
      fi ;;
  esac
  shift
done

if [[ "$(uname)" != "Darwin" ]]; then
  printf "✗  This script is macOS-only.\n" >&2; exit 1
fi

if [[ "$MODE" == "update" ]]; then
  banner "SELF-UPDATE"
  do_update true
  exit 0
fi

# Silent update check on interactive runs
if $TTY_OK && ! $NONINTERACTIVE; then
  do_update false
fi

if [[ -z "$MODE" ]]; then
  if $NONINTERACTIVE || ! $TTY_OK; then
    MODE="install"
  else
    banner ""
    print_menu "WHAT WOULD YOU LIKE TO DO?" \
      "1)  ${BOLD}install${RESET}    — set up /brag and everything it needs" \
      "2)  ${BOLD}uninstall${RESET}  — cleanly remove /brag from this machine" \
      "3)  ${BOLD}update${RESET}     — update this installer to the latest version"
    choice=""
    while [[ -z "$choice" ]]; do
      read -r -p "  Choice [1-3]: " choice
      case "$choice" in
        1) MODE="install" ;;
        2) MODE="uninstall" ;;
        3) do_update true; exit 0 ;;
        *) printf "  %b·%b  Please type 1, 2, or 3.\n" "$GRAY" "$RESET"; choice="" ;;
      esac
    done
  fi
fi

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
        read -r -p "  Choice [1-3]: " choice
        case "$choice" in
          1) INSTALL_PROJECT=true ;;
          2) INSTALL_GLOBAL=true ;;
          3) INSTALL_PROJECT=true; INSTALL_GLOBAL=true ;;
          *) printf "  %b·%b  Please type 1, 2, or 3.\n" "$GRAY" "$RESET"; choice="" ;;
        esac
      done
    fi
  fi

  if $INSTALL_PROJECT && [[ -z "$PROJECT_DIR" ]]; then
    if $NONINTERACTIVE || ! $TTY_OK; then
      PROJECT_DIR="$(pwd)"
    else
      read -r -e -p "  Project path [$(pwd)]: " PROJECT_DIR
      PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
    fi
  fi

  if $INSTALL_PROJECT; then
    if [[ ! -d "$PROJECT_DIR" ]]; then err "Directory not found: $PROJECT_DIR"; exit 1; fi
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
  fi

  printf "\n"
  printf "  %bTarget(s)%b\n" "$BOLD" "$RESET"
  $INSTALL_PROJECT && printf "  %b→%b  %s/.cursor/skills  %b(project-local)%b\n" \
    "$CYAN" "$RESET" "$PROJECT_DIR" "$DIM" "$RESET"
  $INSTALL_GLOBAL  && printf "  %b→%b  %s/.cursor/skills  %b(global)%b\n" \
    "$CYAN" "$RESET" "$HOME" "$DIM" "$RESET"
}

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

# ═════════════════════════════════════════════════════════════════════════════
#  INSTALL
# ═════════════════════════════════════════════════════════════════════════════
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

  step_start "Xcode Command Line Tools"
  if ! xcode-select -p >/dev/null 2>&1; then
    info "Launching installer — approve the dialog that appears."
    xcode-select --install || true
    note "Once Xcode CLT finishes, re-run this script to continue."
    step_fail "install dialog opened — re-run after it completes"
    exit 1
  else
    step_ok "$(xcode-select -p 2>/dev/null)"
  fi

  step_start "Homebrew"
  if ! command -v brew >/dev/null 2>&1; then
    if run_with_spinner "Installing Homebrew" \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
      if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi
      step_ok "$(brew --version | head -1)"
    else
      step_fail "install failed — see output above"
    fi
  else
    step_ok "$(brew --version | head -1)"
  fi

  step_start "Node.js 22+"
  NEED_NODE=true
  if command -v node >/dev/null 2>&1; then
    NODE_MAJOR="$(node -v | sed 's/^v//' | cut -d. -f1)"
    if [[ "$NODE_MAJOR" -ge 22 ]]; then
      NEED_NODE=false; step_ok "Node.js $(node -v)"
    else
      info "Found Node.js $(node -v) — needs v22+, upgrading"
    fi
  fi
  if $NEED_NODE; then
    if run_with_spinner "Installing Node.js 22 via Homebrew" brew install node@22; then
      brew link --overwrite --force node@22 >/dev/null 2>&1 || true
      hash -r
      step_ok "Node.js $(node -v 2>/dev/null || echo 'installed')"
    else
      step_fail "install failed — try: brew install node@22"
    fi
  fi

  step_start "FFmpeg"
  if ! command -v ffmpeg >/dev/null 2>&1; then
    if run_with_spinner "Installing FFmpeg via Homebrew" brew install ffmpeg; then
      step_ok "$(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f1-3)"
    else
      step_fail "install failed — try: brew install ffmpeg"
    fi
  else
    step_ok "$(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f1-3)"
  fi

  step_start "git"
  if ! command -v git >/dev/null 2>&1; then
    step_fail "not found — reinstall Xcode Command Line Tools"; exit 1
  else
    step_ok "$(git --version)"
  fi

  step_start "Cursor.app"
  if [[ -d "/Applications/Cursor.app" ]]; then
    step_ok "found in /Applications"
  else
    step_warn "not found in /Applications — OK if installed elsewhere"
  fi

  section "THE SKILL"

  step_start "Clone latent-spaces/brag"
  WORK_DIR="$(mktemp -d)"
  trap 'rm -rf "$WORK_DIR"' EXIT
  if run_with_spinner "Cloning latent-spaces/brag (shallow)" \
      git clone --depth 1 --quiet https://github.com/latent-spaces/brag.git "$WORK_DIR/brag"; then
    local brag_commit=""
    brag_commit=$(git -C "$WORK_DIR/brag" log -1 --format="%h %cd" --date=short 2>/dev/null || echo "")
    step_ok "cloned${brag_commit:+ — $brag_commit}"
  else
    step_fail "clone failed — check network or GitHub status"; exit 1
  fi

  step_start "Hyperframes companion skills"
  HF_STORE=""
  if run_with_spinner "npx hyperframes@latest skills update" \
      npx --yes hyperframes@latest skills update; then
    local hf_univ="$HOME/.agents/skills" hf_cl="$HOME/.claude/skills"
    [[ -d "$hf_univ" ]] && HF_STORE="$hf_univ"
    [[ -z "$HF_STORE" ]] && [[ -d "$hf_cl" ]] && HF_STORE="$hf_cl"
    if [[ -n "$HF_STORE" ]]; then
      local pkg_count=0
      while IFS= read -r _; do pkg_count=$((pkg_count+1)); done \
        < <(hf_relevant_skill_dirs "$HF_STORE")
      step_ok "${pkg_count} package(s) → $HF_STORE"
    else
      step_warn "installed, but skill store not found — mirror step may warn"
    fi
  else
    step_warn "update failed — retry: npx hyperframes skills update"
  fi

  step_start "Mirror Hyperframes → ~/.cursor/skills"
  local hf_univ="$HOME/.agents/skills" hf_cl="$HOME/.claude/skills"
  [[ -z "$HF_STORE" ]] && [[ -d "$hf_univ" ]] && HF_STORE="$hf_univ"
  [[ -z "$HF_STORE" ]] && [[ -d "$hf_cl"   ]] && HF_STORE="$hf_cl"

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
    step_ok "${HF_COUNT} package(s) → ~/.cursor/skills"
  else
    step_skip "skill store not found — skipped"
  fi

  step_start "Deploy /brag skill"
  deploy_brag() {
    local dest="$1"
    mkdir -p "$dest"; rm -rf "$dest/brag"
    cp -R "$WORK_DIR/brag/skills/brag" "$dest/brag"
  }

  local deploy_ok=false
  if $INSTALL_PROJECT; then
    deploy_brag "$PROJECT_DIR/.cursor/skills"
    info "/brag → $PROJECT_DIR/.cursor/skills/brag"
    SUMMARY_PROJECT_PATH="$PROJECT_DIR"
    if [[ -n "$HF_STORE" ]]; then
      HF_COUNT=0
      while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        rm -rf "$PROJECT_DIR/.cursor/skills/$name"
        cp -R "$HF_STORE/$name" "$PROJECT_DIR/.cursor/skills/$name"
        HF_COUNT=$((HF_COUNT + 1))
      done < <(hf_relevant_skill_dirs "$HF_STORE")
      detail "+ ${HF_COUNT} Hyperframes package(s) — project is self-contained"
    fi
    deploy_ok=true
  fi
  if $INSTALL_GLOBAL; then
    deploy_brag "$HOME/.cursor/skills"
    info "/brag → ~/.cursor/skills/brag"
    SUMMARY_GLOBAL=true; deploy_ok=true
  fi
  $deploy_ok && step_ok "deployed" || step_fail "no target — set --project or --global"

  step_start "Fallback rule  (Cursor < 2.4)"
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
    step_ok "$RULES_DIR/brag.mdc"
  else
    step_skip "no project target — rules are project-scoped"
  fi

  section "RENDER PIPELINE"

  step_start "Headless Chrome"
  local check_dir="${PROJECT_DIR:-$HOME}"
  if (cd "$check_dir" && run_with_spinner "Fetching headless Chrome" \
      npx --yes hyperframes browser ensure); then
    step_ok "ready"
  else
    step_warn "download failed — will retry automatically on first render"
  fi

  step_start "Environment check  (npx hyperframes doctor)"
  if (cd "$check_dir" && npx --yes hyperframes doctor >/dev/null 2>&1); then
    step_ok "all checks passed"
  else
    (cd "$check_dir" && npx --yes hyperframes doctor 2>&1 | \
      while IFS= read -r line; do
        printf "     %b│%b  %s\n" "$DIM" "$RESET" "$line"
      done) || true
    step_warn "some checks flagged — fix before running /brag"
  fi

  section "OPTIONAL EXTRAS"

  step_start "uv  (high-fidelity beat detection)"
  if command -v uv >/dev/null 2>&1; then
    step_ok "$(uv --version) — already installed"; SUMMARY_UV="already present"
  else
    info "Without uv, /brag uses npx hyperframes beats — works great."
    if confirm "  Install uv for higher-accuracy beat detection?" n; then
      if run_with_spinner "Installing uv via Homebrew" brew install uv; then
        step_ok "$(uv --version)"; SUMMARY_UV="installed"
      else
        step_warn "install failed — try: brew install uv"
      fi
    else
      step_skip "skipped — built-in beat engine is solid"
    fi
  fi

  step_start "HeyGen API key  (AI presenter overlays)"
  HEYGEN_KEY="$HEYGEN_KEY_ARG"
  if [[ -z "$HEYGEN_KEY" ]] && ! $NONINTERACTIVE && $TTY_OK; then
    info "Free tier: https://app.heygen.com/settings?tab=API"
    read -r -p "  Paste key (Enter to skip): " HEYGEN_KEY
  fi
  if [[ -n "$HEYGEN_KEY" ]]; then
    if echo "$HEYGEN_KEY" | npx --yes hyperframes auth login --api-key >/dev/null 2>&1; then
      step_ok "saved to ~/.heygen/credentials"; SUMMARY_HEYGEN="configured"
    else
      step_warn "save failed — try: npx hyperframes auth login"
    fi
  else
    step_skip "skipped — local rendering works without HeyGen"
  fi

  printf "\n"
  rule "═" "$GREEN"
  printf "\n"
  printf "  %b✨  Done. Something worth bragging about.%b\n" "$GREEN$BOLD" "$RESET"
  printf "\n"

  print_summary_card

  printf "\n"
  rule "─" "$GRAY"
  printf "\n"

  printf "  %bInstalled%b\n" "$BOLD" "$RESET"
  if [[ -n "$SUMMARY_PROJECT_PATH" ]]; then
    printf "  %b→%b  %s/.cursor/skills/brag\n" "$CYAN" "$RESET" "$SUMMARY_PROJECT_PATH"
    printf "  %b→%b  %s/.cursor/rules/brag.mdc  %b(Cursor < 2.4 fallback)%b\n" \
      "$CYAN" "$RESET" "$SUMMARY_PROJECT_PATH" "$DIM" "$RESET"
  fi
  $SUMMARY_GLOBAL && printf "  %b→%b  %s/.cursor/skills/brag  %b(global)%b\n" \
    "$CYAN" "$RESET" "$HOME" "$DIM" "$RESET"
  [[ $SUMMARY_HF_COUNT -gt 0 ]] && \
    printf "  %b→%b  %d Hyperframes companion package(s)\n" "$CYAN" "$RESET" "$SUMMARY_HF_COUNT"
  [[ "$SUMMARY_UV" != "skipped" ]] && \
    printf "  %b→%b  uv  %b(%s)%b\n" "$CYAN" "$RESET" "$DIM" "$SUMMARY_UV" "$RESET"
  [[ "$SUMMARY_HEYGEN" != "skipped" ]] && \
    printf "  %b→%b  HeyGen API key configured\n" "$CYAN" "$RESET"

  printf "\n"
  rule "─" "$GRAY"
  printf "\n"
  printf "  %bNext steps%b\n" "$BOLD" "$RESET"
  if [[ -n "$SUMMARY_PROJECT_PATH" ]]; then
    printf "  %b→%b  Open %b%s%b in Cursor\n" "$CYAN" "$RESET" "$BOLD" "$SUMMARY_PROJECT_PATH" "$RESET"
    printf "  %b→%b  Agent panel  →  %b/brag%b\n" "$CYAN" "$RESET" "$BOLD" "$RESET"
  elif $SUMMARY_GLOBAL; then
    printf "  %b→%b  Any project in Cursor → agent panel → %b/brag%b\n" \
      "$CYAN" "$RESET" "$BOLD" "$RESET"
  fi
  printf "  %b→%b  Try a tone:  %b/brag --tone chaotic%b\n" "$CYAN" "$RESET" "$BOLD" "$RESET"
  printf "     %bOther tones: polished  deadpan  cinematic  yc-parody  app-store%b\n" "$DIM" "$RESET"
  printf "\n"
  printf "  %bUseful commands%b\n" "$DIM" "$RESET"
  printf "  %b\$%b  ./install-brag-cursor.sh update\n" "$GRAY" "$RESET"
  printf "  %b\$%b  ./install-brag-cursor.sh install --project /path/to/other\n" "$GRAY" "$RESET"
  printf "  %b\$%b  ./install-brag-cursor.sh uninstall\n" "$GRAY" "$RESET"
  printf "\n"
  rule "═" "$GREEN"
  printf "\n"
}

# ═════════════════════════════════════════════════════════════════════════════
#  UNINSTALL
# ═════════════════════════════════════════════════════════════════════════════
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
    if confirm "  Also remove Hyperframes companion skills?" n; then PURGE=true; fi
  fi

  STEP_TOTAL=1
  $INSTALL_PROJECT && STEP_TOTAL=$((STEP_TOTAL + 2))
  $INSTALL_GLOBAL  && STEP_TOTAL=$((STEP_TOTAL + 1))

  section "REMOVING"

  remove_from() {
    local dest="$1" label="$2"
    step_start "Remove $label"
    if [[ -d "$dest/brag" ]]; then
      rm -rf "$dest/brag"; info "removed $dest/brag"
    else
      detail "brag not found in $dest"
    fi
    if $PURGE; then
      local n=0 name
      for d in "$dest"/*/; do
        [[ -e "$d" ]] || continue
        name="$(basename "$d")"
        if [[ "$name" == "hyperframes" || "$name" == hyperframes-* || \
              "$name" == "general-video" ]]; then
          rm -rf "$dest/$name"; n=$((n+1))
        fi
      done
      [[ $n -gt 0 ]] && info "removed ${n} Hyperframes package(s)" \
        && SUMMARY_REMOVED_HF=$((SUMMARY_REMOVED_HF + n))
    fi
    step_ok "cleaned"
  }

  if $INSTALL_PROJECT; then
    remove_from "$PROJECT_DIR/.cursor/skills" "project skills"
    SUMMARY_REMOVED_PROJECT="$PROJECT_DIR"
    step_start "Remove fallback rule"
    if [[ -f "$PROJECT_DIR/.cursor/rules/brag.mdc" ]]; then
      rm -f "$PROJECT_DIR/.cursor/rules/brag.mdc"
      step_ok "removed $PROJECT_DIR/.cursor/rules/brag.mdc"
      SUMMARY_REMOVED_RULE=true
    else
      step_skip "no brag.mdc found"
    fi
  fi

  if $INSTALL_GLOBAL; then
    remove_from "$HOME/.cursor/skills" "global skills"
    SUMMARY_REMOVED_GLOBAL=true
  fi

  step_start "HeyGen credentials"
  if [[ -f "$HOME/.heygen/credentials" ]]; then
    if confirm "  Remove saved HeyGen API key?" n; then
      rm -f "$HOME/.heygen/credentials"
      step_ok "removed ~/.heygen/credentials"; SUMMARY_REMOVED_HEYGEN=true
    else
      step_skip "kept ~/.heygen/credentials"
    fi
  else
    step_skip "no credentials file found"
  fi

  printf "\n"
  rule "═" "$CYAN"
  printf "\n"
  printf "  %b🧹  All clean. /brag has left the building.%b\n" "$CYAN$BOLD" "$RESET"
  printf "\n"

  print_summary_card

  printf "\n"
  rule "─" "$GRAY"
  printf "\n"
  printf "  %bRemoved%b\n" "$BOLD" "$RESET"
  if [[ -n "$SUMMARY_REMOVED_PROJECT" ]]; then
    printf "  %b→%b  %s/.cursor/skills/brag\n" "$CYAN" "$RESET" "$SUMMARY_REMOVED_PROJECT"
    $SUMMARY_REMOVED_RULE && printf "  %b→%b  %s/.cursor/rules/brag.mdc\n" \
      "$CYAN" "$RESET" "$SUMMARY_REMOVED_PROJECT"
  fi
  $SUMMARY_REMOVED_GLOBAL && printf "  %b→%b  %s/.cursor/skills/brag  %b(global)%b\n" \
    "$CYAN" "$RESET" "$HOME" "$DIM" "$RESET"
  [[ $SUMMARY_REMOVED_HF -gt 0 ]] && printf "  %b→%b  %d Hyperframes package(s)\n" \
    "$CYAN" "$RESET" "$SUMMARY_REMOVED_HF"
  $SUMMARY_REMOVED_HEYGEN && printf "  %b→%b  HeyGen API key\n" "$CYAN" "$RESET"
  printf "\n"
  printf "  %bLeft untouched (belong to your machine, not /brag)%b\n" "$DIM" "$RESET"
  printf "     %bNode.js · FFmpeg · Homebrew · uv%b\n" "$GRAY" "$RESET"
  printf "\n"
  printf "  %b\$%b  ./install-brag-cursor.sh install\n" "$GRAY" "$RESET"
  printf "\n"
  rule "═" "$CYAN"
  printf "\n"
}

# ═════════════════════════════════════════════════════════════════════════════
#  GO
# ═════════════════════════════════════════════════════════════════════════════
if [[ "$MODE" == "uninstall" ]]; then
  do_uninstall
else
  do_install
fi
