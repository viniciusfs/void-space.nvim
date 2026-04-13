# Epic 2 — Plan 4: Plugin Highlights Review — Phase 1

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Audit, fix, document, and visually validate the four most visible plugin highlight modules: `bufferline`, `telescope`, `cmp`, `gitsigns`.

**Architecture:** Each plugin goes through: code audit (generic checklist + plugin-specific callouts) → fix → tests → visual validation → inline comments → `HIGHLIGHTS.md` entry. Audits are done first for all four plugins so tests stay green throughout; visual validation and documentation are batched at the end.

**Tech Stack:** Lua, Busted (`make test`), Neovim (manual visual validation)

**Prerequisite:** Plans 1–3 complete. Plugin files are at `lua/void-space/highlights/plugins/`.

**Generic audit checklist** (applied to every plugin):
1. Semantic colors — each `fg`/`bg`/`sp` uses the correct palette role (no `c.red` for non-errors, no accent colors for structural UI)
2. Link vs. repetition — groups that exactly replicate another use `link`, not repeated specs
3. Transparent path — groups with `bg` use `opts.transparent and c.none or c.X` pattern
4. Italic discipline — no hardcoded `italic = true/false`; use `opts.italic_comments` or `opts.italic_keywords`

---

### Task 1: Audit `bufferline.lua`

**Files:**
- Modify: `lua/void-space/highlights/plugins/bufferline.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/plugins/bufferline.lua`. Confirm it defines `BufferLine*` groups and has no `local bg_*` variable at the top (bufferline always renders on the tabline with explicit backgrounds — transparent mode does not apply here, this is intentional).

- [ ] **Step 2: Apply the audit checklist**

**Generic checklist results:**
- Semantic colors: all correct. `c.red` = errors/close, `c.yellow` = modified/warning, `c.cyan` = hint, `c.pink` = picker. No violations.
- Link vs. repetition: no obvious duplicates.
- Transparent path: n/a — intentionally omitted (tabline bg is always explicit).
- **Italic discipline: TWO violations found.**

**Violation 1 — `BufferLineBufferSelected` has `italic = false` hardcoded:**
Current:
```lua
hl.BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true, italic = false }
```
Fix — remove the `italic` key entirely (falsy is the default; explicit `false` is noise):
```lua
hl.BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true }
```

**Violation 2 — `BufferLinePick*` have `italic = true` hardcoded:**
Current:
```lua
hl.BufferLinePickSelected = { fg = c.pink, bg = c.bg, bold = true, italic = true }
hl.BufferLinePick = { fg = c.pink, bg = c.bg_dark, bold = true, italic = true }
hl.BufferLinePickVisible = { fg = c.pink, bg = c.bg_dark, bold = true, italic = true }
```
Fix — replace `italic = true` with `italic = opts.italic_keywords`:
```lua
hl.BufferLinePickSelected = { fg = c.pink, bg = c.bg, bold = true, italic = opts.italic_keywords }
hl.BufferLinePick = { fg = c.pink, bg = c.bg_dark, bold = true, italic = opts.italic_keywords }
hl.BufferLinePickVisible = { fg = c.pink, bg = c.bg_dark, bold = true, italic = opts.italic_keywords }
```

- [ ] **Step 3: Apply fixes and run tests**

