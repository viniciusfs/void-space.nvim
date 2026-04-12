# Epic 2 — Plan 3: Documentation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add inline section comments to the 5 core highlight modules and create `docs/HIGHLIGHTS.md` — a reference document covering all core groups with validation instructions. This doc serves as the template for plugin sections to be added during task 2.3.

**Architecture:** Two parallel concerns: (A) inline comments in `.lua` files for quick in-editor context, (B) a markdown reference doc for navigable overview. Both are written after the core review (Plan 2) so they reflect the final state of the modules.

**Tech Stack:** Lua comments, Markdown

**Prerequisite:** Plan 2 (core review) must be complete. All color decisions have been made.

---

### Task 1: Add inline comments to `editor.lua`

**Files:**
- Modify: `lua/void-space/highlights/editor.lua`

`editor.lua` covers Neovim's built-in editor chrome. It already has a few inline comments (e.g. `-- Diff (editor-level)`, `-- Soft diff`). Add section headers for all logical groups.

- [x] **Step 1: Add section headers**

Insert section comments so the file reads as:

```lua
local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_normal = opts.transparent and c.none or c.bg
	local bg_float = opts.transparent and c.none or c.bg_float
	local bg_sidebar = opts.transparent and c.none or c.bg

	-- Normal buffers & floats
	hl.Normal = ...
	hl.NormalNC = ...
	hl.NormalFloat = ...
	hl.FloatBorder = ...
	hl.FloatTitle = ...
	hl.FloatFooter = ...

	-- Cursor & current line
	hl.ColorColumn = ...
	hl.Conceal = ...
	hl.Cursor = ...
	hl.lCursor = ...
	hl.CursorIM = ...
	hl.CursorColumn = ...
	hl.CursorLine = ...
	hl.CursorLineNr = ...
	hl.CursorLineFold = ...
	hl.CursorLineSign = ...

	-- File tree & navigation
	hl.Directory = ...
	hl.EndOfBuffer = ...

	-- Messages & prompts
	hl.ErrorMsg = ...
	hl.WarningMsg = ...
	hl.ModeMsg = ...
	hl.MoreMsg = ...
	hl.Question = ...

	-- Folds
	hl.FoldColumn = ...
	hl.Folded = ...

	-- Line numbers
	hl.LineNr = ...
	hl.LineNrAbove = ...
	hl.LineNrBelow = ...

	-- Matching
	-- MatchParen uses fg=bg_float (a background color) so the matched character is
	-- readable on the pink highlight background (inverted rendering pattern).
	hl.MatchParen = ...

	-- Command line & message area
	hl.MsgArea = ...
	hl.MsgSeparator = ...

	-- Non-text characters
	hl.NonText = ...
	hl.SpecialKey = ...
	hl.Whitespace = ...

	-- Completion menu (Pmenu)
	hl.Pmenu = ...
	hl.PmenuSel = ...
	hl.PmenuKind = ...
	hl.PmenuKindSel = ...
	hl.PmenuExtra = ...
	hl.PmenuExtraSel = ...
	hl.PmenuSbar = ...
	hl.PmenuThumb = ...

	-- Search
	-- Search/IncSearch use fg=bg (inverted) to show dark text on a colored highlight.
	hl.Search = ...
	hl.IncSearch = ...
	hl.CurSearch = ...
	hl.Substitute = ...

	-- Gutter & splits
	hl.SignColumn = ...
	hl.VertSplit = ...
	hl.WinSeparator = ...

	-- Spell checking
	hl.SpellBad = ...
	hl.SpellCap = ...
	hl.SpellLocal = ...
	hl.SpellRare = ...

	-- Status line & tab line
	hl.StatusLine = ...
	hl.StatusLineNC = ...
	hl.StatusLineTerm = ...
	hl.TabLine = ...
	hl.TabLineFill = ...
	hl.TabLineSel = ...

	-- Titles & visual selection
	hl.Title = ...
	hl.Visual = ...
	hl.VisualNOS = ...

	-- Window bar
	hl.WildMenu = ...
	hl.WinBar = ...
	hl.WinBarNC = ...

	-- Quickfix
	hl.QuickFixLine = ...

	-- Diff (block) — inverted: fg=bg so text is readable on a colored background
	hl.DiffAdd = ...
	hl.DiffChange = ...
	hl.DiffDelete = ...
	hl.DiffText = ...

	-- Diff (inline) — fg only, no background, for inline diff views
	hl.diffAdded = ...
	hl.diffRemoved = ...
	hl.diffChanged = ...
	hl.diffOldFile = ...
	hl.diffNewFile = ...
	hl.diffFile = ...
	hl.diffLine = ...
	hl.diffIndexLine = ...

	return hl
end

return M
```

