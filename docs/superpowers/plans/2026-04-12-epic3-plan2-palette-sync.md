# Palette Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement `make sync` — a command that reads `lua/void-space/palettes/default.lua` and propagates all color values to `extras/` terminal configs and `assets/` SVG files.

**Architecture:** A Python script (`scripts/sync_palette.py`) reuses the Lua palette parser from `gen_swatch.py`, renders three external templates for the extras files, regenerates `palette_default.svg` from scratch, and updates `void_space_logo.svg` in-place via an explicit color map. Templates live in `scripts/templates/` with `{{key}}` placeholders that reference semantic palette keys.

**Tech Stack:** Python 3 stdlib only (no new dependencies). Same approach as `gen_swatch.py`.

---

## File Map

| Action | Path |
|--------|------|
| Create | `scripts/sync_palette.py` |
| Create | `scripts/templates/void-space-alacritty.toml.tmpl` |
| Create | `scripts/templates/void-space-terminator.conf.tmpl` |
| Create | `scripts/templates/void-space-tmux.conf.tmpl` |
| Modify | `Makefile` — add `sync` target |
| Updated by script | `extras/void-space-alacritty.toml` |
| Updated by script | `extras/void-space-terminator.conf` |
| Updated by script | `extras/void-space-tmux.conf` |
| Updated by script | `assets/palette_default.svg` |
| Updated by script | `assets/void_space_logo.svg` |

---

## Task 1: Create sync_palette.py scaffold with palette parser

**Files:**
- Create: `scripts/sync_palette.py`

- [ ] **Step 1: Create the script with palette parser**

Create `scripts/sync_palette.py`:

```python
#!/usr/bin/env python3
"""
sync_palette.py - Propagate void-space palette changes to extras/ and assets/.

Usage:
    python3 scripts/sync_palette.py
    make sync

What it does:
    1. Reads lua/void-space/palettes/default.lua
    2. Renders scripts/templates/*.tmpl → extras/
    3. Regenerates assets/palette_default.svg
    4. Updates assets/void_space_logo.svg in-place
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent

# ── Palette parser (same logic as gen_swatch.py) ──────────────────────────────

_HEX_RE = re.compile(r'local\s+(\w+)\s*=\s*"(#[0-9a-fA-F]{6})"')
_EXPORT_RE = re.compile(r"^M\.(\w+)\s*=\s*(\S+)", re.MULTILINE)


def parse_lua_palette(path: Path) -> dict[str, str]:
    """Parse a void-space Lua palette file and return a {key: '#RRGGBB'} dict."""
    text = path.read_text()
    local_vars: dict[str, str] = {
        m.group(1): m.group(2) for m in _HEX_RE.finditer(text)
    }
    colors: dict[str, str] = dict(local_vars)
    for m in _EXPORT_RE.finditer(text):
        key, val = m.group(1), m.group(2)
        if val.startswith('"'):
            hex_val = val.strip('"')
            if re.fullmatch(r"#[0-9a-fA-F]{6}", hex_val):
                colors[key] = hex_val
        elif val in local_vars:
            colors[key] = local_vars[val]
    return colors


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    palette_path = ROOT / "lua" / "void-space" / "palettes" / "default.lua"
    if not palette_path.exists():
        print(f"error: palette file not found: {palette_path}", file=sys.stderr)
        sys.exit(1)

    colors = parse_lua_palette(palette_path)
    print("Syncing palette 'default'...\n")
    print("Done.")


if __name__ == "__main__":
    main()
```

- [ ] **Step 2: Verify the script runs without errors**

```bash
python3 scripts/sync_palette.py
```

Expected output:
```
Syncing palette 'default'...

Done.
```

- [ ] **Step 3: Commit**

```bash
git add scripts/sync_palette.py
git commit -m "feat(sync): add sync_palette.py scaffold with palette parser"
```

---

## Task 2: Create the three extras templates

**Files:**
- Create: `scripts/templates/void-space-alacritty.toml.tmpl`
- Create: `scripts/templates/void-space-terminator.conf.tmpl`
- Create: `scripts/templates/void-space-tmux.conf.tmpl`