After applying the two fixes above:
```bash
make test
```
Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lua/void-space/highlights/plugins/bufferline.lua
git commit -m "fix(highlights/bufferline): replace hardcoded italic with opts.italic_keywords"
```

---

### Task 2: Audit `telescope.lua`

**Files:**
- Modify: `lua/void-space/highlights/plugins/telescope.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/plugins/telescope.lua`. Confirm there is a `local bg_float = opts.transparent and c.none or c.bg_float` variable defined near the top.

- [ ] **Step 2: Apply the audit checklist**

**Generic checklist results:**
- Semantic colors: correct. `c.blue` = prompt accent, `c.cyan` = prefix/preview title, `c.yellow` = matches, `c.sel` = selection, `c.bg_dark` = preview pane (intentionally darker).
- Link vs. repetition: no duplicates.
- Italic discipline: no italic groups.
- **Transparent path: VIOLATION in the prompt pane.**

The file defines `local bg_float = opts.transparent and c.none or c.bg_float` but four prompt pane groups bypass it and access `c.bg_float` directly:

Current:
```lua
hl.TelescopePromptNormal = { fg = c.fg, bg = c.bg_float }
hl.TelescopePromptBorder = { fg = c.blue, bg = c.bg_float }
hl.TelescopePromptPrefix = { fg = c.cyan, bg = c.bg_float }
hl.TelescopePromptCounter = { fg = c.fg_dim, bg = c.bg_float }
```

Fix — use the local `bg_float` variable:
```lua
hl.TelescopePromptNormal = { fg = c.fg, bg = bg_float }
hl.TelescopePromptBorder = { fg = c.blue, bg = bg_float }
hl.TelescopePromptPrefix = { fg = c.cyan, bg = bg_float }
hl.TelescopePromptCounter = { fg = c.fg_dim, bg = bg_float }
```

Note: `TelescopePreviewNormal` and `TelescopePreviewBorder` use `c.bg_dark` intentionally — the preview pane is always darker than the rest of the picker. Do not change these.

- [ ] **Step 3: Apply fix and run tests**

```bash
make test
```
Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lua/void-space/highlights/plugins/telescope.lua
git commit -m "fix(highlights/telescope): use transparent-aware bg_float in prompt pane"
```

---

### Task 3: Audit `cmp.lua`

**Files:**
- Modify: `lua/void-space/highlights/plugins/cmp.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/plugins/cmp.lua`. The file covers both nvim-cmp (`Cmp*`) and blink.cmp (`BlinkCmp*`) groups. Confirm `local bg_float = opts.transparent and c.none or c.bg_float` is defined near the top.

- [ ] **Step 2: Apply the audit checklist**

**Generic checklist results — four violations:**

**Violation 1 — `CmpGhostText` has `italic = true` hardcoded:**
Current:
```lua
hl.CmpGhostText = { fg = c.fg_dim, italic = true }
```
Fix:
```lua
hl.CmpGhostText = { fg = c.fg_dim, italic = opts.italic_comments }
```

**Violation 2 — `BlinkCmpGhostText` has `italic = true` hardcoded:**
Current:
```lua
hl.BlinkCmpGhostText = { fg = c.fg_dim, italic = true }
```
Fix:
```lua
hl.BlinkCmpGhostText = { fg = c.fg_dim, italic = opts.italic_comments }
```

**Violation 3 — `BlinkCmpDocCursorLine` bypasses transparent path:**
Current:
```lua
hl.BlinkCmpDocCursorLine = { bg = c.bg_float }
```
Fix:
```lua
hl.BlinkCmpDocCursorLine = { bg = bg_float }
```

**Violation 4 — four `CmpItemKind*` groups use `c.red` (error color) for non-error LSP kinds:**

`c.red` is the error/danger semantic color. None of these four LSP completion kinds represent errors:

Current:
```lua
hl.CmpItemKindUnit = { fg = c.red }
hl.CmpItemKindReference = { fg = c.red }
hl.CmpItemKindEnumMember = { fg = c.red }
hl.CmpItemKindConstant = { fg = c.red }
```

Fix — assign semantically coherent colors:
```lua
hl.CmpItemKindUnit = { fg = c.cyan }          -- unit is type-like → cyan (type role)
hl.CmpItemKindReference = { fg = c.purple }    -- reference is field-like → purple
hl.CmpItemKindEnumMember = { fg = c.green }    -- enum member is a value → green (value role)
hl.CmpItemKindConstant = { fg = c.constant }   -- constant → c.constant (orange alias, consistent with @constant in treesitter)
```

Note: `BlinkCmpKindUnit/Reference/EnumMember/Constant` are `link`s to their `CmpItemKind*` counterparts — they will pick up these fixes automatically.