Keep all existing group definitions unchanged — only add the section comment lines shown above.

- [x] **Step 2: Verify no accidental changes**

```bash
make test
```

Expected: all tests pass.

---

### Task 2: Add inline comments to `syntax.lua`

**Files:**
- Modify: `lua/void-space/highlights/syntax.lua`

- [x] **Step 1: Add section headers**

```lua
local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_normal = opts.transparent and c.none or c.bg

	-- Comments
	hl.Comment = ...
	hl.SpecialComment = ...

	-- Literals
	hl.Constant = ...
	hl.String = ...
	hl.Character = ...
	hl.Number = ...
	hl.Float = ...
	hl.Boolean = ...

	-- Identifiers & functions
	-- Identifier uses type_name (cyan) as a deliberate aesthetic choice to give
	-- variable names visual weight distinct from plain text.
	hl.Identifier = ...
	hl.Function = ...

	-- Keywords & control flow
	hl.Statement = ...
	hl.Conditional = ...
	hl.Repeat = ...
	hl.Label = ...
	hl.Keyword = ...
	hl.Exception = ...
	hl.Operator = ...

	-- Preprocessor
	hl.PreProc = ...
	hl.Include = ...
	hl.Define = ...
	hl.Macro = ...
	hl.PreCondit = ...

	-- Types
	hl.Type = ...
	hl.StorageClass = ...
	hl.Structure = ...
	hl.Typedef = ...

	-- Special characters & tags
	hl.Special = ...
	hl.SpecialChar = ...
	hl.Tag = ...
	-- Delimiter uses plain fg to stay low-noise — punctuation should not distract.
	hl.Delimiter = ...

	-- Formatting
	hl.Underlined = ...
	hl.Bold = ...
	hl.Italic = ...
	hl.Error = ...
	hl.Todo = ...

	return hl
end

return M
```

- [x] **Step 2: Verify no accidental changes**

```bash
make test
```

Expected: all tests pass.

---

### Task 3: Verify and supplement comments in `treesitter.lua`

**Files:**
- Modify: `lua/void-space/highlights/treesitter.lua`

`treesitter.lua` already has section headers (`-- Variables`, `-- Constants`, etc.). This task verifies they are complete and adds notes for non-obvious decisions.

- [x] **Step 1: Check section coverage**

Open the file and verify every logical group has a section header. The sections that should exist:

```
-- Variables
-- Constants
-- Modules / namespaces
-- Strings
-- Characters / Numbers / Booleans
-- Types
-- Attributes / Properties
-- Functions
-- Keywords
-- Operators / Punctuation
-- Comments
-- Tags (HTML / JSX / etc.)
-- Markup (Markdown, RST, etc.)
-- Diff
```

- [x] **Step 2: Add non-obvious decision notes**

Add inline comments for the decisions made during Plan 2 review. Example:

```lua
-- @variable.member uses type_name (cyan) to distinguish property access from
-- plain variable reads — intentional aesthetic choice, not a type annotation.
hl["@variable.member"] = { fg = c.type_name }
```

```lua
-- @function.macro and @constructor use builtin color: they behave like builtins
-- even when user-defined (they transform code or produce values implicitly).
hl["@function.macro"] = { fg = c.builtin }
hl["@constructor"] = { fg = c.builtin }
```

Add a note next to `@keyword.exception` explaining the color choice (whatever was decided in Plan 2, Task 2).

- [x] **Step 3: Verify**

```bash
make test
```

Expected: all tests pass.

---

### Task 4: Add inline comments to `lsp.lua`

**Files:**
- Modify: `lua/void-space/highlights/lsp.lua`