The `{{key}}` placeholders reference semantic keys from `palettes/default.lua`.

- [ ] **Step 1: Create the Alacritty template**

Create `scripts/templates/void-space-alacritty.toml.tmpl`:

```toml
# Void Space - Alacritty color scheme
# https://github.com/viniciusfs/void-space.nvim
#
# Usage: import this file in your alacritty.toml:
#   import = ["~/.config/alacritty/themes/void-space-alacritty.toml"]

[colors.primary]
background = "{{bg}}"
foreground = "{{fg}}"

[colors.cursor]
text   = "{{bg}}"
cursor = "{{fg}}"

[colors.vi_mode_cursor]
text   = "{{bg}}"
cursor = "{{blue}}"

[colors.selection]
text       = "{{fg}}"
background = "{{sel}}"

[colors.search.matches]
foreground = "{{bg}}"
background = "{{yellow}}"

[colors.search.focused_match]
foreground = "{{bg}}"
background = "{{bright_yellow}}"

[colors.hints.start]
foreground = "{{bg}}"
background = "{{yellow}}"

[colors.hints.end]
foreground = "{{bg}}"
background = "{{fg_dim}}"

[colors.normal]
black   = "{{bg}}"
red     = "{{red}}"
green   = "{{green}}"
yellow  = "{{yellow}}"
blue    = "{{blue}}"
magenta = "{{purple}}"
cyan    = "{{cyan}}"
white   = "{{sel}}"

[colors.bright]
black   = "{{bg_float}}"
red     = "{{orange}}"
green   = "{{green}}"
yellow  = "{{bright_yellow}}"
blue    = "{{blue}}"
magenta = "{{pink}}"
cyan    = "{{fg_dim}}"
white   = "{{fg}}"
```

- [ ] **Step 2: Create the Terminator template**

Create `scripts/templates/void-space-terminator.conf.tmpl`:

```ini
# Void Space - Terminator color scheme
# https://github.com/viniciusfs/void-space.nvim
#
# Usage: merge the [[void-space]] block into the [profiles] section of
#   ~/.config/terminator/config
# Then set the profile in your layout or via Preferences > Profiles.

[profiles]
  [[void-space]]
    background_color  = "{{bg}}"
    foreground_color  = "{{fg}}"
    cursor_color      = "{{fg}}"
    # 16 terminal colors: normal (0-7) then bright (8-15)
    # black, red, green, yellow, blue, magenta, cyan, white
    palette = "{{bg}}:{{red}}:{{green}}:{{yellow}}:{{blue}}:{{purple}}:{{cyan}}:{{sel}}:{{bg_float}}:{{orange}}:{{green}}:{{bright_yellow}}:{{blue}}:{{pink}}:{{fg_dim}}:{{fg}}"
    use_theme_colors  = False
    use_system_font   = False
    font              = Monospace 11
```

- [ ] **Step 3: Create the tmux template**

Create `scripts/templates/void-space-tmux.conf.tmpl`:

```
# Void Space - tmux color scheme
# https://github.com/viniciusfs/void-space.nvim
#
# Usage: source this file from your tmux.conf:
#   source-file ~/.config/tmux/void-space-tmux.conf

# Status bar
set -g status-style                 "bg={{bg}},fg={{fg}}"
set -g status-left-style            "bg={{blue}},fg={{bg}},bold"
set -g status-right-style           "bg={{bg}},fg={{fg_dim}}"

# Window tabs
set -g window-status-style          "bg={{bg}},fg={{fg_dim}}"
set -g window-status-current-style  "bg={{bg_float}},fg={{fg}},bold"
set -g window-status-activity-style "bg={{bg}},fg={{red}}"
set -g window-status-bell-style     "bg={{bg}},fg={{orange}},bold"

# Pane borders
set -g pane-border-style            "fg={{sel}}"
set -g pane-active-border-style     "fg={{blue}}"

# Command / message line
set -g message-style                "bg={{bg_float}},fg={{fg}}"
set -g message-command-style        "bg={{bg_float}},fg={{yellow}}"

# Copy mode / selection
set -g mode-style                   "bg={{sel}},fg={{fg}}"

# Clock
set -g clock-mode-colour            "{{blue}}"

# 256-colour terminal colors (ANSI 0-15)
# These are picked up by applications running inside tmux.
set -g terminal-overrides           ",*256col*:Tc"

# normal
set -ga terminal-overrides          ",*:colors=256"

# Set TERM so inner applications see full colour support
# (uncomment if you are not setting this in your shell profile)
# set -g default-terminal "tmux-256color"
```

