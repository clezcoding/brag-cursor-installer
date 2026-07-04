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
[![Skill](https://img.shields.io/badge/SKILL.md-agentskills.io-ff6b9d)](https://agentskills.io)

</div>

---

## ⚡ One Command — Download & Start

> **Empfohlen · Recommended** — Diese Methode behält das volle interaktive Terminal-Menü.
> *This method preserves the full interactive terminal menu.*

```bash
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh -o /tmp/install-brag.sh && chmod +x /tmp/install-brag.sh && /tmp/install-brag.sh
```

<details>
<summary>🔹 Nicht-interaktiv (curl | bash) — Auto-Installiert ins aktuelle Projekt</summary>

> Wenn du `curl | bash` benutzt, gibt es kein interaktives Menü — das Script installiert automatisch in den aktuellen Ordner. Flags können direkt übergeben werden:
>
> *When using `curl | bash`, there's no interactive menu — the script auto-installs to the current folder. Flags can be passed directly:*

```bash
# Auto-install: aktuelles Projekt + global (kein Prompt)
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh | bash -s -- install --both -y

# Nur global
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh | bash -s -- install --global -y
```

</details>

---

<details open>
<summary><h2>🇩🇪 Deutsch</h2></summary>

### 🎬 Was ist /brag?

[/brag](https://github.com/latent-spaces/brag) ist ein KI-Skill im [SKILL.md-Format](https://agentskills.io) für Cursor und andere KI-Coding-Assistenten. Er liest dein Projekt, plant ein Storyboard, erstellt eine Videokomposition mit [Hyperframes](https://github.com/heygen-com/hyperframes) und rendert das fertige Video nach `brag-output/brag.mp4` — vollautomatisch, ohne Videoeditor.

Dieses Repository enthält ein macOS-Installationsskript, das alles für **Cursor** einrichtet.

---

### 🤖 Was macht das Skript automatisch?

Das Skript erledigt **fast alles** — du musst kaum etwas selbst machen:

| # | Schritt | Was passiert | Status |
|:-:|---------|-------------|:------:|
| 01 | Xcode Command Line Tools | Prüft ob vorhanden, startet Installer wenn nötig | ⚠️ Dialog |
| 02 | Homebrew | Wird installiert wenn nicht vorhanden | ✅ Auto |
| 03 | Node.js 22+ | Wird über Homebrew installiert wenn veraltet | ✅ Auto |
| 04 | FFmpeg | Wird über Homebrew installiert wenn fehlt | ✅ Auto |
| 05 | git | Wird geprüft (kommt mit Xcode CLT) | ✅ Auto |
| 06 | Cursor.app | Wird geprüft (Warnung wenn nicht in /Applications) | ✅ Auto |
| 07 | /brag Skill klonen | Von `latent-spaces/brag` (shallow clone) | ✅ Auto |
| 08 | Hyperframes Skills | `npx hyperframes skills update` global | ✅ Auto |
| 09 | Skills spiegeln | Hyperframes-Pakete → `~/.cursor/skills` | ✅ Auto |
| 10 | /brag deployen | In Projektordner und/oder global | ✅ Auto |
| 11 | Fallback-Regel | `.cursor/rules/brag.mdc` (für Cursor < 2.4) | ✅ Auto |
| 12 | Headless Chrome | `npx hyperframes browser ensure` | ✅ Auto |
| 13 | Umgebungscheck | `npx hyperframes doctor` | ✅ Auto |
| 14 | uv | Optional: fragt nach (Beat-Sync für eigene Musik) | 💬 Prompt |
| 15 | HeyGen API Key | Optional: fragt nach (KI-Presenter-Overlays) | 💬 Prompt |

---

### 🖐 Was musst du manuell tun?

Sehr wenig! Nur diese Dinge erfordern deinen Input:

| Schritt | Wann | Aktion |
|---------|------|--------|
| Xcode CLT Dialog | Nur wenn CLT fehlt | Dialog bestätigen, dann Skript nochmal starten |
| Installationsort | Immer (interaktiv) | 1 = Projekt / 2 = Global / 3 = Beides (empfohlen) |
| Projektpfad | Wenn Projekt gewählt | Enter = aktueller Ordner |
| uv installieren? | Optional | j/n Prompt |
| HeyGen API Key | Optional | Key einfügen oder Enter zum Überspringen |
| **Cursor neu starten** | Nach der Installation | Damit Skills erkannt werden |
| **/brag eintippen** | In Cursor | Im Agent-Panel |

---

### 📋 Schritt für Schritt

```
┌──────────────────────────────────────────────────────────────────────┐
│  INSTALLATION                                                         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SCHRITT 1  Download & Start                                         │
│                                                                      │
│  curl -fsSL https://raw.githubusercontent.com/clezcoding/            │
│    brag-cursor-installer/main/install-brag-cursor.sh \               │
│    -o /tmp/install-brag.sh && chmod +x /tmp/install-brag.sh \        │
│    && /tmp/install-brag.sh                                           │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SCHRITT 2  Modus wählen: install                                    │
│                                                                      │
│  SCHRITT 3  Installationsort wählen                                  │
│             → Option 3: Beides (Projekt + Global)  ← empfohlen      │
│             → Enter drücken für aktuellen Ordner                    │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SCHRITT 4  Warten — 15 Schritte automatisch:                       │
│                                                                      │
│  [01] Xcode CLT        [06] Cursor.app       [11] Fallback-Regel     │
│  [02] Homebrew         [07] /brag klonen      [12] Headless Chrome   │
│  [03] Node.js 22+      [08] Hyperframes       [13] doctor-Check      │
│  [04] FFmpeg           [09] Skills-Mirror     [14] uv (optional)     │
│  [05] git              [10] /brag deployen    [15] HeyGen (optional) │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SCHRITT 5  Cursor neu starten                                       │
│                                                                      │
│  SCHRITT 6  Projekt in Cursor öffnen → Agent-Panel → /brag tippen   │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

### 🎛 Alle Optionen

```bash
./install-brag-cursor.sh                             # interaktiv (empfohlen)
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
3. Im **Agent-Panel** eingeben:

```
/brag
```

4. Optional — Ton wählen:

| Ton | Stimmung | Beispiel |
|-----|----------|----------|
| `default` | Sauber, professionell | Startup-Pitch |
| `polished` | Elegant und verfeinert | Enterprise |
| `yc-parody` | Demo-Day-Energie | YC-Präsentation |
| `chaotic` | Maximum Vibes | Hacker-Vibe |
| `deadpan` | Trocken, minimalistisch | Dev-Tool |
| `cinematic` | Episches Kinoformat | Open-Source |
| `app-store` | App Store Preview Stil | Mobile App |

```bash
/brag --tone cinematic
/brag --tone chaotic
```

---

### 🗑 Deinstallation

```bash
# Interaktiv
./install-brag-cursor.sh uninstall

# Alles auf einmal entfernen
./install-brag-cursor.sh uninstall --both --purge
```

> Node.js, FFmpeg, Homebrew und uv werden **niemals** entfernt.

</details>

---

<details open>
<summary><h2>🇬🇧 English</h2></summary>

### 🎬 What is /brag?

[/brag](https://github.com/latent-spaces/brag) is an AI skill (in [SKILL.md format](https://agentskills.io)) for Cursor and other AI coding assistants. It reads your project, plans a storyboard, generates a video composition using [Hyperframes](https://github.com/heygen-com/hyperframes), and renders the result to `brag-output/brag.mp4` — fully autonomously, no video editor needed.

This repository provides a macOS installer that wires everything up natively inside **Cursor**.

---

### 🤖 What does the script do automatically?

Almost everything — you barely need to lift a finger:

| # | Step | What happens | Status |
|:-:|------|-------------|:------:|
| 01 | Xcode Command Line Tools | Checks if present, launches installer if needed | ⚠️ Dialog |
| 02 | Homebrew | Installed automatically if missing | ✅ Auto |
| 03 | Node.js 22+ | Installed via Homebrew if outdated | ✅ Auto |
| 04 | FFmpeg | Installed via Homebrew if missing | ✅ Auto |
| 05 | git | Verified (ships with Xcode CLT) | ✅ Auto |
| 06 | Cursor.app | Checked (warning if not in /Applications) | ✅ Auto |
| 07 | Clone /brag skill | From `latent-spaces/brag` (shallow clone) | ✅ Auto |
| 08 | Hyperframes skills | `npx hyperframes skills update` globally | ✅ Auto |
| 09 | Mirror to ~/.cursor/skills | Makes Hyperframes available to Cursor | ✅ Auto |
| 10 | Deploy /brag | Into your project and/or globally | ✅ Auto |
| 11 | Fallback rule | `.cursor/rules/brag.mdc` (for Cursor < 2.4) | ✅ Auto |
| 12 | Headless Chrome | `npx hyperframes browser ensure` | ✅ Auto |
| 13 | Environment check | `npx hyperframes doctor` | ✅ Auto |
| 14 | uv | Optional: asks you (beat detection for custom music) | 💬 Prompt |
| 15 | HeyGen API key | Optional: asks you (AI presenter overlays) | 💬 Prompt |

---

### 🖐 What do you need to do manually?

Very little! Only these things require your input:

| Step | When | Action |
|------|------|--------|
| Xcode CLT dialog | Only if CLT is missing | Confirm dialog, then re-run the script |
| Choose install location | Always (interactive) | 1 = Project / 2 = Global / 3 = Both (recommended) |
| Project path | If project chosen | Press Enter for current folder |
| Install uv? | Optional | y/n prompt |
| HeyGen API key | Optional | Paste key or press Enter to skip |
| **Restart Cursor** | After installation | So new skills are discovered |
| **Type /brag** | In Cursor | In the agent panel |

---

### 📋 Step by Step

```
┌──────────────────────────────────────────────────────────────────────┐
│  INSTALLATION                                                         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  STEP 1   Download & Start                                           │
│                                                                      │
│  curl -fsSL https://raw.githubusercontent.com/clezcoding/            │
│    brag-cursor-installer/main/install-brag-cursor.sh \               │
│    -o /tmp/install-brag.sh && chmod +x /tmp/install-brag.sh \        │
│    && /tmp/install-brag.sh                                           │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  STEP 2   Choose mode: install                                       │
│                                                                      │
│  STEP 3   Choose install location                                    │
│           → Option 3: Both (Project + Global)  ← recommended        │
│           → Press Enter for current folder                           │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  STEP 4   Wait — 15 steps run automatically:                         │
│                                                                      │
│  [01] Xcode CLT        [06] Cursor.app       [11] Fallback rule      │
│  [02] Homebrew         [07] Clone /brag       [12] Headless Chrome   │
│  [03] Node.js 22+      [08] Hyperframes       [13] Doctor check      │
│  [04] FFmpeg           [09] Mirror skills     [14] uv (optional)     │
│  [05] git              [10] Deploy /brag      [15] HeyGen (optional) │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  STEP 5   Restart Cursor                                             │
│                                                                      │
│  STEP 6   Open project in Cursor → agent panel → type /brag          │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

### 🎛 All Options

```bash
./install-brag-cursor.sh                             # interactive (recommended)
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
2. Open your project folder in Cursor
3. In the **agent panel**, type:

```
/brag
```

4. Optionally choose a tone:

| Tone | Vibe | Best for |
|------|------|----------|
| `default` | Clean, professional | Startup pitch |
| `polished` | Sleek and refined | Enterprise |
| `yc-parody` | Demo Day energy | YC presentation |
| `chaotic` | Maximum vibes | Hacker energy |
| `deadpan` | Dry, minimal | Dev tool |
| `cinematic` | Epic wide-shot feel | Open source |
| `app-store` | App Store preview style | Mobile app |

```bash
/brag --tone cinematic
/brag --tone chaotic
```

---

### 🗑 Uninstall

```bash
# Interactive (asks for confirmation)
./install-brag-cursor.sh uninstall

# Remove everything at once
./install-brag-cursor.sh uninstall --both --purge
```

> Node.js, FFmpeg, Homebrew, and uv are **never** removed during uninstall.

</details>

---

## 🔧 Troubleshooting · Fehlerbehebung

<details>
<summary><b>🔴 Cursor reagiert nicht auf /brag · Cursor doesn't respond to /brag</b></summary>

- Cursor ≥ 2.4 ist erforderlich für natives Skill-Discovery  
  *Cursor ≥ 2.4 required for native skill discovery*
- Für ältere Versionen: `.cursor/rules/brag.mdc` reagiert automatisch auf Keywords wie *"make a launch video"*  
  *For older versions: `.cursor/rules/brag.mdc` triggers automatically on keywords like "make a launch video"*
- **Cursor nach der Installation neu starten! · Restart Cursor after installation!**

</details>

<details>
<summary><b>🔴 hyperframes doctor meldet Probleme · hyperframes doctor reports issues</b></summary>

```bash
# FFmpeg fehlt · FFmpeg missing
brew install ffmpeg

# Node.js zu alt · Node.js outdated
brew install node@22 && brew link --overwrite --force node@22

# Headless Chrome fehlt · Headless Chrome missing
npx hyperframes browser ensure
```

</details>

<details>
<summary><b>🔴 GitHub Rate Limit bei hyperframes skills update</b></summary>

```bash
gh auth login
# dann nochmal · then retry:
npx hyperframes skills update

# oder · or:
export GITHUB_TOKEN=ghp_...
npx hyperframes skills update
```

</details>

<details>
<summary><b>🔴 Video wird nicht gerendert · Video not rendered</b></summary>

- `brag-output/` auf partielle Ausgaben und `*.log`-Dateien prüfen  
  *Check `brag-output/` for partial output and `*.log` files*
- `npx hyperframes doctor` ausführen · *Run `npx hyperframes doctor`*
- `npx hyperframes browser ensure` erneut ausführen · *Re-run `npx hyperframes browser ensure`*

</details>

---

## 📦 Was wird installiert · What gets installed

```
~/.cursor/skills/                   ← global
  ├── brag/
  │   ├── SKILL.md                  /brag Skill-Definition
  │   └── references/               Audio, Komposition, Ton, Schritt-Guides
  ├── hyperframes/
  ├── hyperframes-creative/
  └── general-video/

<projekt>/.cursor/                  ← projektlokal
  ├── skills/
  │   ├── brag/
  │   └── hyperframes*/
  └── rules/
      └── brag.mdc                  Fallback für Cursor < 2.4
```

---

## 🙏 Credits

| Projekt | Beschreibung |
|---------|-------------|
| [latent-spaces/brag](https://github.com/latent-spaces/brag) | Der /brag Skill · The /brag skill |
| [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | Video-Kompositions-Framework |
| [agentskills.io](https://agentskills.io) | SKILL.md Open Standard |

---

<div align="center">

MIT License &nbsp;·&nbsp; Made with ❤️ for the Cursor community

[⭐ Star latent-spaces/brag](https://github.com/latent-spaces/brag) &nbsp;·&nbsp; [📦 Hyperframes](https://github.com/heygen-com/hyperframes)

</div>