- [x] **Step 1: Add section headers and decision notes**

```lua
local M = {}

function M.get(c, opts)
	local hl = {}

	-- LSP reference highlighting (set by vim.lsp.buf.document_highlight)
	-- All three use sel background so highlights are subtle, not distracting.
	hl.LspReferenceText = ...
	hl.LspReferenceRead = ...
	-- Write reference gets bold to distinguish mutation from reads.
	hl.LspReferenceWrite = ...

	-- Signature & hints
	hl.LspSignatureActiveParameter = ...
	-- LspInlayHint: fg_dim + bg_float creates a "ghost text" appearance.
	-- italic follows opts.italic_comments (or is hardcoded — note the decision here).
	hl.LspInlayHint = ...
	hl.LspCodeLens = ...
	hl.LspCodeLensSeparator = ...

	-- Semantic tokens — override treesitter for LSP-aware buffers.
	-- Most entries link to their syntax.lua equivalent for palette consistency.
	hl["@lsp.type.class"] = ...
	-- ... (keep existing groups)

	return hl
end

return M
```

Add a comment next to `@lsp.type.namespace` documenting the color choice and how it relates to `@module` in treesitter (per the decision in Plan 2, Task 4).

- [x] **Step 2: Verify**

```bash
make test
```

Expected: all tests pass.

---

### Task 5: Add inline comments to `diagnostics.lua`

**Files:**
- Modify: `lua/void-space/highlights/diagnostics.lua`

- [x] **Step 1: Add section headers**

```lua
local M = {}

function M.get(c, opts)
	local hl = {}

	-- Base diagnostic colors — used by virtual text, signs, and floats via links.
	hl.DiagnosticError = ...
	hl.DiagnosticWarn = ...
	hl.DiagnosticInfo = ...
	hl.DiagnosticHint = ...
	hl.DiagnosticOk = ...

	-- Undercurl — sp sets the color of the wavy underline; no fg/bg override.
	hl.DiagnosticUnderlineError = ...
	hl.DiagnosticUnderlineWarn = ...
	hl.DiagnosticUnderlineInfo = ...
	hl.DiagnosticUnderlineHint = ...
	hl.DiagnosticUnderlineOk = ...

	-- Virtual text — bg=bg_float creates a subtle box at one lightness step above bg.
	hl.DiagnosticVirtualTextError = ...
	hl.DiagnosticVirtualTextWarn = ...
	hl.DiagnosticVirtualTextInfo = ...
	hl.DiagnosticVirtualTextHint = ...
	hl.DiagnosticVirtualTextOk = ...

	-- Floating diagnostics — link to base colors, no bg override.
	hl.DiagnosticFloatingError = ...
	hl.DiagnosticFloatingWarn = ...
	hl.DiagnosticFloatingInfo = ...
	hl.DiagnosticFloatingHint = ...

	-- Sign column — link to base colors.
	hl.DiagnosticSignError = ...
	hl.DiagnosticSignWarn = ...
	hl.DiagnosticSignInfo = ...
	hl.DiagnosticSignHint = ...

	return hl
end

return M
```

- [x] **Step 2: Verify**

```bash
make test
```

Expected: all tests pass.

---

### Task 6: Create `docs/HIGHLIGHTS.md`

**Files:**
- Create: `docs/HIGHLIGHTS.md`

- [x] **Step 1: Resolve conditional cells before writing**

Two rows in the tables below are marked `(per Plan 2 decision)`. Before writing the document, read the current source files to get the actual color used:

```bash
# Check what color Exception uses after Plan 2:
grep "Exception" lua/void-space/highlights/syntax.lua

# Check what color @keyword.exception uses after Plan 2:
grep "keyword.exception" lua/void-space/highlights/treesitter.lua
```

Replace `(per Plan 2 decision)` in the tables with the actual palette key (e.g. `keyword (blue)` or `purple`).

- [x] **Step 2: Create the reference document**

Create `docs/HIGHLIGHTS.md` with the following structure. The `(per Plan 2 decision)` placeholders must already be resolved (Step 1) before writing.

````markdown
# HIGHLIGHTS

Acceptance criteria for each highlight group: what the group does and how to validate it in Neovim.

