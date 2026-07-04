# 🎬 brag-cursor-installer

**Install [/brag](https://github.com/latent-spaces/brag) into Cursor in one command.**  
Turn your project into a 15-second launch video — no video editor, no hassle.

![macOS](https://img.shields.io/badge/macOS-14%2B-555?logo=apple&labelColor=000)
![Cursor](https://img.shields.io/badge/Cursor-%E2%89%A5%202.4-7c3aed)
![Node.js](https://img.shields.io/badge/Node.js-22%2B-417e38?logo=node.js)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## What is /brag?

[/brag](https://github.com/latent-spaces/brag) is a [SKILL.md](https://agentskills.io) skill for AI coding agents. It reads your codebase, plans a storyboard, generates a video composition using [Hyperframes](https://github.com/heygen-com/hyperframes), and renders it to `brag-output/brag.mp4` — all autonomously, from inside your editor.

This repo provides an installer that wires /brag up to work natively inside **Cursor**.

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh \
  | bash -s -- install --both
```

Or download and run interactively (recommended for first-timers):

```bash
curl -O https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh
chmod +x install-brag-cursor.sh
./install-brag-cursor.sh
```

---

## What gets installed

```
~/.cursor/skills/              ← global (all Cursor projects on this Mac)
  ├── brag/
  │   ├── SKILL.md             ← the /brag skill definition
  │   └── references/          ← audio, composition, tone, and step guides
  ├── hyperframes/             ← video composition framework skill
  ├── hyperframes-creative/    ← audio-reactive templates + beat-sync
  └── general-video/           ← fallback video workflow

<project>/.cursor/             ← project-local (self-contained, portable)
  ├── skills/                  ← same as above
  └── rules/
      └── brag.mdc             ← compatibility fallback for Cursor < 2.4
```

The installer also ensures your toolchain is ready:

| Tool | Version | Auto-installed? |
|------|---------|----------------|
| Xcode Command Line Tools | any | ✓ (prompts you) |
| Homebrew | any | ✓ |
| Node.js | 22+ | ✓ |
| FFmpeg | any | ✓ |
| uv | any | optional |

---

## Usage

### Interactive (recommended for first run)

```bash
./install-brag-cursor.sh
```

The script guides you through:
1. Install or uninstall
2. Target: this project / global / both
3. Headless Chrome + environment health check
4. Optional: uv (high-fidelity beat-sync), HeyGen API key

### Non-interactive flags

```bash
# Install
./install-brag-cursor.sh install --project           # current folder
./install-brag-cursor.sh install --project /path     # specific folder
./install-brag-cursor.sh install --global            # all Cursor projects
./install-brag-cursor.sh install --both              # both (recommended)
./install-brag-cursor.sh install -y                  # no prompts

# Uninstall
./install-brag-cursor.sh uninstall --project
./install-brag-cursor.sh uninstall --global
./install-brag-cursor.sh uninstall --both --purge    # everything, no prompts

# Store HeyGen API key non-interactively
./install-brag-cursor.sh install --heygen-key YOUR_KEY_HERE
```

---

## Using /brag in Cursor

After installation, open your project in Cursor and type in the agent panel:

```
/brag
```

The agent will:

1. **Read** your project — codebase, README, website if you have one
2. **Plan** a 15–25 second storyboard with scenes and voiceover script
3. **Compose** a video using Hyperframes (HTML/CSS/JS composition → frames)
4. **Render** to `brag-output/brag.mp4` via headless Chrome + FFmpeg

### Tone presets

| Tone | Vibe |
|------|------|
| `default` | Clean, professional |
| `polished` | Sleek and refined |
| `yc-parody` | Demo Day energy |
| `chaotic` | Maximum vibes |
| `deadpan` | Dry, minimal |
| `cinematic` | Epic wide-shot feel |
| `app-store` | App Store preview style |

```
/brag --tone chaotic
/brag --tone cinematic
```

---

## How it works

```
You type /brag in Cursor
        │
        ▼
Cursor reads .cursor/skills/brag/SKILL.md
        │
        ├── Step 1  Read project (code, README, website)
        ├── Step 2  Plan storyboard + voiceover script
        ├── Step 3  Write Hyperframes composition
        │             (reads .cursor/skills/hyperframes/)
        └── Step 4  Render
                      │
                      ├── npx hyperframes render
                      │     → headless Chrome captures frames
                      │     → FFmpeg stitches → MP4
                      └── brag-output/brag.mp4  ✓
```

---

## Troubleshooting

**Cursor doesn't respond to /brag**
- Cursor ≥ 2.4 is required for native skill discovery
- For older Cursor: the `.cursor/rules/brag.mdc` fallback rule fires automatically on keywords like "let's brag" or "make a launch video"
- Restart Cursor after installation

**`hyperframes doctor` reports issues**
- Ensure FFmpeg is on PATH: `which ffmpeg` → if missing: `brew install ffmpeg`
- Ensure Node.js ≥ 22: `node -v` → if outdated: `brew install node@22`
- Re-run Chrome fetch: `npx hyperframes browser ensure`

**GitHub rate limit during `hyperframes skills update`**
```bash
gh auth login          # then retry
# or:
export GITHUB_TOKEN=ghp_...
npx hyperframes skills update
```

**Render finishes but no video in brag-output/**
- Check `brag-output/` for partial output and `*.log` files
- Run `npx hyperframes doctor` and address flagged issues
- Make sure headless Chrome is installed: `npx hyperframes browser ensure`

---

## Uninstall

```bash
./install-brag-cursor.sh uninstall
```

To also remove Hyperframes companion skills and skip all confirmation prompts:

```bash
./install-brag-cursor.sh uninstall --both --purge
```

> **Note:** Node.js, FFmpeg, Homebrew, and uv are **never removed** during uninstall — those are yours to manage.

---

## Credits

- [latent-spaces/brag](https://github.com/latent-spaces/brag) — the /brag skill itself
- [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) — video composition framework
- [agentskills.io](https://agentskills.io) — SKILL.md open standard for AI agent skills

---

## License

MIT