- [ ] **Step 4: Commit**

```bash
git add scripts/templates/
git commit -m "feat(sync): add extras templates with palette placeholders"
```

---

## Task 3: Implement template rendering for extras

**Files:**
- Modify: `scripts/sync_palette.py`

- [ ] **Step 1: Add render_templates() to sync_palette.py**

Add the following function and update `main()` in `scripts/sync_palette.py`:

```python
# ── Template rendering ────────────────────────────────────────────────────────

_PLACEHOLDER_RE = re.compile(r"\{\{(\w+)\}\}")

TEMPLATE_TARGETS = [
    ("void-space-alacritty.toml.tmpl",   ROOT / "extras" / "void-space-alacritty.toml"),
    ("void-space-terminator.conf.tmpl",  ROOT / "extras" / "void-space-terminator.conf"),
    ("void-space-tmux.conf.tmpl",        ROOT / "extras" / "void-space-tmux.conf"),
]


def render_templates(colors: dict[str, str]) -> None:
    """Render each template in scripts/templates/ and write to extras/."""
    tmpl_dir = ROOT / "scripts" / "templates"
    for tmpl_name, dest in TEMPLATE_TARGETS:
        tmpl_path = tmpl_dir / tmpl_name
        text = tmpl_path.read_text()

        # Validate all placeholders resolve before writing anything
        missing = [
            m.group(1)
            for m in _PLACEHOLDER_RE.finditer(text)
            if m.group(1) not in colors
        ]
        if missing:
            print(
                f"error: {tmpl_name} references unknown palette keys: {missing}",
                file=sys.stderr,
            )
            sys.exit(1)

        rendered = _PLACEHOLDER_RE.sub(lambda m: colors[m.group(1)], text)
        dest.write_text(rendered)
        print(f"  {dest.relative_to(ROOT)}  updated")
```

Replace the `main()` function with:

```python
def main() -> None:
    palette_path = ROOT / "lua" / "void-space" / "palettes" / "default.lua"
    if not palette_path.exists():
        print(f"error: palette file not found: {palette_path}", file=sys.stderr)
        sys.exit(1)

    colors = parse_lua_palette(palette_path)
    print("Syncing palette 'default'...\n")

    render_templates(colors)

    print("\nDone.")
```

- [ ] **Step 2: Run the script and verify extras/ changed**

```bash
python3 scripts/sync_palette.py
git diff extras/
```

Expected: diff shows corrected hex values in all three extras files (e.g. `cyan` from `#59abb4` → `#4ab5c4`, `magenta` from `#9e87c5` → `#9b88d0`).

- [ ] **Step 3: Commit**

```bash
git add scripts/sync_palette.py extras/
git commit -m "feat(sync): render extras templates from palette"
```

---

## Task 4: Regenerate palette_default.svg

**Files:**
- Modify: `scripts/sync_palette.py`

The SVG shows accent colors in row 1 and background/foreground stack in row 2, matching the layout of the existing file.

- [ ] **Step 1: Add generate_palette_svg() to sync_palette.py**

Add the function and call it from `main()`:

