<div align="center">

<pre>
 ██████╗ ██████╗  █████╗  ██████╗ 
 ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
 ██████╔╝██████╔╝███████║██║  ███╗
 ██╔══██╗██╔══██╗██╔══██║██║   ██║
 ██████╔╝██║  ██║██║  ██║╚██████╔╝
 ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
</pre>

### Dein Projekt. Ein Launch-Video. Direkt aus Cursor.
### *Your project. A launch video. Right from Cursor.*

[![macOS 14+](https://img.shields.io/badge/macOS-14%2B-555?logo=apple&labelColor=000)](https://www.apple.com/macos/)
[![Cursor ≥2.4](https://img.shields.io/badge/Cursor-%E2%89%A52.4-7c3aed)](https://cursor.sh)
[![Node.js 22+](https://img.shields.io/badge/Node.js-22%2B-417e38?logo=node.js)](https://nodejs.org)
[![License MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Hobby Project](https://img.shields.io/badge/hobby-project-ff6b9d)](https://github.com/clezcoding/brag-cursor-installer)

</div>

---

> [!NOTE]
> **Hobby-Projekt · Hobby Project**
> 
> Dieses Repository ist ein inoffizieller Installer, den ich als persönliches Hobbyprojekt gebaut habe, um [latent-spaces/brag](https://github.com/latent-spaces/brag) einfach in Cursor einzurichten. **Der /brag Skill selbst wurde NICHT von mir entwickelt** — alle Credits gehören [latent-spaces](https://github.com/latent-spaces).
>
> *This is an unofficial installer I built as a personal hobby project to make [latent-spaces/brag](https://github.com/latent-spaces/brag) easy to set up in Cursor. **The /brag skill itself was NOT developed by me** — all credit goes to [latent-spaces](https://github.com/latent-spaces).*

---

## ⚡ One Command — Download & Start

> **Empfohlen · Recommended** — Behält das volle interaktive Terminal-Menü.
> *Preserves the full interactive terminal menu with TTY.*

```bash
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh -o /tmp/install-brag.sh && chmod +x /tmp/install-brag.sh && /tmp/install-brag.sh
```

<details>
<summary>🔹 Nicht-interaktiv (curl | bash) — Auto-install ins aktuelle Projekt</summary>

```bash
# Aktuelles Projekt + global (kein Prompt)
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh | bash -s -- install --both -y

# Nur global
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh | bash -s -- install --global -y
```

</details>

---

<details open>
<summary><h2>🇩🇪 Deutsch</h2></summary>

### 🎬 Was ist /brag?

[/brag](https://github.com/latent-spaces/brag) ist ein KI-Skill im [SKILL.md-Format](https://agentskills.io) für Cursor. Er liest dein Projekt, plant ein Storyboard, erstellt eine Videokomposition mit [Hyperframes](https://github.com/heygen-com/hyperframes) und rendert das fertige Video nach `brag-output/brag.mp4` — vollautomatisch.

Dieses Repository enthält einen macOS-Installer für **Cursor** — gebaut als Hobby-Projekt.

---

### 🤖 Was macht das Skript automatisch?

| # | Schritt | Status |
|:-:|---------|:------:|
| 01 | Xcode Command Line Tools | ⚠️ Dialog |
| 02 | Homebrew | ✅ Auto |
| 03 | Node.js 22+ | ✅ Auto |
| 04 | FFmpeg | ✅ Auto |
| 05 | git | ✅ Auto |
| 06 | Cursor.app prüfen | ✅ Auto |
| 07 | latent-spaces/brag klonen | ✅ Auto |
| 08 | Hyperframes companion skills | ✅ Auto |
| 09 | Skills in ~/.cursor/skills spiegeln | ✅ Auto |
| 10 | /brag deployen | ✅ Auto |
| 11 | Fallback-Regel für Cursor < 2.4 | ✅ Auto |
| 12 | Headless Chrome | ✅ Auto |
| 13 | `npx hyperframes doctor` | ✅ Auto |
| 14 | uv (optional) | 💬 Prompt |
| 15 | HeyGen API Key (optional) | 💬 Prompt |

---

### 🔄 Auto-Update

Das Skript kann sich selbst aktualisieren. Beim interaktiven Start wird automatisch nach Updates gesucht. Du kannst auch manuell updaten:

```bash
./install-brag.sh update
```

Wenn eine neue Version gefunden wird, wird sie heruntergeladen und das Skript startet automatisch neu mit denselben Argumenten.

---

### 🖐 Was musst du manuell tun?

| Schritt | Wann | Aktion |
|---------|------|--------|
| Xcode CLT Dialog | Nur wenn CLT fehlt | Dialog bestätigen, Skript neu starten |
| Installationsort | Immer (interaktiv) | 1 = Projekt / 2 = Global / 3 = Beides |
| uv installieren? | Optional | j/n Prompt |
| HeyGen API Key | Optional | Key einfügen oder Enter |
| **Cursor neu starten** | Nach Installation | Skills werden erkannt |
| **/brag tippen** | In Cursor | Im Agent-Panel |

---

### 📋 Schritt für Schritt

```
┌──────────────────────────────────────────────────────────────────────┐
│  SCHRITT 1  Download & Start                                         │
│                                                                      │
│  curl -fsSL https://raw.githubusercontent.com/clezcoding/            │
│    brag-cursor-installer/main/install-brag-cursor.sh \               │
│    -o /tmp/install-brag.sh &&                                        │
│    chmod +x /tmp/install-brag.sh && /tmp/install-brag.sh             │
├──────────────────────────────────────────────────────────────────────┤
│  SCHRITT 2  Modus wählen  [1] install  [2] uninstall  [3] update     │
├──────────────────────────────────────────────────────────────────────┤
│  SCHRITT 3  Ort wählen  → Empfehlung: Option 3 (Projekt + Global)   │
├──────────────────────────────────────────────────────────────────────┤
│  SCHRITT 4  Warten — 15 Schritte werden automatisch ausgeführt      │
│                                                                      │
│  [01] Xcode CLT     [06] Cursor.app   [11] Fallback-Regel            │
│  [02] Homebrew      [07] /brag klonen  [12] Headless Chrome          │
│  [03] Node.js 22+   [08] Hyperframes   [13] Doctor-Check             │
│  [04] FFmpeg        [09] Mirror skills [14] uv (optional)            │
│  [05] git           [10] Deploy /brag  [15] HeyGen (optional)        │
├──────────────────────────────────────────────────────────────────────┤
│  SCHRITT 5  Cursor neu starten                                       │
│  SCHRITT 6  Projekt in Cursor öffnen → Agent-Panel → /brag tippen   │
└──────────────────────────────────────────────────────────────────────┘
```

---

### 🎛 Alle Optionen

```bash
./install-brag-cursor.sh                             # interaktiv (empfohlen)
./install-brag-cursor.sh update                      # selbst aktualisieren
./install-brag-cursor.sh install --project           # aktueller Ordner
./install-brag-cursor.sh install --project /pfad     # bestimmter Ordner
./install-brag-cursor.sh install --global            # alle Cursor-Projekte
./install-brag-cursor.sh install --both              # beides (empfohlen)
./install-brag-cursor.sh install -y                  # keine Prompts
./install-brag-cursor.sh install --heygen-key KEY    # HeyGen Key direkt
./install-brag-cursor.sh uninstall                   # interaktiv deinstallieren
./install-brag-cursor.sh uninstall --both --purge    # alles entfernen
```

---

### 🎬 /brag in Cursor benutzen

1. **Cursor neu starten** nach der Installation
2. Projektordner in Cursor öffnen
3. Im **Agent-Panel** eingeben: `/brag`

**Töne:**

| Ton | Stimmung |
|-----|----------|
| `default` | Sauber, professionell |
| `polished` | Elegant, verfeinert |
| `yc-parody` | Demo-Day-Energie |
| `chaotic` | Maximum Vibes |
| `deadpan` | Trocken, minimalistisch |
| `cinematic` | Episches Kinoformat |
| `app-store` | App Store Preview |

```bash
/brag --tone cinematic
```

</details>

---

<details open>
<summary><h2>🇬🇧 English</h2></summary>

### 🎬 What is /brag?

[/brag](https://github.com/latent-spaces/brag) is an AI skill (in [SKILL.md format](https://agentskills.io)) for Cursor. It reads your project, plans a storyboard, generates a video using [Hyperframes](https://github.com/heygen-com/hyperframes), and renders it to `brag-output/brag.mp4` — fully autonomously.

This repository provides a macOS installer — built as a hobby project.

---

### 🤖 What does the script do automatically?

| # | Step | Status |
|:-:|------|:------:|
| 01 | Xcode Command Line Tools | ⚠️ Dialog |
| 02 | Homebrew | ✅ Auto |
| 03 | Node.js 22+ | ✅ Auto |
| 04 | FFmpeg | ✅ Auto |
| 05 | git | ✅ Auto |
| 06 | Verify Cursor.app | ✅ Auto |
| 07 | Clone latent-spaces/brag | ✅ Auto |
| 08 | Hyperframes companion skills | ✅ Auto |
| 09 | Mirror to ~/.cursor/skills | ✅ Auto |
| 10 | Deploy /brag | ✅ Auto |
| 11 | Fallback rule (Cursor < 2.4) | ✅ Auto |
| 12 | Headless Chrome | ✅ Auto |
| 13 | `npx hyperframes doctor` | ✅ Auto |
| 14 | uv (optional) | 💬 Prompt |
| 15 | HeyGen API key (optional) | 💬 Prompt |

---

### 🔄 Auto-Update

The script can update itself. On every interactive launch it silently checks for a new version. You can also update manually:

```bash
./install-brag.sh update
```

If a new version is found, it is downloaded and the script restarts automatically with the same arguments.

---

### 🖐 What do you need to do manually?

| Step | When | Action |
|------|------|--------|
| Xcode CLT dialog | Only if CLT is missing | Confirm dialog, re-run script |
| Install location | Always (interactive) | 1 = Project / 2 = Global / 3 = Both |
| Install uv? | Optional | y/n prompt |
| HeyGen API key | Optional | Paste key or press Enter |
| **Restart Cursor** | After installation | So new skills are discovered |
| **Type /brag** | In Cursor | In the agent panel |

---

### 📋 Step by Step

```
┌──────────────────────────────────────────────────────────────────────┐
│  STEP 1   Download & Start                                           │
│                                                                      │
│  curl -fsSL https://raw.githubusercontent.com/clezcoding/            │
│    brag-cursor-installer/main/install-brag-cursor.sh \               │
│    -o /tmp/install-brag.sh &&                                        │
│    chmod +x /tmp/install-brag.sh && /tmp/install-brag.sh             │
├──────────────────────────────────────────────────────────────────────┤
│  STEP 2   Choose mode  [1] install  [2] uninstall  [3] update        │
├──────────────────────────────────────────────────────────────────────┤
│  STEP 3   Choose location  → Recommended: Option 3 (Both)           │
├──────────────────────────────────────────────────────────────────────┤
│  STEP 4   Wait — 15 steps run automatically                          │
│                                                                      │
│  [01] Xcode CLT     [06] Cursor.app   [11] Fallback rule             │
│  [02] Homebrew      [07] Clone /brag   [12] Headless Chrome          │
│  [03] Node.js 22+   [08] Hyperframes   [13] Doctor check             │
│  [04] FFmpeg        [09] Mirror skills [14] uv (optional)            │
│  [05] git           [10] Deploy /brag  [15] HeyGen (optional)        │
├──────────────────────────────────────────────────────────────────────┤
│  STEP 5   Restart Cursor                                             │
│  STEP 6   Open project → agent panel → type /brag                   │
└──────────────────────────────────────────────────────────────────────┘
```

---

### 🎛 All Options

```bash
./install-brag-cursor.sh                             # interactive (recommended)
./install-brag-cursor.sh update                      # self-update
./install-brag-cursor.sh install --project           # current folder
./install-brag-cursor.sh install --project /path     # specific folder
./install-brag-cursor.sh install --global            # all Cursor projects
./install-brag-cursor.sh install --both              # both (recommended)
./install-brag-cursor.sh install -y                  # no prompts
./install-brag-cursor.sh install --heygen-key KEY    # HeyGen key directly
./install-brag-cursor.sh uninstall                   # interactive uninstall
./install-brag-cursor.sh uninstall --both --purge    # remove everything
```

---

### 🎬 Using /brag in Cursor

1. **Restart Cursor** after installation
2. Open your project in Cursor
3. In the **agent panel**, type: `/brag`

**Tones:**

| Tone | Vibe |
|------|------|
| `default` | Clean, professional |
| `polished` | Sleek and refined |
| `yc-parody` | Demo Day energy |
| `chaotic` | Maximum vibes |
| `deadpan` | Dry, minimal |
| `cinematic` | Epic wide-shot |
| `app-store` | App Store preview |

```bash
/brag --tone cinematic
```

---

### 🗑 Uninstall

```bash
./install-brag-cursor.sh uninstall
./install-brag-cursor.sh uninstall --both --purge   # remove everything
```

> Node.js, FFmpeg, Homebrew, and uv are **never** removed.

</details>

---

## 🔧 Troubleshooting

<details>
<summary><b>🔴 Cursor doesn't respond to /brag</b></summary>

- Cursor ≥ 2.4 required for native skill discovery
- For older versions: `.cursor/rules/brag.mdc` triggers automatically
- **Restart Cursor after installation!**

</details>

<details>
<summary><b>🔴 hyperframes doctor reports issues</b></summary>

```bash
brew install ffmpeg           # FFmpeg missing
brew install node@22 && brew link --overwrite --force node@22
npx hyperframes browser ensure
```

</details>

<details>
<summary><b>🔴 GitHub Rate Limit during hyperframes skills update</b></summary>

```bash
gh auth login
npx hyperframes skills update
# or:
export GITHUB_TOKEN=ghp_...
npx hyperframes skills update
```

</details>

---

## 📦 What gets installed

```
~/.cursor/skills/
  ├── brag/            /brag skill (by latent-spaces)
  ├── hyperframes/
  └── general-video/

<project>/.cursor/
  ├── skills/brag/
  └── rules/brag.mdc   Cursor < 2.4 fallback
```

---

## 🙏 Credits

| Project | Description |
|---------|-------------|
| [latent-spaces/brag](https://github.com/latent-spaces/brag) | **The /brag skill** — built by latent-spaces, not me |
| [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | Video composition framework |
| [agentskills.io](https://agentskills.io) | SKILL.md open standard |

---

<div align="center">

MIT License &nbsp;·&nbsp; Hobby project by clezcoding &nbsp;·&nbsp; /brag skill by latent-spaces

[⭐ Star latent-spaces/brag](https://github.com/latent-spaces/brag) &nbsp;·&nbsp; [📦 Hyperframes](https://github.com/heygen-com/hyperframes)

</div>
