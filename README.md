# NixOS & Darwin Flake Konfiguration

Eine modulare, deklarative Multi-Plattform-Systemkonfiguration für **NixOS (Linux)** und **nix-darwin (macOS)**, basierend auf Nix Flakes, Home-Manager, Disko, sops-nix, Lanzaboote Secure Boot und Hyprland.

*Inspiriert von [EmergentMind/nix-config](https://github.com/EmergentMind/nix-config).*

---

## Inhaltsverzeichnis
1. [Übersicht & Architektur](#1-übersicht--architektur)
   - [Dateistruktur](#11-dateistruktur)
   - [Flake-Architektur & Outputs](#12-flake-architektur--outputs)
   - [Dynamisches Modul-Ladesystem](#13-dynamisches-modul-ladesystem)
   - [Typsystem (hostSpec & userSpec)](#14-typsystem-hostspec--userspec)
2. [Hosts & Profile](#2-hosts--profile)
   - [Host-Übersicht](#21-host-übersicht)
   - [Profil-Architektur](#22-profil-architektur)
3. [Sicherheit, Verschlüsselung & Secrets](#3-sicherheit-verschlüsselung--secrets)
   - [Secrets-Management (sops-nix & age)](#31-secrets-management-sops-nix--age)
   - [Festplattenverschlüsselung (LUKS + BTRFS + TPM2)](#32-festplattenverschlüsselung-luks--btrfs--tpm2)
   - [Secure Boot (Lanzaboote & sbctl)](#33-secure-boot-lanzaboote--sbctl)
   - [Authentifizierung (YubiKey, PAM & Fingerprint)](#34-authentifizierung-yubikey-pam--fingerprint)
4. [Desktop-Umgebung & UI (Hyprland, SDDM, Noctalia, Vicinae)](#4-desktop-umgebung--ui)
   - [Display Manager (SilentSDDM)](#41-display-manager-silentsddm)
   - [Hyprland & Lua-Konfiguration](#42-hyprland--lua-konfiguration)
   - [Noctalia Shell & Vicinae Launcher](#43-noctalia-shell--vicinae-launcher)
   - [Vollständige Tastenkombinationen (Keybindings)](#44-vollständige-tastenkombinationen-keybindings)
5. [Entwicklungsumgebung, Software & Dienste](#5-entwicklungsumgebung-software--dienste)
   - [Shell (Fish + Starship + Direnv)](#51-shell-fish--starship--direnv)
   - [Programmiersprachen & Toolchains](#52-programmiersprachen--toolchains)
   - [Editoren & IDEs](#53-editoren--ides)
   - [Gaming & Multimedia](#54-gaming--multimedia)
   - [System- & Netzwerkdienste](#55-system---netzwerkdienste)
6. [Nutzungsanleitung & Befehlsreferenz (justfile)](#6-nutzungsanleitung--befehlsreferenz-justfile)
   - [System Rebuild & Update](#61-system-rebuild--update)
   - [Flake-Validierung & Diagnose](#62-flake-validierung--diagnose)
   - [Secrets-Verwaltung & Rekeying](#63-secrets-verwaltung--rekeying)
   - [ISO-Erstellung & Disko](#64-iso-erstellung--disko)
   - [Remote-Verwaltung](#65-remote-verwaltung)
7. [Installation & Bootstrap-Anleitung](#7-installation--bootstrap-anleitung)
   - [Automatisierte Remote-Installation (bootstrap-nixos.sh)](#71-automatisierte-remote-installation-bootstrap-nixossh)
   - [Manuelle Installation via ISO](#72-manuelle-installation-via-iso)
   - [macOS / Darwin Bootstrap](#73-macos--darwin-bootstrap)
8. [Fehlerbehebung (Troubleshooting)](#8-fehlerbehebung-troubleshooting)

---

## 1. Übersicht & Architektur

### 1.1 Dateistruktur

```
.
├── flake.nix                  # Flake-Haupteinstiegspunkt & Output-Definitionen
├── flake.lock                 # Fixierte Abhängigkeits-Revisionen
├── justfile                   # Task-Runner für Builds, Updates & Deployment
├── spec.nix / hosts/spec.nix  # Deklaration von hostSpec- und userSpec-Optionen
├── assets/                    # Konfigurationsdateien, Icons, Themes, Lua-Skripte
│   ├── hyprland/              # Hyprland Lua-Konfigurationen (Keybinds, Style, IO)
│   ├── images/                # Profilbilder und Grafiken
│   ├── other/                 # App-spezifische Configs (Zed, GPU Screen Recorder)
│   ├── shells/                # Noctalia- und DMS-Einstellungen
│   └── vicinae.json           # Vicinae Launcher Konfiguration
├── hosts/
│   ├── disks/                 # Disko-Festplattenlayouts (BTRFS + LUKS)
│   ├── linux/                 # NixOS Host-Definitionen (home, laptop, iso)
│   ├── mac/                   # Darwin Host-Definitionen (work)
│   ├── profiles/              # Modulgruppen (general, system, services, apps, home)
│   └── users/                 # Home-Manager Benutzerprofile (profidev, buergerb, root)
├── keys/                      # Öffentliche SSH-Schlüssel für Systemzugriff
├── lib/                       # Eigene Hilfsfunktionen (scanPaths, toTOML, relativeToRoot)
├── modules/                   # Alle System- und Home-Manager-Module
│   ├── default.nix            # Automatischer Modul-Loader
│   ├── apps/                  # Anwendungs-Paketsets (coding, creative, gaming, tools)
│   ├── home/                  # Home-Manager Module (cli, coding, gui, hyprland, tools)
│   ├── services/              # Systemdienste (core, gui, media, network, coding)
│   ├── system/                # Systemnahe Module (boot, kernel, sops, locale, font)
│   └── users/                 # Benutzerverwaltung (normal, minimal)
├── nixos-installer/           # Minimales Flake für Bootstrap & Neuinstallation
└── scripts/                   # Automatisierungs-Skripte (Rebuild, Bootstrap, SOPS-Checks)
```

---

### 1.2 Flake-Architektur & Outputs

In `flake.nix` werden zentrale Substituter (Caches) sowie alle Abhängigkeiten definiert:
- **Binary Caches**:
  - `https://nix-community.cachix.org`
  - `https://projects.cache.profidev.io`
  - Lokaler Cache (`http://192.168.178.22:80`)
- **Kern-Inputs**:
  - `nixpkgs` (NixOS 25.05) & `nixpkgs-unstable`
  - `home-manager`
  - `disko` (Deklarative Festplattenformatierung)
  - `lanzaboote` (UEFI Secure Boot)
  - `sops-nix` (Verschlüsselte Geheimnisse)
  - `nix-darwin` (macOS Integration)
  - `custom-nixpkgs`, `proton`, `positron`, `hibernation`, `silentSDDM`, `nix-citizen`
- **Outputs**:
  - `modules`: Automatischer Export aller Module unter `modules/`.
  - `nixosConfigurations`: Generiert automatisch Einträge für jedes Verzeichnis in `hosts/linux/` (z. B. `home`, `laptop`, `iso`).
  - `darwinConfigurations`: Generiert automatisch Einträge für jedes Verzeichnis in `hosts/mac/` (z. B. `work`).

---

### 1.3 Dynamisches Modul-Ladesystem

In `modules/default.nix` durchsucht die Funktion `constructModules` den gesamten `modules/`-Ordner rekursiv. Dadurch stehen alle Module strukturiert über `self.modules` bereit, ohne manuell importiert werden zu müssen:

```nix
# Beispiel für den Zugriff in Host-Konfigurationen:
imports = with self.modules; [
  system.boot
  system.sops
  services.core.audio
  services.gui.hyprland
  apps.coding.lang
];
```

---

### 1.4 Typsystem (`hostSpec` & `userSpec`)

In `hosts/spec.nix` werden standardisierte Typen deklariert:

#### `hostSpec`
- `hostname`: Eindeutiger Hostname des Systems.
- `isMinimal`: Kennzeichnet Minimal-/Rescue-Systeme (z. B. ISO oder Installer).
- `users`: Liste von Benutzerspezifikationen (`userSpec`).
- `configPath`: Pfad zum lokalen Konfigurations-Repository (Standard: `/etc/nixos/nix-config`).
- `hyprlandMonitorConfig`: Host-spezifische Monitor-Konfiguration als Lua-String.
- `hyprlandHiDpiFix`: Boolescher Schalter für automatische Skalierungsanpassungen in XWayland.

#### `userSpec`
- `username`: Name des lokalen Systembenutzers.
- `secrets_user`: Referenzschlüssel für SOPS-Secrets.
- `git_user` & `git_email`: Globale Git-Identität.
- `git_sign_key`: Name des SSH-Schlüssels für Commit-Signaturen.
- `ssh_keys`: Liste der bereitzustellenden SSH-Schlüssel.
- `ssh_config` & `ssh_known_hosts`: SSH-Client-Einstellungen.
- `gpg_pub_key`: Öffentlicher GPG-Schlüssel.
- `use_yubikey`: Aktiviert YubiKey U2F-Authentifizierung.

---

## 2. Hosts & Profile

### 2.1 Host-Übersicht

| Host | Plattform | Einsatzgebiet | Besonderheiten & Hardware |
| :--- | :--- | :--- | :--- |
| **`home`** | NixOS (x86_64-linux) | Haupt-Workstation, Gaming, AI & Media | Nvidia GPU (proprietär / Open-Kernel-Modul), CUDA, Ollama Server, Jellyfin, CoolerControl Lüftersteuerung, Harmonia Nix-Binary-Cache, No-Sleep, Virtualisierung, Gamedev Tools |
| **`laptop`** | NixOS (x86_64-linux) | Mobiles Notebook | Intel Xe iGPU (Hardware-Beschleunigung & VAAPI), TLP Powermanagement mit Ladeschwellen (70–80%), Miracast Streaming, Cloudflare WARP, MControlCenter |
| **`iso`** | NixOS (x86_64-linux) | Rettungs- & Installations-Live-Image | Voll ausgestattetes System, Zstd-Squashfs (Level 3), Root-SSH-Login aktiviert, QEMU Guest Agent, Build-Timestamp im Prompt |
| **`work`** | nix-darwin (macOS) | macOS Arbeitsumgebung | Nix-Darwin, automatischer Homebrew- & Rosetta-Bootstrap, Touch ID Sudo PAM-Integration, Coding- & Terminal-Tools |

---

### 2.2 Profil-Architektur

Die Profile in `hosts/profiles/` fassen Module thematisch zusammen:
- **`general.nix`**: Bindet Standard-Inputs und `modules/users/normal.nix` für automatische Benutzer- und Home-Manager-Generierung ein.
- **`system.nix`**: Bootloader, Firmware, Schriftarten, System-Basis, Kernel, Lokalisierung (Berlin / Deutsch) und SOPS-Verschlüsselung.
- **`services.nix`**: PipeWire Audio, Bluetooth, BTRFS-Scrub, GPG/Keyring, Netzwerk, SSHD, Tailscale, Druckdienste, SDDM, Noctalia Desktop-Shell und Docker.
- **`apps.nix`**: Vollständige Softwareausstattung: CLI-Utilities, GUI-Tools, Media, Proton-Apps, Steam, Minecraft, Grafik-/Videobearbeitung, Programmiersprachen und IDEs.
- **`home.nix`**: Home-Manager-Module für Fish, Fastfetch, Starship, Zoxide, Git (Delta/Signing), Neovim, Zed, Browser, Themes, Hyprland und Vicinae.

---

## 3. Sicherheit, Verschlüsselung & Secrets

```
┌─────────────────────────────────────────────────────────────────┐
│                      Sicherheits-Architektur                    │
├────────────────────────┬────────────────────────────────────────┤
│ Festplatten-Verschl.   │ LUKS + BTRFS + TPM2 Auto-Unlock (PCRs) │
├────────────────────────┼────────────────────────────────────────┤
│ Boot-Sicherheit        │ UEFI Secure Boot (Lanzaboote / sbctl)  │
├────────────────────────┼────────────────────────────────────────┤
│ Secrets-Management     │ sops-nix + age + SSH-Host-Keys         │
├────────────────────────┼────────────────────────────────────────┤
│ Benutzer-Auth (PAM)    │ YubiKey (pam_u2f) + Fingerprint (fprintd)│
├────────────────────────┼────────────────────────────────────────┤
│ Versionskontrolle      │ Git Commit Signing via SSH Keys        │
└────────────────────────┴────────────────────────────────────────┘
```

### 3.1 Secrets-Management (`sops-nix` & `age`)

Das Repository trennt Code und Secrets vollständig. Alle sensiblen Daten liegen im privaten Repository `../nix-secrets`.
- **Host-Schlüssel**: Werden aus dem SSH-Hostschlüssel `/etc/ssh/ssh_host_ed25519_key` mittels `ssh-to-age` abgeleitet.
- **Benutzer-Schlüssel**: Werden als eigenständige Age-Keys unter `~/.config/sops/age/keys.txt` abgelegt.
- **Automatische Verteilung**: In `modules/system/sops.nix` werden Passwörter für Benutzerkonten deklarativ aus `shared.yaml` bezogen (`neededForUsers = true`), private SSH-Schlüssel in `~/.ssh/id_*` platziert und Zugriffsrechte gesetzt.
- **Rekeying**: Das Kommando `just rekey` führt `sops updatekeys -y` auf allen Dateien in `nix-secrets/sops/*.yaml` aus, committet und pusht die Änderungen.

---

### 3.2 Festplattenverschlüsselung (LUKS + BTRFS + TPM2)

In `hosts/disks/btrfs-luks.nix`:
- **Partitionsschema (GPT)**:
  - **ESP**: 512 MB VFAT, gemountet auf `/boot` (Rechte `umask=0077`).
  - **LUKS-Container**: `encrypted-nixos` mit Passwortdatei (`/tmp/disko-password`) während der Installation.
- **BTRFS Subvolumes** (alle mit `compress=zstd`, `noatime`, `space_cache=v2`, `discard=async`):
  - `@root` ➔ Mountpoint `/`
  - `@persist` ➔ Mountpoint `/persist`
  - `@nix` ➔ Mountpoint `/nix`
  - `@swap` ➔ Optionales Swapfile-Subvolume
- **TPM2 Auto-Unlock**: Über `systemd-cryptenroll` wird der LUKS-Container an das TPM2 gebunden:
  - PCR-Messung: `0+2+3+7+15` (Firmware, Konfiguration, Secure Boot State).
  - Optional konfigurierbare PIN-Eingabe.

---

### 3.3 Secure Boot (Lanzaboote & `sbctl`)

In `modules/system/boot.nix`:
- `lanzaboote` ersetzt den Standard-`systemd-boot`.
- PKI-Bundle liegt unter `/var/lib/sbctl`.
- Schlüssel werden bei Bedarf automatisch generiert (`autoGenerateKeys.enable = true`) und im UEFI eingeschrieben (`autoEnrollKeys.enable = true`).
- Plymouth-Boot-Splash für nahtlosen Startvorgang.

---

### 3.4 Authentifizierung (YubiKey, PAM & Fingerprint)

In `modules/services/core/security.nix`:
- **PAM U2F**: Aktiv für `login`, `sddm`, `sudo`, `polkit-1` und SSH-Sudo.
- **Fingerabdruck (`fprintd`)**: Integriert mit `libfprint-2-tod1-goodix` Treiber für biometrische Entsperrung.
- **Home-Assistant Power User (`ha_power`)**: Dedizierter Systembenutzer mit eingeschränkten Sudo-Rechten für Display- und Energiesteuerung (`cosmic-randr`, `wlr-randr`, `wlopm`) ohne Passwortabfrage.

---

## 4. Desktop-Umgebung & UI

### 4.1 Display Manager (SilentSDDM)

In `modules/services/gui/sddm.nix`:
- SDDM läuft als nativer Wayland-Display-Manager mit dem **KWin-Compositor**.
- Minimalistisches schwarzes Design ohne Menüleisten oder Tastaturlayout-Auswahl.
- Benutzer-Avatar eingebunden über `assets/images/profidev.jpeg`.
- Cursor: `Bibata-Modern-Ice` (Größe 24).

---

### 4.2 Hyprland & Lua-Konfiguration

Hyprland wird modular über Lua-Skripte aus `assets/hyprland/` konfiguriert:
- **`config.lua`**: Umgebungsvariablen (`QT_QPA_PLATFORM=wayland`, `ELECTRON_OZONE_PLATFORM_HINT=auto`), Deaktivierung von Splash-Screens, Start von `hyprland-session.target`.
- **`style.lua`**: Fensterdekorationen, Ränder, Schatten, Unschärfe (Blur), Animationen und Tiling-Layouts (Dwindle).
- **`layers.lua`**: Blur- und Layer-Regeln für Panels, Notifications und OSD.
- **`io.lua`**: Touchpad-Gesten, Maus-Empfindlichkeit, Tastaturlayout.
- **`vicinae.lua` & `positron.lua`**: Fensterregeln für Launcher und Werkzeuge.

---

### 4.3 Noctalia Shell & Vicinae Launcher

- **Noctalia Shell** (`modules/services/gui/noctalia-legacy.nix`): Moderne Desktop-Shell mit Statusleiste, Lautstärke-/Helligkeits-OSD, Notification-Center und Session-Management.
- **Vicinae** (`modules/home/hyprland/vicinae.nix`): Leistungsfähiger Spotlight/Raycast-ähnlicher Launcher mit integrierter **Soulver-Berechnungs-Engine** und Extensions:
  - `vicinae-nix`, `vicinae-power-profile`, `vicinae-it-tools`, `vicinae-port-killer`
  - `vicinae-hypr-keybinds` (Tastaturkürzel-Suche)
  - `vicinae-vscode-recents`, `vicinae-zed-recents`, `vicinae-jetbrains-recent-projects`
  - `home-assistant-vicinae-extension`, `spotify-player`, `qr-code`, `can-i-use`, `lucide-icons`
  - Native Messaging Host für Chromium, Brave und Google Chrome.

---

### 4.4 Vollständige Tastenkombinationen (Keybindings)

Alle Tastenkombinationen sind in `assets/hyprland/keybinds.lua` und `assets/hyprland/noctalia.lua` definiert:

#### Anwendungs- & Systemsteuerung
| Tastenkombination | Befehl / Aktion |
| :--- | :--- |
| `Super + Space` oder `Alt + Space` | `vicinae toggle` (App-Launcher öffnen/schließen) |
| `Super + V` | `vicinae deeplink vicinae://launch/clipboard/history` (Zwischenablage) |
| `Super + T` | `alacritty` (Terminal starten) |
| `Super + B` | `brave` (Browser starten) |
| `Super + Q` | Aktives Fenster schließen (`window.close`) |
| `Alt + F` | Floating-Modus für aktives Fenster umschalten |
| `Super + F` | Vollbildmodus umschalten |
| `Super + I` | Tiling-Split-Richtung umschalten (`togglesplit`) |
| `Super + C` | Farbpipette aufrufen (`hyprpicker -a`) |
| `Super + Shift + S` | Bereichs-Screenshot aufnehmen (`noctalia msg screenshot-region`) |
| `Alt + L` | Bildschirm sperren (`noctalia msg session lock`) |
| `Super + W` | Wayscriber Signal auslösen (`pkill -SIGUSR1 wayscriber`) |

#### Fokus & Fensternavigation
| Tastenkombination | Aktion |
| :--- | :--- |
| `Alt + H` / `Alt + Left` | Fokus nach links bewegen |
| `Alt + J` / `Alt + Down` | Fokus nach unten bewegen |
| `Alt + K` / `Alt + Up` | Fokus nach oben bewegen |
| `Alt + L` / `Alt + Right` | Fokus nach rechts bewegen |
| `Super + H` / `Super + Left` | Aktives Fenster nach links verschieben |
| `Super + J` / `Super + Down` | Aktives Fenster nach unten verschieben |
| `Super + K` / `Super + Up` | Aktives Fenster nach oben verschieben |
| `Super + L` / `Super + Right` | Aktives Fenster nach rechts verschieben |

#### Workspaces
| Tastenkombination | Aktion |
| :--- | :--- |
| `Super + 1` bis `Super + 0` | Zu Workspace 1 bis 10 wechseln |
| `Super + Shift + 1` bis `Super + Shift + 0` | Aktives Fenster auf Workspace 1 bis 10 verschieben |
| `Super + Mausrad hoch / runter` | Vorheriger / Nächster Workspace |
| `Super + E` | Spezial-Workspace `magic-e` ein-/ausblenden |
| `Super + Shift + E` | Fenster in Spezial-Workspace `magic-e` verschieben |
| `Super + D` | Spezial-Workspace `magic-d` ein-/ausblenden |
| `Super + Shift + D` | Fenster in Spezial-Workspace `magic-d` verschieben |

#### Multimedia & Funktionstasten (auch bei gesperrtem Bildschirm aktiv)
| Taste | Aktion |
| :--- | :--- |
| `XF86AudioRaiseVolume` / `LowerVolume` | Lautstärke erhöhen / verringern |
| `XF86AudioMute` / `MicMute` | Audio stummschalten / Mikrofon stummschalten |
| `XF86MonBrightnessUp` / `Down` | Bildschirmhelligkeit erhöhen / verringern |
| `XF86AudioPlay` / `Pause` / `Next` / `Prev` | Medienwiedergabe steuern |

#### Maus- & Gestensteuerung
| Eingabe | Aktion |
| :--- | :--- |
| `Super + Linke Maustaste` | Fenster greifen und verschieben |
| `Super + Rechte Maustaste` | Fenstergröße per Maus anpassen |
| `3-Finger Wisch horizontal` | Zwischen Workspaces wechseln |
| `3-Finger Wisch vertikal` | Vollbildmodus umschalten |

---

## 5. Entwicklungsumgebung, Software & Dienste

### 5.1 Shell (Fish + Starship + Direnv)

In `modules/home/cli/fish.nix`:
- **Fastfetch**: Automatische Systemübersicht beim Öffnen interaktiver Terminals.
- **Direnv / Nix-Direnv**: Nahtloses Laden von `shell.nix` / `flake.nix` beim Wechsel in Projektordner.
- **Wichtige Shell-Abkürzungen (Fish Abbreviations)**:
  - `l`: `eza -l -a --icons --group-directories-first`
  - `gco`, `gcob`, `gcm`, `gacm`, `gca`, `gpl`, `gps`: Schnelle Git-Workflows
  - `c`, `cb`, `cr`, `cbr`, `crr`: Schnelle Cargo-Workflows (Rust)
  - `dco`: `docker compose up`
  - `k9s`: `k9s -c ctx` (Kubernetes TUI)
  - `stc`: `sudo systemd-cryptenroll --wipe-slot=tpm2`
  - `ste`: TPM2 mit PCRs und PIN einschreiben
  - `stm`: TPM2 mit PCR-Lock einschreiben
  - `envsource <datei>`: Eigene Fish-Funktion zum Laden von `.env`-Dateien

---

### 5.2 Programmiersprachen & Toolchains

In `modules/apps/coding/lang.nix`:
- **C/C++**: GCC, GnuMake, CMake, Autoconf, Automake, Libtool
- **Rust**: Rustup, Rust-Overlay
- **Go**: Go Toolchain
- **Python**: Python 3.13, `uv` Package-Manager, Imath, Pystring
- **Java**: OpenJDK 25, Gradle
- **Odin & Gleam**: Odin Compiler, Gleam, Erlang/OTP, Rebar3
- **Android**: Android SDK Manager, Android Tools, Scrcpy, VirtualGL
- **Protokolle**: Protocol Buffers (`protobuf`)

---

### 5.3 Editoren & IDEs

- **Zed Editor**: Moderner High-Performance Editor mit angepasster Konfiguration (`assets/other/zed.json`).
- **JetBrains Toolbox**: Verwaltung aller JetBrains-IDEs.
- **Neovim**: Modulares Terminal-Editing.
- **Ghidra**: Reverse-Engineering-Suite mit integriertem GDB-Support.
- **Android Studio**: Android-App-Entwicklungsumgebung.

---

### 5.4 Gaming & Multimedia

- **Steam**:
  - `gamescopeSession` aktiviert
  - Proton-GE (`proton-ge-bin`) & Protontricks
  - GameMode (`programs.gamemode.enable = true`)
  - Kernel-Tuning: `vm.max_map_count = 16777216`
- **Launcher & Gaming**: Heroic Games Launcher, r2modman (Mod Manager), Wine/Winetricks, Minecraft Launcher.
- **Gamedev & 3D**: Godot Engine, UnityHub, RenderDoc, Vulkan Tools & Validation Layers, Blender, Blockbench, Ultimaker Cura (3D-Druck AppImage).
- **Video & Medien**: OBS Studio, Kdenlive, VLC, GPU Screen Recorder UI.

---

### 5.5 System- & Netzwerkdienste

- **Jellyfin**: Hardware-beschleunigter Medienserver mit FFmpeg-Full und HDR10+ Tools.
- **Ollama AI**: Lokaler LLM-Server mit Nvidia CUDA-Beschleunigung (`ollama-cuda`, Port offen im Netzwerk) und ComfyUI Desktop.
- **Harmonia Binary Cache & Nginx**: Lokaler Nix-Binary-Cache auf Port 5001, über Nginx auf Port 80 bereitgestellt und mit privatem Store-Key signiert.
- **Tailscale**: VPN-Mesh-Netzwerk mit automatischer Operator-Zuweisung.
- **Cloudflare WARP**: Sichere DNS- und Tunnel-Verbindung.
- **CoolerControl**: Erweiterte Lüfterkurvensteuerung für Workstations (`nct6775` Kernel-Modul).
- **TLP Powermanagement**: Optimierte Akku-Profile für Laptops mit Ladeschwellen (Start 70%, Stop 80%).

---

## 6. Nutzungsanleitung & Befehlsreferenz (justfile)

Alle regelmäßigen Aufgaben werden über `justfile` ausgeführt.

```bash
# Übersicht aller verfügbaren Befehle anzeigen
just
```

### 6.1 System Rebuild & Update

| Befehl | Beschreibung |
| :--- | :--- |
| `just rebuild` | Führt `rebuild-pre` (Git-Intent, Secrets-Update) aus, baut das System via `scripts/rebuild.sh` neu und prüft SOPS. Bei Erfolg wird ein Git-Tag gesetzt. |
| `just rebuild <HOST>` | Baut gezielt eine bestimmte Host-Konfiguration (z. B. `just rebuild laptop`). |
| `just rebuild-trace` | Baut das System mit `--show-trace` für detaillierte Fehlermeldungen bei Evaluierungsfehlern. |
| `just rebuild-full` | Baut das System neu und führt im Anschluss einen vollständigen `just check` aus. |
| `just update` | Aktualisiert alle Flake-Locks (`nix flake update`). |
| `just rebuild-update` | Aktualisiert die Flake-Locks und baut das System sofort neu. |

---

### 6.2 Flake-Validierung & Diagnose

| Befehl | Beschreibung |
| :--- | :--- |
| `just check` | Führt `nix flake check` für das Haupt-Flake und für `nixos-installer/` aus. |
| `just repl` | Startet eine interaktive Nix-REPL mit geladenem Flake (`builtins.getFlake`). |
| `just diff` | Zeigt das `git diff` des gesamten Repositories ohne die unübersichtliche `flake.lock`. |

---

### 6.3 Secrets-Verwaltung & Rekeying

| Befehl | Beschreibung |
| :--- | :--- |
| `just age-key` | Generiert ein neues Age-Schlüsselpaar über eine temporäre Nix-Shell. |
| `just check-sops` | Überprüft im Systemd-/Launchd-Journal, ob `sops-nix` erfolgreich aktiviert wurde. |
| `just update-nix-secrets` | Zieht den aktuellen Stand von `../nix-secrets` und aktualisiert den Flake-Input. |
| `just sops-update-host-age-key <HOST> <KEY>` | Aktualisiert oder erstellt den Host-Age-Schlüssel-Anker in `.sops.yaml`. |
| `just sops-update-user-age-key <USER> <HOST> <KEY>` | Aktualisiert oder erstellt den User-Age-Schlüssel-Anker in `.sops.yaml`. |
| `just sops-add-creation-rules <USER> <HOST>` | Fügt Erstellungsregeln für `<host>.yaml` und `shared.yaml` in `.sops.yaml` ein. |
| `just rekey` | Führt `sops updatekeys` auf allen Dateien in `nix-secrets/sops/*.yaml` aus, committet und pusht. |

---

### 6.4 ISO-Erstellung & Disko

| Befehl | Beschreibung |
| :--- | :--- |
| `just iso` | Baut das bootfähige ISO-Image (`.#nixosConfigurations.iso...`) und erstellt den Symlink `latest.iso`. |
| `just iso-install <DRIVE>` | Flasht das aktuellste ISO-Image per `dd` direkt auf das angegebene Laufwerk (z. B. `/dev/sdb`). |
| `just disko <DRIVE> <PASSWORT>` | Formatiert das angegebene Laufwerk manuell mit LUKS und BTRFS-Subvolumes. |

---

### 6.5 Remote-Verwaltung

| Befehl | Beschreibung |
| :--- | :--- |
| `just sync <USER> <HOST> <PFAD>` | Überträgt die Konfigurationsdateien per Rsync auf den Zielhost. |
| `just build-host <HOST>` | Führt `nixos-rebuild switch` remote über SSH auf der Zielmaschine aus. |
| `just install-remote <HOST> <USER> <IP> <KEY>` | Startet den automatischen Bootstrap-Prozess via `scripts/bootstrap-nixos.sh`. |

---

## 7. Installation & Bootstrap-Anleitung

### 7.1 Automatisierte Remote-Installation (`bootstrap-nixos.sh`)

Für neue Systeme bietet das Skript `scripts/bootstrap-nixos.sh` eine geführte Remote-Installation via **`nixos-anywhere`**:

```bash
just install-remote <TARGET_HOST> <TARGET_USER> <TARGET_IP> ~/.ssh/id_ed25519
```

**Was das Skript automatisch durchführt**:
1. Generiert ein neues SSH-Host-Schlüsselpaar (`ssh_host_ed25519_key`).
2. Erfragt das LUKS-Passwort und platziert es in `/tmp/disko-password` auf dem Zielsystem.
3. Generiert bei Bedarf eine neue `hardware-configuration.nix` und kopiert sie ins Repository.
4. Führt `nixos-anywhere` mit Partitionierung und Installation des Minimal-Flakes (`nixos-installer`) aus.
5. Konvertiert den neuen SSH-Host-Schlüssel via `ssh-to-age` und trägt ihn in `nix-secrets/.sops.yaml` ein.
6. Generiert den Benutzer-Age-Schlüssel und legt `sops/<hostname>.yaml` an.
7. Führt `just rekey` aus und aktualisiert die Secrets.
8. Synchronisiert die vollständige Konfiguration auf die Zielmaschine und baut das Endsystem.

---

### 7.2 Manuelle Installation via ISO

1. **ISO bauen und flashen**:
   ```bash
   just iso
   just iso-install /dev/sdX
   ```
2. **Vom USB-Stick booten**.
3. **Festplatte formatieren**:
   ```bash
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
     --mode disko hosts/disks/btrfs-luks.nix --arg disk '"/dev/nvme0n1"' --arg password '"MeinPasswort"'
   ```
4. **Hardware-Konfiguration generieren**:
   ```bash
   nixos-generate-config --no-filesystems --root /mnt
   ```
5. **System installieren**:
   ```bash
   sudo nixos-install --flake .#<hostname>
   ```

---

### 7.3 macOS / Darwin Bootstrap

Auf einem frischen macOS-System führt `scripts/rebuild.sh` die erforderlichen Bootstrapping-Schritte automatisch durch:
1. Aktiviert `nix-command` und `flakes` in `~/.config/nix/nix.conf`.
2. Installiert die **Xcode Command Line Tools** (`xcode-select --install`).
3. Installiert **Rosetta 2** für x86_64-Emulation.
4. Installiert **Homebrew** unter `/opt/homebrew`.
5. Baut die Darwin-Konfiguration und aktiviert `darwin-rebuild`.

```bash
just rebuild work
```

---

## 8. Fehlerbehebung (Troubleshooting)

### 8.1 `sops-nix failed to activate`
- **Symptom**: Nach dem Rebuild meldet `scripts/check-sops.sh` einen Fehler.
- **Ursache**: Der Hostschlüssel oder Benutzerschlüssel ist in `nix-secrets/.sops.yaml` nicht hinterlegt oder veraltet.
- **Lösung**:
  1. SSH-Hostkey prüfen: `sudo ls -l /etc/ssh/ssh_host_ed25519_key`
  2. SOPS-Journal prüfen: `journalctl -u sops-nix`
  3. Secrets aktualisieren & neu verschlüsseln:
     ```bash
     just rekey
     just rebuild
     ```

---

### 8.2 TPM2 Auto-Unlock nach Kernel- oder UEFI-Update reparieren
- **Symptom**: System fragt beim Booten nach dem LUKS-Passwort statt automatisch zu entsperren.
- **Ursache**: Geänderte PCR-Werte nach Firmware- oder Kernel-Updates.
- **Lösung** (als Shell-Abkürzungen in Fish verfügbar):
  ```bash
  # 1. Bestehenden TPM2-Slot leeren
  stc  # Entspricht: sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2

  # 2. TPM2 neu binden mit PCRs und PIN
  ste  # Entspricht: sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs="0+2+3+7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000" --tpm2-with-pin=yes /dev/nvme0n1p2
  ```

---

### 8.3 Evaluierungs-Cache umgehen (Fehlerhafte Cached-Builds)
- **Symptom**: Ein behobener Fehler wird weiterhin als Fehler evaluiert.
- **Lösung**:
  ```bash
  sudo nixos-rebuild switch --flake .#home --option eval-cache false --show-trace
  ```

---

### 8.4 Git-Tagging & Build-Verifikation
- Das Rebuild-Skript erstellt bei jedem erfolgreichen Build automatisch einen Git-Tag (z. B. `buildable-nixos-20260910120000`).
- Liegen ungespeicherte Änderungen vor, wird der Tag übersprungen. Vor finalen Produktiv-Builds sollten alle Änderungen mit `git commit` gesichert werden.