- [ ] **Step 3: Apply fixes and run tests**

```bash
make test
```
Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lua/void-space/highlights/plugins/cmp.lua
git commit -m "fix(highlights/cmp): replace hardcoded italic and c.red misuse in kind groups"
```

---

### Task 4: Audit `gitsigns.lua`

**Files:**
- Modify: `lua/void-space/highlights/plugins/gitsigns.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/plugins/gitsigns.lua`. Confirm `local bg_sidebar = opts.transparent and c.none or c.bg` is defined near the top.

- [ ] **Step 2: Apply the audit checklist**

**Generic checklist results — two violations:**

**Violation 1 — `GitSignsCurrentLineBlame` has `italic = true` hardcoded:**
Current:
```lua
hl.GitSignsCurrentLineBlame = { fg = c.fg_dim, italic = true }
```
Fix:
```lua
hl.GitSignsCurrentLineBlame = { fg = c.fg_dim, italic = opts.italic_comments }
```

**Violation 2 — `GitSignsAddLn/ChangeLn/DeleteLn` bypass transparent path:**

The file defines `bg_sidebar` for sign column groups but the `*Ln` (line background) groups hardcode `c.bg_float` directly:

Current:
```lua
hl.GitSignsAddLn = { bg = c.bg_float }
hl.GitSignsChangeLn = { bg = c.bg_float }
hl.GitSignsDeleteLn = { bg = c.bg_float }
```

Fix — add a second transparent-aware local variable for line backgrounds and use it:
```lua
-- add after the existing bg_sidebar line:
local bg_ln = opts.transparent and c.none or c.bg_float

hl.GitSignsAddLn = { bg = bg_ln }
hl.GitSignsChangeLn = { bg = bg_ln }
hl.GitSignsDeleteLn = { bg = bg_ln }
```

The full top of the function after the fix:
```lua
function M.get(c, opts)
	local hl = {}

	local bg_sidebar = opts.transparent and c.none or c.bg
	local bg_ln = opts.transparent and c.none or c.bg_float
```

**Other checks:**
- Semantic colors: `c.green` = add, `c.yellow` = change, `c.red` = delete, `c.orange` = changedelete (modified+deleted, treated as a modified state), `c.fg_dim` = untracked. All correct.
- Link vs. repetition: `*Nr` groups correctly link to their base groups.

- [ ] **Step 3: Apply fixes and run tests**

```bash
make test
```
Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lua/void-space/highlights/plugins/gitsigns.lua
git commit -m "fix(highlights/gitsigns): transparent path for Ln groups, opts.italic_comments for blame"
```

---

### Task 5: Visual validation

**Files:** no changes

Load the theme in Neovim for all four plugins. Run with the colorscheme active:

```bash
nvim --cmd "set rtp+=. | colorscheme void-space"
```

- [ ] **Step 1: Validate `bufferline`**

Open any project with multiple files open.

| What to check | Expected |
|---------------|----------|
| Inactive tabs | Dim text (`fg_dim`) on dark bar (`bg_dark`) |
| Active tab | Full-brightness text (`fg`), `bg` background, bold |
| Modified tab (unsaved buffer) | Yellow dot visible |
| Error/warning indicator on a tab | Red/yellow icon following diagnostic colors |
| Press the buffer picker key (default `<leader>b` or similar) | Pink letter appears on each tab |
| Duplicate buffer names | Duplicate tabs show dimmed path prefix (`sel` color) |

- [ ] **Step 2: Validate `telescope`**

Open telescope (`:Telescope find_files` or similar).

| What to check | Expected |
|---------------|----------|
| Overall float background | `bg_float` (one step lighter than normal buffer) |
| Prompt pane background | Same `bg_float` as the results pane (was previously inconsistent) |
| Prompt border | Blue |
| Results border | Blue |
| Preview pane | Darker (`bg_dark`) than prompt and results panes |
| Preview border | Same dark color as preview background (invisible border) |
| Preview title | Cyan background, dark text |
| Fuzzy match characters | Yellow, bold |
| Selected result | `sel` background |

