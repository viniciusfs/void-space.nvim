# Dev Mode Cache Disable Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `dev = true` config option that bypasses the disk cache entirely (no reads, no writes) so the theme is always recomputed on every load during development.

**Architecture:** Guard both `cache.load()` and `cache.save()` calls in `M.load()` with `if not M.config.dev`. When `dev = false` (default), behavior is identical to today. No changes to `cache.lua`.

**Tech Stack:** Lua 5.1, busted test framework (`make test`)

---

### Task 1: Write failing tests for dev mode

**Files:**
- Modify: `spec/init_spec.lua` (inside the existing `describe("cache integration")` block, after line 215)

- [ ] **Step 1: Add two failing tests to the cache integration block**

Open `spec/init_spec.lua`. Inside `describe("cache integration", function()` (line 168), add these two tests after the existing `"calls cache.save() on cache miss"` test (before the closing `end)`):

```lua
    it("dev=true skips cache.load() and always calls theme.get()", function()
      local cache_load_called = false
      local theme_called = false

      package.loaded["void-space.cache"] = {
        load = function(_) cache_load_called = true; return { Normal = { fg = "#aabbcc" } } end,
        save = function() end,
        clear = function() end,
      }
      local original_theme = package.loaded["void-space.theme"]
      package.loaded["void-space.theme"] = {
        get = function() theme_called = true; return { Normal = { fg = "#ffffff" } } end,
      }

      M.config.dev = true
      hl_calls = {}
      M.load()
      M.config.dev = false

      package.loaded["void-space.theme"] = original_theme
      assert.is_false(cache_load_called, "cache.load() should not be called when dev=true")
      assert.is_true(theme_called, "theme.get() should always be called when dev=true")
    end)

    it("dev=true skips cache.save()", function()
      local save_called = false

      package.loaded["void-space.cache"] = {
        load = function(_) return nil end,
        save = function() save_called = true end,
        clear = function() end,
      }

      M.config.dev = true
      hl_calls = {}
      M.load()
      M.config.dev = false

      assert.is_false(save_called, "cache.save() should not be called when dev=true")
    end)
```

- [ ] **Step 2: Run tests to verify they fail**

```sh
busted --config-file=.busted spec/init_spec.lua
```

Expected: 2 failures mentioning `cache.load() should not be called` and `cache.save() should not be called`.

---

### Task 2: Implement `dev` config option

**Files:**
- Modify: `lua/void-space/init.lua`

- [ ] **Step 1: Add `dev` to the type annotation**

In `lua/void-space/init.lua`, add the `dev` field to the `VoidSpaceConfig` annotation after the `on_highlights` line (line 9):

Old:
```lua
---@field on_highlights    fun(hl: table, c: table)|nil  Override highlights after load
```

New:
```lua
---@field on_highlights    fun(hl: table, c: table)|nil  Override highlights after load
---@field dev              boolean  Disable disk cache for development (default: false)
```

- [ ] **Step 2: Add `dev` default to `M.config`**

In the same file, add `dev = false` to the `M.config` table after `on_highlights = nil`:

Old:
```lua
	on_highlights = nil,
}
```

New:
```lua
	on_highlights = nil,
	dev = false,
}
```

- [ ] **Step 3: Update `M.load()` cache logic**

Replace the cache block in `M.load()` (lines 51–61):

Old:
```lua
	local cache = require("void-space.cache")
	local cached = cache.load(M.config)

	local highlights

	if cached then
		highlights = cached
	else
		local theme = require("void-space.theme")
		highlights = theme.get(palette, M.config)
		cache.save(M.config, highlights)
	end
```

New:
```lua
	local cache = require("void-space.cache")

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

- [ ] **Step 4: Run tests to verify they pass**

```sh
make test
```

Expected: all tests pass, including the two new dev mode tests.

- [ ] **Step 5: Commit**

```sh
git add lua/void-space/init.lua spec/init_spec.lua
git commit -m "feat: add dev=true option to disable disk cache"
```
