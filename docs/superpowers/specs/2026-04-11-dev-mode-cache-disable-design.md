# Design: Dev Mode — Disable Disk Cache

**Date:** 2026-04-11
**Status:** Approved

## Problem

During theme development, modifying highlight files serves stale data because the disk cache is still used on subsequent loads. The `:VoidSpaceClearCache` command solves this but requires manual invocation on every change.

## Goal

Add a `dev` config option that, when `true`, bypasses the disk cache entirely — no reads, no writes — so the theme is always recomputed from scratch on every load.

## Design

### Config

Add `dev` to `VoidSpaceConfig` in `lua/void-space/init.lua`:

```lua
---@field dev boolean  Disable disk cache (for theme development, default: false)
```

Default in `M.config`:

```lua
dev = false,
```

Typical usage in a dev dotfiles:

```lua
require("void-space").setup({ dev = true })
```

### Load logic

Replace the current cache block in `M.load()` with a guard that skips both read and write when `dev = true`:

```lua
local highlights

if not M.config.dev then
    local cached = cache.load(M.config)
    if cached then
        highlights = cached
    end
end

if not highlights then
    local theme = require("void-space.theme")
    highlights = theme.get(palette, M.config)
    if not M.config.dev then
        cache.save(M.config, highlights)
    end
end
```

When `dev = false` (default): behavior is identical to the current implementation.
When `dev = true`: cache is never read or written; theme modules are always required and recomputed.

### Behavior

| `dev` | Reads cache | Writes cache | Theme recomputed |
|-------|-------------|--------------|------------------|
| false | yes         | yes          | only on miss     |
| true  | no          | no           | always           |

### Notification

Silent — no `vim.notify` when dev mode is active.

## Files changed

- `lua/void-space/init.lua` — add `dev` field to type annotation and `M.config`, update `M.load()` logic
- `spec/opts_spec.lua` — add test asserting `dev = true` bypasses cache read and write

## Out of scope

- Environment variable (`VOID_SPACE_DEV`) — not needed per user decision
- `cache.lua` changes — none required; cache remains a pure utility