```python
# ── palette_default.svg generation ───────────────────────────────────────────

def generate_palette_svg(colors: dict[str, str]) -> None:
    """Regenerate assets/palette_default.svg from current palette colors."""
    dest = ROOT / "assets" / "palette_default.svg"

    # Row 1: accent colors (left to right)
    row1_keys = ["red", "orange", "yellow", "bright_yellow", "green", "cyan", "blue", "purple", "pink"]
    # Row 2: background/foreground stack with a visual gap between darks and lights
    row2_keys_left  = ["bg_dark", "bg", "bg_float"]   # x=25, 89, 153
    row2_keys_right = ["sel", "fg_dim", "fg"]          # x=409, 473, 537

    rect_size = 64
    x_start = 25
    y1 = 25   # row 1 top
    y2 = 106  # row 2 top

    def rect(x: int, y: int, color: str) -> str:
        return f'  <rect x="{x}" y="{y}" width="{rect_size}" height="{rect_size}" fill="{color}" />'

    rects = []
    for i, key in enumerate(row1_keys):
        rects.append(rect(x_start + i * rect_size, y1, colors[key]))
    for i, key in enumerate(row2_keys_left):
        rects.append(rect(x_start + i * rect_size, y2, colors[key]))
    for i, key in enumerate(row2_keys_right):
        rects.append(rect(409 + i * rect_size, y2, colors[key]))

    svg = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<svg width="626" height="195" viewBox="0 0 626 195" xmlns="http://www.w3.org/2000/svg">\n'
        f'  <rect width="626" height="195" fill="{colors["bg"]}" />\n'
        + "\n".join(rects)
        + "\n</svg>\n"
    )

    dest.write_text(svg)
    print(f"  {dest.relative_to(ROOT)}  regenerated")
```

Update `main()` to call it:

```python
def main() -> None:
    palette_path = ROOT / "lua" / "void-space" / "palettes" / "default.lua"
    if not palette_path.exists():
        print(f"error: palette file not found: {palette_path}", file=sys.stderr)
        sys.exit(1)

    colors = parse_lua_palette(palette_path)
    print("Syncing palette 'default'...\n")

    render_templates(colors)
    generate_palette_svg(colors)

    print("\nDone.")
```

- [ ] **Step 2: Run and inspect the SVG**

```bash
python3 scripts/sync_palette.py
git diff assets/palette_default.svg
```

Expected: diff shows new clean SVG without Inkscape metadata and with current palette colors.

Open `assets/palette_default.svg` in a browser or SVG viewer to verify the color grid looks correct.

- [ ] **Step 3: Commit**

```bash
git add scripts/sync_palette.py assets/palette_default.svg
git commit -m "feat(sync): regenerate palette_default.svg from palette"
```

---

## Task 5: Update void_space_logo.svg in-place

**Files:**
- Modify: `scripts/sync_palette.py`

The logo contains hex values that have drifted from the palette over time. `LOGO_COLOR_MAP` maps each known hex in the file to its semantic palette key so the script can replace them with current values.

- [ ] **Step 1: Add update_logo_svg() to sync_palette.py**

```python
# ── void_space_logo.svg in-place update ──────────────────────────────────────

# Maps every hex color currently in the logo to its semantic palette key.
# Includes both exact palette matches and values that have drifted over time.
LOGO_COLOR_MAP: dict[str, str] = {
    # Backgrounds
    "#141820": "bg_dark",
    "#1b202a": "bg",            # drifted from bg (#1a1f28)
    "#1a1f28": "bg",
    "#232936": "bg_float",
    "#323c4d": "sel",
    # Foregrounds
    "#51617d": "fg_dim",        # drifted from fg_dim (#5f7090)
    "#5f7090": "fg_dim",
    "#9aa7bd": "fg",            # drifted from fg (#99a7be)
    "#99a7be": "fg",
    # Accent colors
    "#608cc3": "blue",          # drifted from blue (#618bc2)
    "#618bc2": "blue",
    "#618cc2": "blue",          # drifted
    "#9b88d0": "purple",
    "#c47ebd": "pink",          # drifted from pink (#cc7dd0)
    "#c47ec4": "pink",          # drifted
    "#56adb7": "cyan",          # drifted from cyan (#4ab5c4)
    "#5aabb4": "cyan",          # drifted
    "#5aabb5": "cyan",          # drifted
    "#c68b8f": "red",
    "#ba8873": "orange",
    "#8fb98c": "green",
    "#b5a262": "yellow",        # drifted from yellow (#b39b64)
    "#b39c65": "yellow",        # drifted
    "#d5b875": "bright_yellow", # drifted from bright_yellow (#d5ad75)
    "#d5ad76": "bright_yellow", # drifted
    "#d5ae76": "bright_yellow", # drifted
}


def update_logo_svg(colors: dict[str, str]) -> None:
    """Update assets/void_space_logo.svg in-place using LOGO_COLOR_MAP."""
    dest = ROOT / "assets" / "void_space_logo.svg"
    text = dest.read_text()
    replaced = 0

    for old_hex, palette_key in LOGO_COLOR_MAP.items():
        new_hex = colors[palette_key]
        if old_hex.lower() in text.lower():
            # Case-insensitive replacement preserving original case pattern
            count = text.lower().count(old_hex.lower())
            text = re.sub(re.escape(old_hex), new_hex, text, flags=re.IGNORECASE)
            replaced += count
        # else: hex not found in SVG — silently skip (color may have been removed)

    dest.write_text(text)
    print(f"  {dest.relative_to(ROOT)}  updated ({replaced} color(s) replaced)")
```

