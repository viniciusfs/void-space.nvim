# Epic 2 — Plan 1: File Structure Reorganization

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Move the 20 plugin highlight files into `lua/void-space/highlights/plugins/` and update all references, with no behavior change.

**Architecture:** This is a pure mechanical rename — no logic changes. The 5 core modules (`editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`) stay at `lua/void-space/highlights/`. The 19 plugin files + `legacy` move to `lua/void-space/highlights/plugins/`. Four files reference the old paths and must be updated: `lua/void-space/theme.lua`, `spec/highlights_spec.lua`, `spec/theme_spec.lua`, and `spec/opts_spec.lua`.

**Tech Stack:** Lua, Busted (test runner via `make test`)

---

### Task 1: Create directory and move files

**Files:**
- Create: `lua/void-space/highlights/plugins/` (directory)
- Move: 20 files from `lua/void-space/highlights/` to `lua/void-space/highlights/plugins/`

- [x] **Step 1: Create the plugins directory and move all plugin files**

```bash
cd /path/to/void-space.nvim
mkdir -p lua/void-space/highlights/plugins
git mv lua/void-space/highlights/bufferline.lua    lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/cmp.lua           lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/dashboard.lua     lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/fidget.lua        lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/flash.lua         lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/gitsigns.lua      lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/illuminate.lua    lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/indent.lua        lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/lazy.lua          lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/mini.lua          lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/neo_tree.lua      lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/noice.lua         lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/notify.lua        lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/render_markdown.lua lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/snacks.lua        lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/telescope.lua     lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/todo_comments.lua lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/trouble.lua       lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/which_key.lua     lua/void-space/highlights/plugins/
git mv lua/void-space/highlights/legacy.lua        lua/void-space/highlights/plugins/
```

- [x] **Step 2: Verify the moves**

```bash
ls lua/void-space/highlights/
```

Expected output (5 core files only):
```
diagnostics.lua  editor.lua  lsp.lua  plugins/  syntax.lua  treesitter.lua
```

```bash
ls lua/void-space/highlights/plugins/
```

Expected output (20 files):
```
bufferline.lua  cmp.lua  dashboard.lua  fidget.lua  flash.lua  gitsigns.lua
illuminate.lua  indent.lua  lazy.lua  legacy.lua  mini.lua  neo_tree.lua
noice.lua  notify.lua  render_markdown.lua  snacks.lua  telescope.lua
todo_comments.lua  trouble.lua  which_key.lua
```

---

### Task 2: Update `lua/void-space/theme.lua`

**Files:**
- Modify: `lua/void-space/theme.lua`

- [x] **Step 1: Replace the plugins section in theme.lua**

In `lua/void-space/theme.lua`, replace the plugins block (lines 17–37) from:

```lua
	-- Plugins
	"void-space.highlights.bufferline",
	"void-space.highlights.cmp",
	"void-space.highlights.dashboard",
	"void-space.highlights.fidget",
	"void-space.highlights.flash",
	"void-space.highlights.gitsigns",
	"void-space.highlights.illuminate",
	"void-space.highlights.indent",
	"void-space.highlights.lazy",
	"void-space.highlights.mini",
	"void-space.highlights.neo_tree",
	"void-space.highlights.noice",
	"void-space.highlights.notify",
	"void-space.highlights.render_markdown",
	"void-space.highlights.snacks",
	"void-space.highlights.telescope",
	"void-space.highlights.todo_comments",
	"void-space.highlights.trouble",
	"void-space.highlights.which_key",
	-- Legacy syntax groups (CSS, HTML, JS, Ruby, git commit)
	"void-space.highlights.legacy",
```

To:

```lua
	-- Plugins
	"void-space.highlights.plugins.bufferline",
	"void-space.highlights.plugins.cmp",
	"void-space.highlights.plugins.dashboard",
	"void-space.highlights.plugins.fidget",
	"void-space.highlights.plugins.flash",
	"void-space.highlights.plugins.gitsigns",
	"void-space.highlights.plugins.illuminate",
	"void-space.highlights.plugins.indent",
	"void-space.highlights.plugins.lazy",
	"void-space.highlights.plugins.mini",
	"void-space.highlights.plugins.neo_tree",
	"void-space.highlights.plugins.noice",
	"void-space.highlights.plugins.notify",
	"void-space.highlights.plugins.render_markdown",
	"void-space.highlights.plugins.snacks",
	"void-space.highlights.plugins.telescope",
	"void-space.highlights.plugins.todo_comments",
	"void-space.highlights.plugins.trouble",
	"void-space.highlights.plugins.which_key",
	-- Legacy syntax groups (CSS, HTML, JS, Ruby, git commit)
	"void-space.highlights.plugins.legacy",
```

---

### Task 3: Update `spec/highlights_spec.lua`

**Files:**
- Modify: `spec/highlights_spec.lua`

- [x] **Step 1: Replace the plugins entries in the MODULES list**

In `spec/highlights_spec.lua`, replace the 20 plugin entries in the `MODULES` table (lines 9–29) from:

