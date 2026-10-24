---
classes: wide
layout: single
author_profile: false
---

## dotfiles

My personal dotfiles primarily for macOS. Managed using [chezmoi](https://www.chezmoi.io). Browse the [rendered files](https://github.com/ronaldsuwandi/dotfiles/tree/rendered).

<figure style="text-align: center;">
  <video autoplay loop muted playsinline controls width="100%">
    <source src="setup.mp4" type="video/mp4">
    Your browser does not support the video tag. <a href="setup.mp4">Download the video</a> instead.
  </video>
  <figcaption style="margin-left: auto; margin-right: auto;">paneru + sketchybar + skhd + yabai in action</figcaption>
</figure>

## paneru + skhd — current

Window management via [paneru](https://github.com/karinushka/paneru), a sliding window manager for macOS — windows slide into column positions rather than classic BSP tiling. Shortcuts via skhd, routed through `paneru send-cmd`.

### skhd keybindings

| Shortcut                                | Action                                               |
|:----------------------------------------|:-----------------------------------------------------|
| `Cmd+Alt+Arrow`                         | Focus window                                         |
| `Cmd+Alt+Ctrl+Left/Right`               | Focus first/last window                              |
| `Cmd+Alt+1–9` / `Cmd+Alt+0`              | Focus nth window (0 = last)                          |
| `Cmd+Alt+Shift+Arrow`                   | Swap window                                          |
| `Cmd+Ctrl+Shift+Left/Right`             | Swap with first/last                                 |
| `Cmd+Alt+Ctrl+Down/Up`                  | Shrink/grow column                                   |
| `Cmd+Alt+Space` / `Cmd+Alt+Shift+Space` | Stack / unstack window                               |
| `Cmd+Alt+Return`                        | Fullwidth window                                     |
| `Cmd+Alt+F`                             | Toggle managed/floating                              |
| `Cmd+Alt+C`                             | Center window                                        |
| `Cmd+Alt+Ctrl+=`                        | Equalize columns widths                              |
| `Cmd+Alt+Ctrl+-`                        | Equalize columns heights                             |
| `Cmd+Alt+U`                             | Focus a floating/managed window (toggle)             |
| `Ctrl+1–0`                              | Switch to space 1–10 (InstantSpaceSwitcher)          |
| `Ctrl+Left/Right`                       | Previous/next space (InstantSpaceSwitcher)           |
| `Ctrl+Shift+1–0`                        | Move window to space 1–10 (yabai)                    |
| `Cmd+Ctrl+Alt+Shift+Left/Up/Right/Down` | Quarter corners: yabai-only, via `yabai_grid.sh`     |
| `Cmd+Ctrl+Alt+Shift+-`                  | Center horizontally: yabai-only, via `yabai_grid.sh` |
| `Cmd+Ctrl+Alt+Shift+\|`                 | Center vertically: yabai-only, via `yabai_grid.sh`   |
| `Cmd+Alt+M`                             | Focus the native menu bar by sending macOS's built-in `Ctrl+F2`, since sketchybar sits on top and covers it |
| `Ctrl+Shift+J` / `Ctrl+Shift+K`         | Input source: hiragana / katakana (via `macism`)     |
| `Ctrl+Shift+;`                          | Input source: ABC (English)                          |

App launchers, print-dialog suppression, and the Total War blacklist are unchanged from the yabai setup below. The floating-window-focus bindings live in `paneru/paneru.toml`'s `[bindings]` table rather than skhd — `send-cmd` has no command for reaching a floating window.

The quarter-corner/center bindings run through `yabai_grid.sh` instead of paneru: Zoom windows are invisible to yabai/paneru, so the script detects Zoom and repositions it via the Accessibility API with its own padding calc; every other app gets the same grid cell via plain `yabai --move`/`--resize`. Corners are 1/3 width × 1/2 height; center-h/center-v center a floating window on that axis.

### paneru rules

New windows are managed automatically (config: `paneru/paneru.toml`). Apps that shouldn't be managed (System Settings, 1Password, IINA, Activity Monitor, DevUtils, Finder info windows, and others) float via `[windows.*]` rules — the same set yabai used to float, just moved over.

---

## sketchybar

[Sketchybar](https://github.com/FelixKratz/SketchyBar) at the top of the screen. Colours are a light blue theme matching the current wallpaper/setup rather than a fixed palette. Labels and icon glyphs (space numbers, window/float indicators) both use the native macOS system font (SF Pro), with symbols sourced via the SF Symbols app (`brew install sf-symbols`, in the Brewfile — must be installed first).

- **Left:** space indicators 1–10
- **Center:** focused app name + icon · floating indicator when the focused window is floating
- **Right:** apps in the current space — paneru's managed windows in order (focused one marked `‹ ›`) · battery % · volume icon · input source · window count · any floating windows (detected via yabai) marked with a floating icon

Side app labels (left/right of the focused one) shrink to 9pt when the notch is active, 10.5pt otherwise (lid closed / external display only) — keeps them legible without running under the notch.

No clock — it was removed so Corner Time can show the time instead. Battery re-renders every 120s (plus on wake/power-source change) and tints red under 20%; volume updates on `volume_change`, and clicking it opens a slider popup.

Since paneru has no per-action hooks of its own, sketchybar stays in sync via a custom `paneru_manage_change` event fired directly from the relevant skhd shortcuts (focus, swap, manage-toggle) — no polling, no background daemon.

The input-source indicator shows `A` (ABC), `あ` (hiragana) or `カ` (katakana) in a rounded box, and clicking it toggles ABC ⇄ hiragana. The skhd input-source bindings (`Ctrl+Shift+J/K/;`) fire a custom `input_change` event for an instant update. The native `Ctrl+Shift+L` shortcut can't fire events, so the item also polls every 3s as a fallback. Mode switching uses [`macism`](https://github.com/laishulu/macism) (in the Brewfile). The Japanese IME's alphanumeric mode is removed on purpose, so English is always plain ABC and backslash never turns into ¥.

Space-focus click/keybind logic (highlight the focused space, set icon colors, switch via InstantSpaceSwitcher's `ISSCli index`) is consolidated in `plugins/focus_space.sh`, called from both the sketchybar space items and skhd's `Ctrl+1–0`.

---

## tmux

Prefix is `Alt+Space` — picked specifically to not clash with vim.

### Shortcuts (no prefix needed)

| Shortcut      | Action                 |
|:--------------|:-----------------------|
| `Shift+Arrow` | Focus pane             |
| `Alt+M`       | Mark pane              |
| `Alt+S`       | Swap with marked       |
| `Alt+.`       | Cycle panes            |
| `Alt+Enter`   | Zoom pane              |
| `Alt+1–9`     | Select window 1–9      |
| `Alt+0`       | Select last window     |
| `Ctrl+K`      | Clear screen + history |
| `Ctrl+Alt+R`  | Reload config          |

Splits (`|` horizontal, `-` vertical) and new windows inherit the current pane's working directory.

Pane borders show the running command and path so you always know what's in each pane at a glance. Active pane is green. Window numbers start at 1 and renumber automatically.

---

## macOS settings — `mise bootstrap`

System settings live in `mise/config.toml` under `[bootstrap.macos]` and are applied by `mise bootstrap`. Each entry patches one key path, so sibling settings are left alone.

- **Dock:** left side, 32px icons magnifying to 46px, no recents, spaces never auto-rearrange
- **Finder:** path + status bar, list view, folders first, all extensions, search current folder, iCloud Desktop & Documents
- **Menu bar:** auto-hidden (sketchybar sits there instead); input menu shown
- **Trackpad:** tap to click, three-finger drag, three-finger swipes off, Notification Center edge swipe off
- **Spotlight:** result sources limited to a fixed app list (App Store, Books, Calendar, Contacts, Google Drive, Mail, Messages, Excel, MoneyWiz, Photos, Podcasts, Safari, Telegram, Tips, WhatsApp, iPhone apps); per-account Google Drive sources are left out since they embed account IDs; clipboard history on, kept for 30 minutes
- **Hot corners:** top-right Mission Control · bottom-right Desktop
- **Misc:** full keyboard navigation; click-wallpaper-to-show-desktop off; 1Password and Activity Monitor pinned to all spaces (Nimble Commander was dropped — pinned everywhere, it fought window focus instead of following it)

### Global shortcuts

| Shortcut                        | Action                                                          |
|:--------------------------------|:----------------------------------------------------------------|
| `Ctrl+F2`                       | Focus menu bar (macOS default — what skhd's `Cmd+Alt+M` sends)  |
| `Ctrl+F3`                       | Focus Dock                                                      |
| `Ctrl+1–0`                      | Switch to desktop 1–10 (native fallback; skhd catches it first) |
| `Ctrl+Space` / `Ctrl+Alt+Space` | Disabled — freed from input-source switching                    |
| `Ctrl+Shift+L`                  | Previous input source (ABC ⇄ last Japanese mode) — native, kept for secure-input fields where skhd can't see keys |

### Photos.app

| Shortcut      | Action                                                                   |
|:--------------|:-------------------------------------------------------------------------|
| `Cmd+T`       | Adjust Date and Time…                                                    |
| `Cmd+Shift+C` | Copy Location (from the selected photo)                                  |
| `Cmd+Shift+A` | Assign Location — pastes the location copied with `Cmd+Shift+C`          |
| `Cmd+Shift+G` | Assign GPS Coordinates — from the clipboard, or typed in manually        |

`Cmd+Shift+A` and `Cmd+Shift+G` trigger my own Apple Shortcuts (*Assign Location to Photos*, *Assign GPS Coordinates to Photos*), synced via iCloud with **Use as Quick Action → Services Menu** enabled — they need to exist on the machine for these keys to do anything.

---

## Claude Code — `.claude/`

`CLAUDE.md` defaults Claude to read-only — no file changes without explicit approval. Common read-only commands (`find`, `grep`, `git log`, etc.) are pre-approved so it doesn't ask for permission constantly.

---

## yabai + skhd — deprecated

> Superseded by paneru (above) for window management. yabai's own tiling and float rules are disabled (commented out in `yabairc`), but yabai is still installed and running — it moves windows between spaces (`Ctrl+Shift+1–0`) and handles floating-window detection for sketchybar, since paneru doesn't track floating/unmanaged windows at all. Space switching itself moved to InstantSpaceSwitcher. `skhd/skhdrc_yabai` still has the keybindings below live, so reverting is just a `.load` swap away.

BSP tiling via [yabai](https://github.com/koekeishiya/yabai), shortcuts via [skhd](https://github.com/koekeishiya/skhd). Works without disabling SIP.

I used to run Aerospace but switched back — I didn't like losing native macOS spaces and the whole "hide windows in the corner" workaround. Yabai with native spaces just feels right, and the instant space switching is the best part.

### skhd keybindings

| Shortcut               | Action                    |
|:-----------------------|:--------------------------|
| `Cmd+Alt+Arrow`        | Focus window              |
| `Cmd+Alt+Shift+Arrow`  | Move (warp) window        |
| `Cmd+Ctrl+Shift+Arrow` | Swap window               |
| `Cmd+Alt+Ctrl+Arrow`   | Resize window             |
| `Cmd+Alt+Space`        | Toggle split direction    |
| `Cmd+Alt+Shift+Space`  | Rotate layout 90°         |
| `Cmd+Alt+Return`       | Toggle fullscreen zoom    |
| `Cmd+Alt+F`            | Toggle float (centered)   |
| `Cmd+Alt+Ctrl+=`       | Balance space             |
| `Cmd+Alt+T`            | Toggle BSP/float layout   |
| `Ctrl+1–0`             | Switch to space 1–10      |
| `Ctrl+Shift+1–0`       | Move window to space 1–10 |

**App launchers:** `Ctrl+Shift+F` Finder · `Ctrl+Shift+S` Safari · `Ctrl+Shift+T` Kitty · `Ctrl+Shift+C` Chrome · `Ctrl+Shift+N` Nimble Commander

A few annoyance fixes too — `Cmd+P` and `Cmd+I` are suppressed in Finder and Safari respectively so I don't accidentally open a print dialog or Mail. Total War is blacklisted so skhd stays out of the way while gaming.

### yabai rules (disabled)

New windows used to open as the second child so the existing window stays put. Apps that shouldn't tile (System Settings, 1Password, IINA, Activity Monitor, DevUtils, Finder info windows) floated with sensible grid positions — these rules now live over in paneru's config instead.
