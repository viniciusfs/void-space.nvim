#!/usr/bin/env python3
"""
gen_swatch.py - Generate solid-color PNG swatches from Lua palette files.

Usage
-----
    # All palettes
    python3 gen_swatch.py

    # Single palette (all colors)
    python3 gen_swatch.py <palette>

    # Single palette, specific colors
    python3 gen_swatch.py <palette> <color1> [<color2> ...]

Examples
--------
    python3 gen_swatch.py
    python3 gen_swatch.py default
    python3 gen_swatch.py nebula red blue cyan
"""

import re
import struct
import sys
import zlib
from pathlib import Path

# Lua palette parser

_HEX_RE = re.compile(r'local\s+(\w+)\s*=\s*"(#[0-9a-fA-F]{6})"')
_EXPORT_RE = re.compile(r"^M\.(\w+)\s*=\s*(\S+)", re.MULTILINE)


def parse_lua_palette(path: Path) -> dict[str, str]:
    """Parse a void-space Lua palette file and return a {key: "#RRGGBB"} dict."""
    text = path.read_text()

    # Pass 1: local _var = "#hex"  (raw colors, kept with their _ prefix)
    local_vars: dict[str, str] = {
        m.group(1): m.group(2) for m in _HEX_RE.finditer(text)
    }

    # Pass 2: M.key = _var | "#hex"  (semantic exports)
    colors: dict[str, str] = dict(local_vars)  # include raw vars as-is
    for m in _EXPORT_RE.finditer(text):
        key, val = m.group(1), m.group(2)
        if val.startswith('"'):
            # inline literal: M.key = "#RRGGBB"
            hex_val = val.strip('"')
            if re.fullmatch(r"#[0-9a-fA-F]{6}", hex_val):
                colors[key] = hex_val
        elif val in local_vars:
            colors[key] = local_vars[val]
        # else: "NONE" or unresolved ref — skip

    return colors


def discover_palettes(root: Path) -> list[str]:
    """Return palette names (without .lua) found under lua/void-space/palettes/."""
    palette_dir = root / "lua" / "void-space" / "palettes"
    return sorted(p.stem for p in palette_dir.glob("*.lua"))


# PNG helpers


def _png_chunk(tag: bytes, data: bytes) -> bytes:
    """Wrap *data* in a PNG chunk with the given 4-byte *tag*."""
    crc = zlib.crc32(tag + data) & 0xFFFFFFFF
    return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", crc)


def make_swatch(width: int, height: int, r: int, g: int, b: int, a: int = 255) -> bytes:
    """Return the raw bytes of a solid-color RGBA PNG."""
    signature = b"\x89PNG\r\n\x1a\n"
    ihdr = _png_chunk(
        b"IHDR",
        struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0),
    )
    row = b"\x00" + bytes([r, g, b, a]) * width
    idat = _png_chunk(b"IDAT", zlib.compress(row * height, 9))
    iend = _png_chunk(b"IEND", b"")
    return signature + ihdr + idat + iend


# Color parsing


def parse_hex(hex_color: str) -> tuple[int, int, int]:
    """Parse a 6-digit hex color string (with or without '#') into (r, g, b)."""
    h = hex_color.lstrip("#")
    if len(h) != 6:
        raise ValueError(f"Expected a 6-digit hex color, got: '{hex_color}'")
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)


# Main

SWATCH_SIZE = 38  # pixels


def write_swatch(name: str, hex_color: str, out_dir: Path) -> None:
    r, g, b = parse_hex(hex_color)
    png = make_swatch(SWATCH_SIZE, SWATCH_SIZE, r, g, b)
    dest = out_dir / f"{name}.png"
    dest.write_bytes(png)
    print(
        f"  wrote {dest.relative_to(dest.parents[2])}  ({hex_color}, {len(png)} bytes)"
    )


def _run_palette(palette_name: str, root: Path, filter_keys: set[str] | None) -> None:
    lua_path = root / "lua" / "void-space" / "palettes" / f"{palette_name}.lua"
    if not lua_path.exists():
        print(f"error: palette file not found: {lua_path}", file=sys.stderr)
        sys.exit(1)

    colors = parse_lua_palette(lua_path)
    out_dir = root / "assets" / "swatches" / palette_name
    out_dir.mkdir(parents=True, exist_ok=True)

    print(f"Palette '{palette_name}' > {out_dir}/")
    count = 0
    for key, hex_color in sorted(colors.items()):
        if filter_keys is None or key in filter_keys:
            write_swatch(key, hex_color, out_dir)
            count += 1
    print(f"  {count} swatch(es) written.")


def main() -> None:
    root = Path(__file__).parent.parent
    args = sys.argv[1:]

    if not args:
        # No args: generate all discovered palettes
        palettes = discover_palettes(root)
        if not palettes:
            print("error: no palette files found", file=sys.stderr)
            sys.exit(1)
        for name in palettes:
            _run_palette(name, root, filter_keys=None)
        return

    # First arg is the palette name; remaining args are optional color filters
    palette_name = args[0]
    filter_keys = set(args[1:]) if len(args) > 1 else None
    _run_palette(palette_name, root, filter_keys)


if __name__ == "__main__":
    main()
