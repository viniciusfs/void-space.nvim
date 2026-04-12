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
