# dotfiles (macOS)

Rendered dotfiles for macOS, auto-generated from the [main](https://github.com/ronaldsuwandi/dotfiles) branch which uses [chezmoi](https://chezmoi.io) for templating and management. Browse the [rendered files](https://github.com/ronaldsuwandi/dotfiles/tree/rendered).

> Do not edit this branch directly — changes belong on `main`.

---

## paneru + skhd — current

Window management via [paneru](https://github.com/karinushka/paneru), a sliding window manager for macOS — windows slide into column positions rather than classic BSP tiling. Shortcuts via skhd, routed through `paneru send-cmd`.

### skhd keybindings

| Action | Shortcut |
|---|---|
| Focus window | `Cmd+Alt+Arrow` |
| Focus first/last window | `Cmd+Alt+Ctrl+Left/Right` |
| Swap window | `Cmd+Alt+Shift+Arrow` |
| Swap with first/last | `Cmd+Ctrl+Shift+Left/Right` |
| Shrink/grow column | `Cmd+Alt+Ctrl+Down/Up` |
| Stack / unstack window | `Cmd+Alt+Space` / `Cmd+Alt+Shift+Space` |
| Fullwidth window | `Cmd+Alt+Return` |
| Toggle managed/floating | `Cmd+Alt+F` |
| Center window | `Cmd+Alt+C` |
| Equalize columns | `Cmd+Alt+Ctrl+=` |
| Focus a floating window | `Cmd+Alt+U` |
| Focus back to managed | `Cmd+Alt+Shift+U` |
| Switch to space 1–10 (yabai) | `Ctrl+1–0` |
| Move window to space 1–10 (yabai) | `Ctrl+Shift+1–0` |

App launchers, print-dialog suppression, and the Total War blacklist are unchanged from the yabai setup above. The floating-window-focus bindings live in `paneru/paneru.toml`'s `[bindings]` table rather than skhd — `send-cmd` has no command for reaching a floating window.

### paneru rules

New windows are managed automatically (config: `paneru/paneru.toml`). Apps that shouldn't be managed (System Settings, 1Password, IINA, Activity Monitor, DevUtils, Finder info windows, and others) float via `[windows.*]` rules — the same set yabai used to float, just moved over.

---

## sketchybar

[Sketchybar](https://github.com/FelixKratz/SketchyBar) at the bottom of the screen, frosted glass, [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) colours.

- **Left:** window count · space indicators 1–10
- **Center:** focused app name + icon · floating indicator when the focused window is floating
- **Right:** apps in the current space — paneru's managed windows in order (focused one marked `‹ ›`), followed by any floating windows (detected via yabai) marked with a floating icon

Since paneru has no per-action hooks of its own, sketchybar stays in sync via a custom `paneru_manage_change` event fired directly from the relevant skhd shortcuts (focus, swap, manage-toggle) — no polling, no background daemon.

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

---

## yabai + skhd — deprecated

> Superseded by paneru (above) for window management. yabai's own tiling and float rules are disabled (commented out in `yabairc`), but yabai is still installed and running — it's what handles instant space switching (`Ctrl+1–0`) and floating-window detection for sketchybar, since paneru doesn't track floating/unmanaged windows at all. `skhd/skhdrc_yabai` still has the keybindings below live, so reverting is just a `.load` swap away.

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

### yabai rules (disabled)

New windows used to open as the second child so the existing window stays put. Apps that shouldn't tile (System Settings, 1Password, IINA, Activity Monitor, DevUtils, Finder info windows) floated with sensible grid positions — these rules now live over in paneru's config instead.
