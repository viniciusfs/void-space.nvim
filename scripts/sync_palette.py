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
    "#cc7dd0": "pink",          # exact match
    "#56adb7": "cyan",          # drifted from cyan (#4ab5c4)
    "#5aabb4": "cyan",          # drifted
    "#5aabb5": "cyan",          # drifted
    "#4ab5c4": "cyan",          # exact match
    "#c68b8f": "red",
    "#ba8873": "orange",
    "#8fb98c": "green",
    "#b5a262": "yellow",        # drifted from yellow (#b39b64)
    "#b39c65": "yellow",        # drifted
    "#b39b64": "yellow",        # exact match
    "#d5b875": "bright_yellow", # drifted from bright_yellow (#d5ad75)
    "#d5ad76": "bright_yellow", # drifted
    "#d5ad75": "bright_yellow", # exact match
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
            count = text.lower().count(old_hex.lower())
            text = re.sub(re.escape(old_hex), new_hex, text, flags=re.IGNORECASE)
            replaced += count
        else:
            print(f"  warn: {old_hex} not found in logo SVG (may have been removed)")

    dest.write_text(text)
    print(f"  {dest.relative_to(ROOT)}  updated ({replaced} color(s) replaced)")


# ── Main ──────────────────────────────────────────────────────────────────────

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


if __name__ == "__main__":
    main()