Groups are organized by module. For each group the "color" column names the palette key, not the hex value — check `lua/void-space/palettes/default.lua` for the current hex.

---

## Core modules

### editor

Neovim built-in chrome: windows, statusline, completion menu, search, diffs.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `Normal` | fg / bg | Default buffer text and background |
| `NormalFloat` | fg / bg_float | Float windows (hover, diagnostics popup) are one step lighter than Normal |
| `FloatBorder` | sel / bg_float | Float border is dim, not distracting |
| `CursorLine` | bg: bg_float | Current line has a subtle background tint |
| `LineNr` | fg: sel | Line numbers are dim; current line number is brighter (`CursorLineNr` fg=fg) |
| `Search` | fg: bg, bg: yellow | Matched text shows dark characters on yellow (inverted) |
| `IncSearch` | fg: bg, bg: bright_yellow, bold | Active incremental search is brighter than static matches |
| `Visual` | fg: fg, bg: sel | Visual selection uses the selection background |
| `MatchParen` | fg: bg_float, bg: pink, bold | Matching bracket shows inverted on pink — readable because fg is a background color |
| `WinSeparator` | fg: sel | Split border is dim, uses the same color as selection backgrounds |
| `DiffAdd` | fg: bg, bg: green | Block diff add: inverted green block |
| `DiffDelete` | fg: bg, bg: red | Block diff delete: inverted red block |
| `diffAdded` | fg: green | Inline diff add: green text, no background |
| `diffRemoved` | fg: red | Inline diff remove: red text, no background |
| `SpellBad` | sp: red, undercurl | Misspelling shows red undercurl, no color change to text |

**How to validate:**
1. Open any file: check CursorLine is subtle, LineNr is dim
2. Press `/term` to search: yellow highlights appear, current match is brighter
3. Select text (`v`): selection uses sel background
4. `:vs` to split: separator is a dim line
5. Open a float (hover or diagnostic): background is slightly lighter than buffer

---

### syntax

Vim's legacy syntax groups. Apply to all buffers — treesitter overrides these for supported languages.

| Group | Color | Validates as |
|-------|-------|--------------|
| `Comment` | comment (fg_dim) | Dim, italic if `italic_comments=true` |
| `String` | string_lit (green) | String literals are green |
| `Constant` | constant (orange) | Numbers, booleans, and constants are orange |
| `Function` | func (purple) | Function names at definition are purple |
| `Keyword` | keyword (blue) | Control flow keywords are blue |
| `Type` | type (cyan) | Type names are cyan |
| `Identifier` | type_name (cyan) | Variable names — cyan by aesthetic choice |
| `Exception` | (per Plan 2 decision) | Exception keywords match treesitter `@keyword.exception` |
| `Operator` | operator (fg) | Operators are plain text color — low noise |
| `Delimiter` | fg | Brackets, commas are plain text — no distraction |
| `Special` | special (yellow) | Special chars (escape sequences, regex) are yellow |

**How to validate:**
1. Open a `.lua` file without Treesitter (`:TSBufDisable highlight`): check colors match table above
2. Open a JSON file: booleans/numbers are orange, strings are green

---

### treesitter

Neovim Tree-sitter highlight groups (`@namespace`). Override syntax groups for supported languages.

| Group | Color | Validates as |
|-------|-------|--------------|
| `@variable` | fg | Local variables are plain text — no special color |
| `@variable.builtin` | builtin (purple) | `self`, `this`, `__name__` etc. are purple |
| `@variable.member` | type_name (cyan) | Object property access is cyan (e.g. `obj.field`) |
| `@function` | func (purple) | Function names at definition and call |
| `@function.builtin` | builtin (purple) | `print`, `require`, `len` etc. |
| `@keyword` | keyword (blue) | All keyword subtypes default to blue |
| `@keyword.exception` | (per Plan 2 decision) | Consistent with `Exception` in syntax.lua |
| `@type` | type (cyan) | Type names link to syntax `Type` |
| `@string` | string_lit (green) | Strings link to syntax `String` |
| `@markup.heading.1` | yellow, bold | H1 in Markdown |
| `@markup.heading.2` | blue, bold | H2 in Markdown |
| `@markup.heading.3` | cyan, bold | H3 in Markdown |
| `@markup.link` | blue, underline | Link text in Markdown |
| `@markup.raw` | string_lit (green) | Inline code in Markdown |
| `@diff.plus` | → diffAdded | Diff additions link to editor diff group |