In transparent mode (`opts = { transparent = true }`): all float backgrounds should become transparent (no visible panel backgrounds, borders still visible).

- [ ] **Step 3: Validate `cmp`**

Trigger completion in a buffer with an LSP or snippet source.

| What to check | Expected |
|---------------|----------|
| Completion menu background | Subtle float or selection color |
| Match characters | Yellow, bold |
| Ghost text (if enabled) | Dim, italic follows user setting (italic_comments) |
| Kind icon for a constant | Orange (was red before the fix) |
| Kind icon for a function | Yellow |
| Kind icon for a class/interface | Orange |
| Kind icon for a keyword | Blue |
| Kind icon for a snippet | Pink |

- [ ] **Step 4: Validate `gitsigns`**

Open a file in a git repository with changes.

| What to check | Expected |
|---------------|----------|
| Added lines | Green sign in gutter; `bg_float` tint on the line itself |
| Changed lines | Yellow sign; `bg_float` tint |
| Deleted lines | Red sign (fold marker); `bg_float` tint |
| Untracked file signs | Dim (`fg_dim`) color |
| Inline blame annotation | Dim text, italic follows `opts.italic_comments` |

In transparent mode: gutter signs are visible but line background tints disappear.

---

### Task 6: Inline comments

**Files:**
- Modify: `lua/void-space/highlights/plugins/bufferline.lua`
- Modify: `lua/void-space/highlights/plugins/telescope.lua`
- Modify: `lua/void-space/highlights/plugins/cmp.lua`
- Modify: `lua/void-space/highlights/plugins/gitsigns.lua`

For each file: insert comment lines immediately above the indicated group. Do not change any existing values.

- [ ] **Step 1: Add comments to `bufferline.lua`**

Insert these comments at the locations shown (one comment per section, immediately above the first group of that section):

```
above  hl.BufferLineFill          →  -- Tab bar background
above  hl.BufferLineBackground    →  -- Inactive and visible (non-selected) buffers
above  hl.BufferLineSeparator     →  -- Separators between tabs
above  hl.BufferLineIndicatorSelected  →  -- Active (selected) buffer
above  hl.BufferLineTab           →  -- Tab mode groups
above  hl.BufferLineTabClose      →  -- Close button
above  hl.BufferLineNumbers       →  -- Buffer number labels
above  hl.BufferLineModified      →  -- Modified indicator (unsaved changes dot)
above  hl.BufferLineError         →  -- Diagnostic indicators per severity
above  hl.BufferLineClose         →  -- Per-buffer close button
above  hl.BufferLinePickSelected  →  -- Picker mode (jump-to-buffer) — italic follows opts.italic_keywords
above  hl.BufferLineGroupLabel    →  -- Group labels (when bufferline groups are configured)
above  hl.BufferLineDuplicate     →  -- Duplicate buffer name disambiguation
```

- [ ] **Step 2: Add comments to `telescope.lua`**

Insert these comments at the locations shown:

```
above  local bg_float             →  -- Transparent-aware float background shared by prompt and results panels
above  hl.TelescopeNormal         →  -- Overall float body and results panel
above  hl.TelescopePromptNormal   →  -- Prompt panel (input area) — same bg_float as results
above  hl.TelescopePromptBorder   →  -- Blue border anchors the input area visually
above  hl.TelescopePromptTitle    →  -- Title bars: inverted (dark text on colored background)
above  hl.TelescopeResultsNormal  →  -- Results list
above  hl.TelescopePreviewNormal  →  -- Preview pane — intentionally darker (bg_dark) than the other panels
above  hl.TelescopeSelection      →  -- Selection and match highlighting
above  hl.TelescopeMatching       →  -- Matched characters are yellow + bold (highest contrast signal)
```

- [ ] **Step 3: Add comments to `cmp.lua`**

Insert these comments at the locations shown:

