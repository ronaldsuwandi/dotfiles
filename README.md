# dotfiles (macOS)

Rendered dotfiles for macOS, auto-generated from the [main](https://github.com/ronaldsuwandi/dotfiles) branch which uses [chezmoi](https://chezmoi.io) for templating and management. Browse the [rendered files](https://github.com/ronaldsuwandi/dotfiles/tree/rendered).

> Do not edit this branch directly — changes belong on `main`.

---

## yabai + skhd

BSP tiling via [yabai](https://github.com/koekeishiya/yabai), shortcuts via [skhd](https://github.com/koekeishiya/skhd). Works without disabling SIP.

I used to run Aerospace but switched back — I didn't like losing native macOS spaces and the whole "hide windows in the corner" workaround. Yabai with native spaces just feels right, and the instant space switching is the best part.

### skhd keybindings

| Action | Shortcut |
|---|---|
| Focus window | `Cmd+Alt+Arrow` |
| Move (warp) window | `Cmd+Alt+Shift+Arrow` |
| Swap window | `Cmd+Ctrl+Shift+Arrow` |
| Resize window | `Cmd+Alt+Ctrl+Arrow` |
| Toggle split direction | `Cmd+Alt+Space` |
| Rotate layout 90° | `Cmd+Alt+Shift+Space` |
| Toggle fullscreen zoom | `Cmd+Alt+Return` |
| Toggle float (centered) | `Cmd+Alt+F` |
| Balance space | `Cmd+Alt+Ctrl+=` |
| Toggle BSP/float layout | `Cmd+Alt+T` |
| Switch to space 1–10 | `Ctrl+1–0` |
| Move window to space 1–10 | `Ctrl+Shift+1–0` |

**App launchers:** `Ctrl+Shift+F` Finder · `Ctrl+Shift+T` Kitty · `Ctrl+Shift+C` Chrome · `Ctrl+Shift+N` Nimble Commander

A few annoyance fixes too — `Cmd+P` and `Cmd+I` are suppressed in Finder and Safari respectively so I don't accidentally open a print dialog or Mail. Total War is blacklisted so skhd stays out of the way while gaming.

### yabai rules

New windows open as the second child so the existing window stays put. Apps that shouldn't tile (System Settings, 1Password, IINA, Activity Monitor, DevUtils, Finder info windows) float with sensible grid positions.

---

## sketchybar

[Sketchybar](https://github.com/FelixKratz/SketchyBar) at the bottom of the screen, frosted glass, [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) colours.

- **Left:** window count · space indicators 1–10 · layout mode toggle (BSP / float)
- **Center:** focused app name + icon · zoom/float indicator when active
- **Right:** running apps in the current space

The part that makes it feel integrated: sketchybar listens for `yabai_layout_change` and `yabai_zoom_change` events fired directly from skhd shortcuts, so the bar stays in sync with what yabai is actually doing — no polling. Space switching works from both skhd and the bar clicks at the same time.

---

## tmux

Prefix is `Alt+Space` — picked specifically to not clash with vim.

### Shortcuts (no prefix needed)

| Action | Shortcut |
|---|---|
| Focus pane | `Shift+Arrow` |
| Mark pane | `Alt+M` |
| Swap with marked | `Alt+S` |
| Cycle panes | `Alt+.` |
| Zoom pane | `Alt+Enter` |
| Select window 1–9 | `Alt+1–9` |
| Select last window | `Alt+0` |
| Clear screen + history | `Ctrl+K` |
| Reload config | `Ctrl+Alt+R` |

Splits (`|` horizontal, `-` vertical) and new windows inherit the current pane's working directory.

Pane borders show the running command and path so you always know what's in each pane at a glance. Active pane is green. Window numbers start at 1 and renumber automatically.

---

## Claude Code — `.claude/`

`CLAUDE.md` defaults Claude to read-only — no file changes without explicit approval. Common read-only commands (`find`, `grep`, `git log`, etc.) are pre-approved so it doesn't ask for permission constantly.