Update `main()` to call it:

```python
def main() -> None:
    palette_path = ROOT / "lua" / "void-space" / "palettes" / "default.lua"
    if not palette_path.exists():
        print(f"error: palette file not found: {palette_path}", file=sys.stderr)
        sys.exit(1)

    colors = parse_lua_palette(palette_path)
    print("Syncing palette 'default'...\n")

    render_templates(colors)
    generate_palette_svg(colors)
    update_logo_svg(colors)

    print("\nDone.")
```

- [ ] **Step 2: Run and inspect the logo diff**

```bash
python3 scripts/sync_palette.py
git diff assets/void_space_logo.svg
```

Expected: diff shows multiple hex value replacements. The count printed should be > 0.

Open `assets/void_space_logo.svg` in a browser or SVG viewer to verify the logo still looks correct with updated colors.

- [ ] **Step 3: Commit**

```bash
git add scripts/sync_palette.py assets/void_space_logo.svg
git commit -m "feat(sync): update void_space_logo.svg in-place from palette"
```

---

## Task 6: Add make sync target and run full sync

**Files:**
- Modify: `Makefile`

- [ ] **Step 1: Add sync target to Makefile**

In `Makefile`, add after the `swatches` target:

```makefile
.PHONY: sync
sync:
	$(PYTHON) scripts/sync_palette.py
```

The full Makefile should look like:

```makefile
BUSTED ?= busted
PYTHON ?= python3

.PHONY: test
test:
	$(BUSTED) --config-file=.busted

.PHONY: swatches
swatches:
	$(PYTHON) scripts/gen_swatch.py

.PHONY: sync
sync:
	$(PYTHON) scripts/sync_palette.py
```

- [ ] **Step 2: Run make sync end-to-end**

```bash
make sync
```

Expected output:
```
Syncing palette 'default'...

  extras/void-space-alacritty.toml  updated
  extras/void-space-terminator.conf  updated
  extras/void-space-tmux.conf  updated
  assets/palette_default.svg  regenerated
  assets/void_space_logo.svg  updated (N color(s) replaced)

Done.
```

After running twice (second run is idempotent):

```bash
make sync && git diff
```

Expected: no diff on the second run — the script is idempotent.

- [ ] **Step 3: Commit**

```bash
git add Makefile
git commit -m "feat(sync): add make sync target"
```

- [ ] **Step 4: Update ROADMAP.md — mark task 3.2 as done**

In `docs/ROADMAP.md`, change:

```markdown
- [ ] 3.2 Sincronização de alterações na paleta com destinos (`extras/`, `assets/`, logo SVG, docs)
```

to:

```markdown
- [x] 3.2 Sincronização de alterações na paleta com destinos (`extras/`, `assets/`, logo SVG, docs)
```

- [ ] **Step 5: Commit ROADMAP update**

```bash
git add docs/ROADMAP.md
git commit -m "chore(roadmap): mark task 3.2 complete"
```