```
above  hl.CmpItemAbbr             →  -- nvim-cmp: item display
above  hl.CmpItemAbbrMatch        →  -- Match characters (fuzzy) are yellow + bold
above  hl.CmpGhostText            →  -- Ghost text — italic follows opts.italic_comments
above  hl.CmpItemKindText         →  -- nvim-cmp: kind icons by LSP CompletionItemKind
                                      -- (cyan=type, purple=field/ref, orange=class/constant, blue=keyword/file)
above  hl.BlinkCmpMenu            →  -- blink.cmp: menu chrome
above  hl.BlinkCmpKindText        →  -- blink.cmp: kind icons — link to nvim-cmp definitions above
above  hl.BlinkCmpSource          →  -- blink.cmp: source label and ghost text
above  hl.BlinkCmpDoc             →  -- blink.cmp: documentation float
```

- [ ] **Step 4: Add comments to `gitsigns.lua`**

Insert these comments at the locations shown:

```
above  local bg_sidebar           →  -- Sign column backgrounds (transparent-aware)
above  local bg_ln                →  -- Line background tints for changed lines (transparent-aware)
above  hl.GitSignsAdd             →  -- Sign column markers
above  hl.GitSignsChangedelete    →  -- Changedelete: line was modified then partially deleted — orange sits between change and delete
above  hl.GitSignsUntracked       →  -- Untracked files are dim in the gutter
above  hl.GitSignsAddNr           →  -- Number column variants (link to base sign groups)
above  hl.GitSignsAddLn           →  -- Line background tints (full-line highlight on changed lines)
above  hl.GitSignsCurrentLineBlame  →  -- Inline blame annotation — italic follows opts.italic_comments
```

- [ ] **Step 5: Run tests to confirm no accidental changes**

```bash
make test
```
Expected: all tests pass.

- [ ] **Step 6: Commit**

```bash
git add lua/void-space/highlights/plugins/bufferline.lua \
        lua/void-space/highlights/plugins/telescope.lua \
        lua/void-space/highlights/plugins/cmp.lua \
        lua/void-space/highlights/plugins/gitsigns.lua
git commit -m "docs(highlights/plugins): add inline section comments for phase 1 plugins"
```

---

### Task 7: Add `HIGHLIGHTS.md` entries

**Files:**
- Modify: `docs/HIGHLIGHTS.md`

- [ ] **Step 1: Replace the plugin modules placeholder**

In `docs/HIGHLIGHTS.md`, find the `## Plugin modules` section (currently a placeholder block). Replace the placeholder with the four plugin sections below. Keep the `## Plugin modules` heading and remove the `> **Placeholder…**` blockquote.

The new content for `## Plugin modules` through end of file:

````markdown
## Plugin modules

---

### bufferline

Tab bar showing open buffers (or tabs). Renders on a persistent `bg_dark` strip at the top of the editor.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `BufferLineBackground` | fg: fg_dim, bg: bg_dark | Inactive tabs are dim text on the dark tab bar |
| `BufferLineBufferSelected` | fg: fg, bg: bg, bold | Active tab is full-brightness, bold, on the normal background |
| `BufferLineModified` | fg: yellow | Unsaved buffer shows a yellow dot |
| `BufferLineError` | fg: red, bg: bg_dark | Error diagnostic icon follows error semantic color |
| `BufferLineWarning` | fg: yellow, bg: bg_dark | Warning diagnostic icon follows warning semantic color |
| `BufferLineHint` | fg: cyan, bg: bg_dark | Hint diagnostic icon follows hint semantic color |
| `BufferLinePickSelected` | fg: pink, bold, italic (opts) | Jump-to-buffer picker shows a pink letter on the active tab |
| `BufferLineGroupLabel` | fg: bg_dark, bg: purple | Group label band: dark text on purple (inverted) |
| `BufferLineDuplicate` | fg: sel, bg: bg_dark | Duplicate buffer path prefix is very dim |

**How to validate:** Open multiple buffers. Check inactive vs. active tab appearance. Introduce an unsaved change to see the yellow dot. Trigger the buffer picker if configured.

