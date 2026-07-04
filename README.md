<div align="center">

<pre>
 ██████╗ ██████╗  █████╗  ██████╗ 
 ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
 ██████╔╝██████╔╝███████║██║  ███╗
 ██╔══██╗██╔══██╗██╔══██║██║   ██║
 ██████╔╝██║  ██║██║  ██║╚██████╔╝
 ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
</pre>

**Dein Projekt. Ein Launch-Video. Direkt aus Cursor.**  
**Your project. A launch video. Right from Cursor.**

[![macOS 14+](https://img.shields.io/badge/macOS-14%2B-555?logo=apple&labelColor=000)](https://www.apple.com/macos/)
[![Cursor ≥2.4](https://img.shields.io/badge/Cursor-%E2%89%A52.4-7c3aed)](https://cursor.sh)
[![Node.js 22+](https://img.shields.io/badge/Node.js-22%2B-417e38?logo=node.js)](https://nodejs.org)
[![License MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Skill](https://img.shields.io/badge/SKILL.md-agentskills.io-ff6b9d)](https://agentskills.io)

</div>

---

## ⚡ Installation

```bash
curl -fsSL https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh | bash
```

<details>
<summary>Interaktiv herunterladen &amp; ausführen (empfohlen · recommended)</summary>

```bash
curl -O https://raw.githubusercontent.com/clezcoding/brag-cursor-installer/main/install-brag-cursor.sh
chmod +x install-brag-cursor.sh
./install-brag-cursor.sh
```

</details>

---

<details open>
<summary><h2>🇩🇪 Deutsch</h2></summary>

### Was ist /brag?

[/brag](https://github.com/latent-spaces/brag) ist ein KI-Skill im [SKILL.md-Format](https://agentskills.io) für Cursor und andere KI-Coding-Assistenten. Er liest dein Projekt, plant ein Storyboard, erstellt eine Videokomposition mit [Hyperframes](https://github.com/heygen-com/hyperframes) und rendert das fertige Video nach `brag-output/brag.mp4` — vollautomatisch, ohne Videoeditor.

Dieses Repository enthält ein macOS-Installationsskript, das alles für **Cursor** einrichtet.

---

### 🤖 Was macht das Skript automatisch?

Das Skript erledigt **alles** — du musst fast nichts selbst machen:

| # | Schritt | Was passiert | Automatisch? |
|---|---------|-------------|:---:|
| 01 | Xcode Command Line Tools | Prüft ob vorhanden, startet Installer wenn nötig | ⚠️ Dialog |
| 02 | Homebrew | Wird installiert wenn nicht vorhanden | ✅ |
| 03 | Node.js 22+ | Wird über Homebrew installiert wenn veraltet | ✅ |
| 04 | FFmpeg | Wird über Homebrew installiert wenn fehlt | ✅ |
| 05 | git | Wird geprüft (kommt mit Xcode CLT) | ✅ |
| 06 | Cursor.app | Wird geprüft (Warnung wenn nicht in /Applications) | ✅ |
| 07 | /brag Skill klonen | Von `latent-spaces/brag` (shallow clone) | ✅ |
| 08 | Hyperframes Skills | `npx hyperframes skills update` global | ✅ |
| 09 | Skills spiegeln | Hyperframes-Pakete → `~/.cursor/skills` | ✅ |
| 10 | /brag deployen | In Projektordner und/oder global | ✅ |
| 11 | Fallback-Regel | `.cursor/rules/brag.mdc` (für Cursor < 2.4) | ✅ |
| 12 | Headless Chrome | `npx hyperframes browser ensure` | ✅ |
| 13 | Umgebungscheck | `npx hyperframes doctor` | ✅ |
| 14 | uv | Optional: fragt nach (Beat-Sync für eigene Musik) | 💬 Prompt |
| 15 | HeyGen API Key | Optional: fragt nach (KI-Presenter-Overlays) | 💬 Prompt |

---

### 🖐 Was musst du manuell tun?

Sehr wenig! Nur folgende Dinge erfordern deinen Input:

1. **Xcode CLT Dialog bestätigen** — Falls noch nicht installiert: macOS öffnet einen Installations-Dialog. Danach Skript erneut starten.
2. **Installationsort wählen** — Das Skript fragt: nur dieses Projekt / global / beides → Empfehlung: **Beides**
3. **Projektpfad eingeben** — Oder einfach Enter für den aktuellen Ordner.
4. **uv installieren?** — Optionaler Beat-Detektor für eigene Musik. Kannst du skippen.
5. **HeyGen API Key einfügen** — Nur für KI-Presenter-Overlays nötig. Komplett optional.
6. **Cursor neu starten** — Damit die neuen Skills erkannt werden.
7. **In Cursor `/brag` eintippen** — Im Agent-Panel. Das war's!

---

### 📋 Schritt für Schritt

```
┌─ INSTALLATION ──────────────────────────────────────────────────────────┐
│                                                                          │
│  1  Skript herunterladen & starten                                      │
│     curl -O https://raw.githubusercontent.com/clezcoding/               │
│              brag-cursor-installer/main/install-brag-cursor.sh           │
│     chmod +x install-brag-cursor.sh                                     │
│     ./install-brag-cursor.sh                                            │
│                                                                          │
│  2  Modus wählen → "install" (oder Enter)                               │
│                                                                          │
│  3  Installationsort wählen                                             │
│     → Option 3: Beides (Projekt + global)  ← empfohlen                 │
│     → Projektpfad eingeben oder Enter (= aktueller Ordner)              │
│                                                                          │
│  4  Warten — Skript installiert 15 Schritte automatisch:               │
│     [01/15] Xcode CLT         [09/15] Skills spiegeln                   │
│     [02/15] Homebrew          [10/15] /brag deployen                    │
│     [03/15] Node.js 22+       [11/15] Fallback-Regel                    │
│     [04/15] FFmpeg            [12/15] Headless Chrome                   │
│     [05/15] git               [13/15] Umgebungscheck                    │
│     [06/15] Cursor.app        [14/15] uv (optional)                     │
│     [07/15] /brag klonen      [15/15] HeyGen Key (optional)             │
│     [08/15] Hyperframes                                                  │
│                                                                          │
│  5  Cursor neu starten                                                   │
│                                                                          │
│  6  Projekt in Cursor öffnen → Agent-Panel → /brag                      │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

### 🎛 Alle Optionen

```bash
./install-brag-cursor.sh                             # interaktiv
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

Nach der Installation:

1. **Cursor neu starten**
2. Projekt öffnen
3. Im Agent-Panel eingeben: `/brag`
4. Optional: Ton wählen mit `--tone`

| Ton | Stimmung |
|-----|----------|
| `default` | Sauber, professionell |
| `polished` | Elegant und verfeinert |
| `yc-parody` | Demo-Day-Energie |
| `chaotic` | Maximum Vibes |
| `deadpan` | Trocken, minimalistisch |
| `cinematic` | Episches Kinoformat |
| `app-store` | App Store Preview Stil |

```
/brag
/brag --tone cinematic
/brag --tone chaotic
```

---

### 🗑 Deinstallation

```bash
# Interaktiv (fragt nach)
./install-brag-cursor.sh uninstall

# Alles auf einmal — kein Nachfragen
./install-brag-cursor.sh uninstall --both --purge
```

> Node.js, FFmpeg, Homebrew und uv werden **niemals** durch die Deinstallation entfernt — die gehören dir.

</details>

---

<details open>
<summary><h2>🇬🇧 English</h2></summary>

### What is /brag?

[/brag](https://github.com/latent-spaces/brag) is an AI skill (in [SKILL.md format](https://agentskills.io)) for Cursor and other AI coding assistants. It reads your project, plans a storyboard, generates a video composition using [Hyperframes](https://github.com/heygen-com/hyperframes), and renders the result to `brag-output/brag.mp4` — fully autonomously, no video editor needed.

This repository provides a macOS installer that wires everything up natively inside **Cursor**.

---

### 🤖 What does the script do automatically?

Almost everything — you barely need to lift a finger:

| # | Step | What happens | Automatic? |
|---|------|-------------|:---:|
| 01 | Xcode Command Line Tools | Checks if present, launches installer if needed | ⚠️ Dialog |
| 02 | Homebrew | Installed automatically if missing | ✅ |
| 03 | Node.js 22+ | Installed via Homebrew if outdated | ✅ |
| 04 | FFmpeg | Installed via Homebrew if missing | ✅ |
| 05 | git | Verified (ships with Xcode CLT) | ✅ |
| 06 | Cursor.app | Checked (warning if not in /Applications) | ✅ |
| 07 | Clone /brag skill | From `latent-spaces/brag` (shallow clone) | ✅ |
| 08 | Hyperframes skills | `npx hyperframes skills update` globally | ✅ |
| 09 | Mirror to ~/.cursor/skills | Makes Hyperframes packages available to Cursor | ✅ |
| 10 | Deploy /brag | Into your project and/or globally | ✅ |
| 11 | Fallback rule | `.cursor/rules/brag.mdc` (for Cursor < 2.4) | ✅ |
| 12 | Headless Chrome | `npx hyperframes browser ensure` | ✅ |
| 13 | Environment check | `npx hyperframes doctor` | ✅ |
| 14 | uv | Optional: asks you (beat detection for custom music) | 💬 Prompt |
| 15 | HeyGen API key | Optional: asks you (AI presenter overlays) | 💬 Prompt |

---

### 🖐 What do you need to do manually?

Very little! Only these things require your input:

1. **Confirm the Xcode CLT dialog** — If not already installed, macOS will show an installation dialog. Then re-run the script.
2. **Choose install location** — The script asks: this project only / global / both → Recommended: **Both**
3. **Enter the project path** — Or just press Enter for the current folder.
4. **Install uv?** — Optional beat detector for custom music tracks. You can skip.
5. **Paste HeyGen API key** — Only needed for AI presenter overlays. Completely optional.
6. **Restart Cursor** — So it picks up the new skills.
7. **Type `/brag` in Cursor** — In the agent panel. That's it!

---

### 📋 Step by Step

```
┌─ INSTALLATION ──────────────────────────────────────────────────────────┐
│                                                                          │
│  1  Download & run the script                                           │
│     curl -O https://raw.githubusercontent.com/clezcoding/               │
│              brag-cursor-installer/main/install-brag-cursor.sh           │
│     chmod +x install-brag-cursor.sh                                     │
│     ./install-brag-cursor.sh                                            │
│                                                                          │
│  2  Choose mode → "install" (or press Enter)                            │
│                                                                          │
│  3  Choose install location                                             │
│     → Option 3: Both (project + global)  ← recommended                 │
│     → Enter project path or press Enter (= current folder)              │
│                                                                          │
│  4  Wait — script handles 15 steps automatically:                       │
│     [01/15] Xcode CLT         [09/15] Mirror skills                     │
│     [02/15] Homebrew          [10/15] Deploy /brag                      │
│     [03/15] Node.js 22+       [11/15] Write fallback rule               │
│     [04/15] FFmpeg            [12/15] Headless Chrome                   │
│     [05/15] git               [13/15] Environment check                 │
│     [06/15] Cursor.app        [14/15] uv (optional)                     │
│     [07/15] Clone /brag       [15/15] HeyGen key (optional)             │
│     [08/15] Hyperframes                                                  │
│                                                                          │
│  5  Restart Cursor                                                       │
│                                                                          │
│  6  Open your project in Cursor → agent panel → /brag                   │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

### 🎛 All Options

```bash
./install-brag-cursor.sh                             # interactive
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

After installation:

1. **Restart Cursor**
2. Open your project
3. In the agent panel, type: `/brag`
4. Optionally choose a tone with `--tone`

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
/brag
/brag --tone cinematic
/brag --tone chaotic
```

---

### 🗑 Uninstall

```bash
# Interactive (asks for confirmation)
./install-brag-cursor.sh uninstall

# Remove everything at once — no prompts
./install-brag-cursor.sh uninstall --both --purge
```

> Node.js, FFmpeg, Homebrew, and uv are **never** removed during uninstall — those are yours to manage.

</details>

---

## 🔧 Troubleshooting · Fehlerbehebung

<details>
<summary><b>Cursor reagiert nicht auf /brag &nbsp;·&nbsp; Cursor doesn't respond to /brag</b></summary>

- Cursor ≥ 2.4 ist erforderlich für natives Skill-Discovery
- Für ältere Versionen: `.cursor/rules/brag.mdc` reagiert auf Keywords wie *"let's brag"* oder *"make a launch video"*
- **Cursor nach der Installation neu starten!**

---

- Cursor ≥ 2.4 is required for native skill discovery
- For older versions: `.cursor/rules/brag.mdc` triggers on keywords like *"let's brag"* or *"make a launch video"*
- **Restart Cursor after installation!**

</details>

<details>
<summary><b>hyperframes doctor meldet Probleme &nbsp;·&nbsp; hyperframes doctor reports issues</b></summary>

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
<summary><b>GitHub Rate Limit bei hyperframes skills update</b></summary>

```bash
gh auth login
# dann nochmal versuchen · then retry
npx hyperframes skills update

# oder · or:
export GITHUB_TOKEN=ghp_...
npx hyperframes skills update
```

</details>

<details>
<summary><b>Video wird nicht gerendert &nbsp;·&nbsp; Video not rendered</b></summary>

- `brag-output/` auf partielle Ausgaben und `*.log`-Dateien prüfen  
  Check `brag-output/` for partial output and `*.log` files
- `npx hyperframes doctor` ausführen · Run `npx hyperframes doctor`
- Headless Chrome sicherstellen · Ensure headless Chrome: `npx hyperframes browser ensure`

</details>

---

## 📦 Was wird installiert · What gets installed

```
~/.cursor/skills/                   global (alle Cursor-Projekte · all Cursor projects)
  ├── brag/
  │   ├── SKILL.md                  /brag Skill-Definition
  │   └── references/               Audio, Komposition, Ton, Schritt-Guides
  ├── hyperframes/                  Video-Kompositions-Framework
  ├── hyperframes-creative/         Audio-reaktive Templates + Beat-Sync
  └── general-video/                Fallback Video-Workflow

<projekt>/.cursor/
  ├── skills/                       projektlokal (selbst-enthalten, portierbar)
  │   ├── brag/                     Kopie des Skills
  │   └── hyperframes*/             Kopie der HF-Pakete
  └── rules/
      └── brag.mdc                  Kompatibilitäts-Fallback für Cursor < 2.4
```

---

## 🙏 Credits

| Projekt | Beschreibung |
|---------|-------------|
| [latent-spaces/brag](https://github.com/latent-spaces/brag) | Der /brag Skill selbst · The /brag skill itself |
| [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | Video-Kompositions-Framework · Video composition framework |
| [agentskills.io](https://agentskills.io) | SKILL.md Open Standard für KI-Agent-Skills |

---

<div align="center">

MIT License &nbsp;·&nbsp; Made with ❤️ for the Cursor community

[⭐ Star latent-spaces/brag](https://github.com/latent-spaces/brag) &nbsp;·&nbsp; [📦 Hyperframes](https://github.com/heygen-com/hyperframes)

</div>