```lua
	"void-space.highlights.bufferline",
	"void-space.highlights.cmp",
	"void-space.highlights.dashboard",
	"void-space.highlights.fidget",
	"void-space.highlights.flash",
	"void-space.highlights.gitsigns",
	"void-space.highlights.illuminate",
	"void-space.highlights.indent",
	"void-space.highlights.lazy",
	"void-space.highlights.mini",
	"void-space.highlights.neo_tree",
	"void-space.highlights.noice",
	"void-space.highlights.notify",
	"void-space.highlights.render_markdown",
	"void-space.highlights.snacks",
	"void-space.highlights.telescope",
	"void-space.highlights.todo_comments",
	"void-space.highlights.trouble",
	"void-space.highlights.which_key",
	"void-space.highlights.legacy",
```

To:

```lua
	"void-space.highlights.plugins.bufferline",
	"void-space.highlights.plugins.cmp",
	"void-space.highlights.plugins.dashboard",
	"void-space.highlights.plugins.fidget",
	"void-space.highlights.plugins.flash",
	"void-space.highlights.plugins.gitsigns",
	"void-space.highlights.plugins.illuminate",
	"void-space.highlights.plugins.indent",
	"void-space.highlights.plugins.lazy",
	"void-space.highlights.plugins.mini",
	"void-space.highlights.plugins.neo_tree",
	"void-space.highlights.plugins.noice",
	"void-space.highlights.plugins.notify",
	"void-space.highlights.plugins.render_markdown",
	"void-space.highlights.plugins.snacks",
	"void-space.highlights.plugins.telescope",
	"void-space.highlights.plugins.todo_comments",
	"void-space.highlights.plugins.trouble",
	"void-space.highlights.plugins.which_key",
	"void-space.highlights.plugins.legacy",
```

---

### Task 4: Update `spec/theme_spec.lua`

**Files:**
- Modify: `spec/theme_spec.lua`

- [x] **Step 1: Replace the plugins entries in the MODULES list**

In `spec/theme_spec.lua`, replace the 20 plugin entries in the `MODULES` table (lines 10–29) from:

```lua
	"void-space.highlights.bufferline",
	"void-space.highlights.cmp",
	"void-space.highlights.dashboard",
	"void-space.highlights.fidget",
	"void-space.highlights.flash",
	"void-space.highlights.gitsigns",
	"void-space.highlights.illuminate",
	"void-space.highlights.indent",
	"void-space.highlights.lazy",
	"void-space.highlights.mini",
	"void-space.highlights.neo_tree",
	"void-space.highlights.noice",
	"void-space.highlights.notify",
	"void-space.highlights.render_markdown",
	"void-space.highlights.snacks",
	"void-space.highlights.telescope",
	"void-space.highlights.todo_comments",
	"void-space.highlights.trouble",
	"void-space.highlights.which_key",
	"void-space.highlights.legacy",
```

To:

```lua
	"void-space.highlights.plugins.bufferline",
	"void-space.highlights.plugins.cmp",
	"void-space.highlights.plugins.dashboard",
	"void-space.highlights.plugins.fidget",
	"void-space.highlights.plugins.flash",
	"void-space.highlights.plugins.gitsigns",
	"void-space.highlights.plugins.illuminate",
	"void-space.highlights.plugins.indent",
	"void-space.highlights.plugins.lazy",
	"void-space.highlights.plugins.mini",
	"void-space.highlights.plugins.neo_tree",
	"void-space.highlights.plugins.noice",
	"void-space.highlights.plugins.notify",
	"void-space.highlights.plugins.render_markdown",
	"void-space.highlights.plugins.snacks",
	"void-space.highlights.plugins.telescope",
	"void-space.highlights.plugins.todo_comments",
	"void-space.highlights.plugins.trouble",
	"void-space.highlights.plugins.which_key",
	"void-space.highlights.plugins.legacy",
```

---

### Task 5: Update `spec/opts_spec.lua`

**Files:**
- Modify: `spec/opts_spec.lua`

Note: only the 4 plugin module paths change here. The core module paths (`syntax`, `treesitter`, `editor`) stay unchanged.

- [x] **Step 1: Update the 4 plugin requires in opts_spec.lua**

Make these 4 replacements:

| Old path | New path |
|----------|----------|
| `"void-space.highlights.legacy"` | `"void-space.highlights.plugins.legacy"` |
| `"void-space.highlights.snacks"` | `"void-space.highlights.plugins.snacks"` |
| `"void-space.highlights.telescope"` | `"void-space.highlights.plugins.telescope"` |
| `"void-space.highlights.gitsigns"` | `"void-space.highlights.plugins.gitsigns"` |

After the edit, line 30 should read:
```lua
			local hl = require("void-space.highlights.plugins.legacy").get(palette, opts)
```
Line 35:
```lua
			local hl = require("void-space.highlights.plugins.snacks").get(palette, opts)
```
Line 73:
```lua
			local hl = require("void-space.highlights.plugins.telescope").get(palette, opts)
```
Line 78:
```lua
			local hl = require("void-space.highlights.plugins.gitsigns").get(palette, opts)
```

---

### Task 6: Verify and commit

**Files:** no changes

- [x] **Step 1: Run the full test suite**

```bash
make test
```

Expected: all tests pass with no failures. If any test fails with "module not found", check the path that failed and verify it was updated in all 4 source files.

- [x] **Step 2: Commit**

```bash
git add lua/void-space/highlights/plugins/ \
        lua/void-space/theme.lua \
        spec/highlights_spec.lua \
        spec/theme_spec.lua \
        spec/opts_spec.lua
git commit -m "refactor(highlights): move plugin modules to highlights/plugins/"
```