---

### cmp

Completion menu for nvim-cmp and blink.cmp. The `BlinkCmpKind*` groups link to their `CmpItemKind*` counterparts, so a single color change propagates to both engines.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `CmpItemAbbrMatch` | fg: yellow, bold | Fuzzy-matched characters are yellow and bold |
| `CmpItemAbbrDeprecated` | fg: fg_dim, strikethrough | Deprecated items are struck through |
| `CmpItemKindFunction` | fg: yellow | Function kind icon |
| `CmpItemKindClass` | fg: orange | Class/interface/struct kind icon (type-family) |
| `CmpItemKindConstant` | fg: constant (orange alias) | Constant kind icon (consistent with `@constant` in treesitter) |
| `CmpItemKindKeyword` | fg: blue | Keyword kind icon |
| `CmpItemKindSnippet` | fg: pink | Snippet kind icon |
| `CmpItemKindField` | fg: purple | Field/property kind icon |
| `CmpGhostText` | fg: fg_dim, italic (opts) | Ghost text preview; italic follows `opts.italic_comments` |
| `BlinkCmpDocBorder` | fg: sel | Blink doc float border is low-contrast |

**How to validate:** Trigger completion in a buffer with LSP. Verify match characters are yellow. Check that constant/enum-member items are orange, not red. Check ghost text is dim.

---

### gitsigns

Sign column and line background indicators for git hunks. Sign backgrounds are transparent-aware; line background tints use `bg_float`.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `GitSignsAdd` | fg: green, bg: bg (transparent-aware) | Added lines show a green sign |
| `GitSignsChange` | fg: yellow, bg: bg (transparent-aware) | Changed lines show a yellow sign |
| `GitSignsDelete` | fg: red, bg: bg (transparent-aware) | Deleted lines show a red fold marker |
| `GitSignsChangedelete` | fg: orange | Partially deleted changed line — orange (between change and delete) |
| `GitSignsUntracked` | fg: fg_dim | Untracked files are dim in the gutter |
| `GitSignsAddLn` | bg: bg_float (transparent-aware) | Full-line tint on added lines (subtle, one step lighter than normal bg) |
| `GitSignsCurrentLineBlame` | fg: fg_dim, italic (opts) | Inline blame annotation; italic follows `opts.italic_comments` |

**How to validate:** Open a file in a git repo with staged and unstaged changes. Verify sign colors. Enable line blame (`:Gitsigns toggle_current_line_blame`) to see dim italic text.

---

### telescope

Three-panel picker float: results, prompt input, and preview. Preview pane is intentionally darker (`bg_dark`) than the other two panels.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `TelescopeNormal` | fg: fg, bg: bg_float (transparent-aware) | Results panel body |
| `TelescopePromptBorder` | fg: blue, bg: bg_float (transparent-aware) | Prompt border is blue to anchor the input area |
| `TelescopePromptTitle` | fg: bg, bg: blue, bold | Prompt title: inverted (dark text on blue) |
| `TelescopePreviewNormal` | bg: bg_dark | Preview pane is darker than prompt/results |
| `TelescopePreviewBorder` | fg: bg_dark, bg: bg_dark | Preview border blends into the preview background (invisible) |
| `TelescopeSelection` | fg: fg, bg: sel | Selected result uses the selection background |
| `TelescopeMatching` | fg: yellow, bold | Fuzzy-match characters are yellow and bold |
| `TelescopeMultiSelection` | fg: purple, bg: sel | Multi-selected items show purple text |

**How to validate:** Open `:Telescope find_files`. Check that prompt and results share the same background (`bg_float`). Check preview is visibly darker. Type to see yellow match characters.

````

- [ ] **Step 2: Run tests**

```bash
make test
```
Expected: all tests pass (no Lua changes, just docs).

- [ ] **Step 3: Commit**

```bash
git add docs/HIGHLIGHTS.md
git commit -m "docs(HIGHLIGHTS): add bufferline, cmp, gitsigns, telescope plugin sections"
```