**How to validate:**
1. Open a `.lua` file with Treesitter active: check `@variable` is plain, `@function` is purple
2. Open a `.md` file: check heading colors follow H1=yellow, H2=blue, H3=cyan

---

### lsp

Neovim LSP client groups and semantic token groups (`@lsp.*`). Override treesitter for LSP-aware buffers.

| Group | Color | Validates as |
|-------|-------|--------------|
| `LspReferenceText` | bg: sel | All references to hovered symbol get sel background |
| `LspReferenceWrite` | bg: sel, bold | Write references are bold to flag mutation |
| `LspInlayHint` | fg_dim / bg_float | Ghost text appearance — dim on slightly elevated bg |
| `LspCodeLens` | fg_dim | Code lens text is dim and italic |
| `@lsp.type.function` | → Function | Functions resolved by LSP match syntax color |
| `@lsp.type.namespace` | type (cyan) | Namespaces are cyan (see note about @module discrepancy if applicable) |
| `@lsp.mod.readonly` | constant (orange) | Read-only bindings appear as constants |
| `@lsp.mod.deprecated` | strikethrough | Deprecated symbols have strikethrough, no color change |

**How to validate:**
1. In an LSP-active file, hover over a symbol: all references get a background highlight
2. Check that inlay hints (if visible) appear dim and distinct from code
3. Check that deprecated symbols have strikethrough

---

### diagnostics

Neovim diagnostic groups. Cover all severity levels for underlines, virtual text, floating windows, and sign column.

| Group | Color | Validates as |
|-------|-------|--------------|
| `DiagnosticError` | error (red) | Red text for error-level messages |
| `DiagnosticWarn` | warning (yellow) | Yellow text for warnings |
| `DiagnosticInfo` | info (cyan) | Cyan text for info messages |
| `DiagnosticHint` | hint (purple) | Purple text for hints |
| `DiagnosticUnderlineError` | sp: error, undercurl | Red undercurl under error spans |
| `DiagnosticVirtualTextError` | fg: error, bg: bg_float | Virtual text: red on subtle box background |
| `DiagnosticFloatingError` | → DiagnosticError | Floating window error label links to base color |
| `DiagnosticSignError` | → DiagnosticError | Sign column error icon links to base color |

**How to validate:**
1. Introduce a type error in a typed file: red undercurl appears, virtual text shows in red on a subtle box
2. Run `:lua vim.diagnostic.open_float()`: floating window shows error in red
3. Sign column shows colored icons matching severity level

---

## Plugin modules

> **Placeholder — to be filled during task 2.3 (plugin review)**
>
> Each plugin reviewed during task 2.3 will have a section added here following the same format as the core modules above: a table of key groups with color and validation description, and a short "how to validate" block.
>
> Plugins to document (alphabetical):
> `bufferline`, `cmp`, `dashboard`, `fidget`, `flash`, `gitsigns`, `illuminate`,
> `indent`, `lazy`, `legacy`, `mini`, `neo_tree`, `noice`, `notify`,
> `render_markdown`, `snacks`, `telescope`, `todo_comments`, `trouble`, `which_key`
````

- [x] **Step 3: Verify the document is well-formed**

Check that all groups mentioned in the tables exist in the actual `.lua` files. No phantom group names.

---

### Task 7: Commit all documentation

**Files:** no code changes

- [x] **Step 1: Run tests one final time**

```bash
make test
```

Expected: all tests pass.

- [x] **Step 2: Commit**

```bash
git add lua/void-space/highlights/editor.lua \
        lua/void-space/highlights/syntax.lua \
        lua/void-space/highlights/treesitter.lua \
        lua/void-space/highlights/lsp.lua \
        lua/void-space/highlights/diagnostics.lua \
        docs/HIGHLIGHTS.md
git commit -m "docs(highlights): add inline comments to core modules and create HIGHLIGHTS.md"
```
