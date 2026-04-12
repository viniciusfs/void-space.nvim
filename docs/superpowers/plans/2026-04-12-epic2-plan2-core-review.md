# Epic 2 — Plan 2: Core Highlights Review

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Audit the 5 core highlight modules for semantic color correctness and visual consistency, fix any issues found, and validate visually in Neovim.

**Architecture:** Each task covers one module: code audit (read → check checklist → apply fixes) followed by a shared visual validation task at the end. The audit checklist is defined per module based on the groups it owns. Fixes are applied inline — no new files are created.

**Tech Stack:** Lua, Busted (`make test`), Neovim (manual visual validation)

**Prerequisite:** Plan 1 (file reorganization) must be complete. Core modules are at `lua/void-space/highlights/{editor,syntax,treesitter,lsp,diagnostics}.lua`.

**Palette reference** (`lua/void-space/palettes/default.lua`):
- Backgrounds: `bg_dark`, `bg`, `bg_float`, `sel`, `fg_dim`, `fg`
- Accents: `green`, `yellow`, `red`, `purple`, `blue`, `cyan`, `pink`, `orange`, `bright_yellow`
- Syntax roles: `comment=fg_dim`, `keyword=blue`, `func=purple`, `type_name=cyan`, `string_lit=green`, `constant=orange`, `operator=fg`, `type=cyan`, `builtin=purple`, `special=yellow`
- Diagnostics: `error=red`, `warning=yellow`, `info=cyan`, `hint=purple`

---

### Task 1: Audit `editor.lua`

**Files:**
- Modify: `lua/void-space/highlights/editor.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/editor.lua` and apply the checklist below to each group.

- [ ] **Step 2: Apply the audit checklist**

Check each group against these questions:

**Inverted rendering pattern** — Groups that show content against a colored background use `fg = c.bg` or `fg = c.bg_float` as the text color. This is intentional and correct. Groups using this pattern: `MatchParen`, `PmenuSel`, `PmenuKindSel`, `Search`, `IncSearch`, `WildMenu`, `DiffAdd/Change/Delete/Text`, `TelescopePromptTitle` (if present). Verify none of these have been accidentally changed to a visible foreground color.

**Border and separator colors** — `FloatBorder`, `VertSplit`, `WinSeparator` should use `c.sel` (not `c.fg` or an accent) to stay low-contrast. Check these use `c.sel`.

**Message / status colors** — `ErrorMsg` should use `c.red`, `WarningMsg` should use `c.yellow`, `ModeMsg`/`MoreMsg`/`Question` should use `c.green`. Check for any mismatch.

**Diff groups** — Two patterns coexist intentionally:
- Block diff (`DiffAdd/Change/Delete/Text`): inverted — `fg = c.bg, bg = <color>`. Shows colored blocks.
- Inline diff (`diffAdded/diffRemoved/diffChanged/…`): `fg = <color>` only. No bg. Shows colored text inline.
Verify both patterns are present and correct.

**Spell check** — `SpellBad/Cap/Local/Rare` should use `sp = <color>` with `undercurl = true` and no `fg`/`bg`. Verify.

- [ ] **Step 3: Apply any fixes, run tests**

If any issue is found, apply the fix. After all fixes:

```bash
make test
```

Expected: all tests pass.

- [ ] **Step 4: Commit (if changes were made)**

```bash
git add lua/void-space/highlights/editor.lua
git commit -m "fix(highlights/editor): correct semantic color assignments"
```

If no changes were needed, skip this step and note that the module passed audit clean.

---

### Task 2: Audit `syntax.lua`

**Files:**
- Modify: `lua/void-space/highlights/syntax.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/syntax.lua`.

- [ ] **Step 2: Apply the audit checklist**

**`Identifier = { fg = c.type_name }`** — `c.type_name` is `cyan`, the color for type names. Using it for generic identifiers (local variables, names) blurs the distinction between types and values. Evaluate: does this cause visual noise in practice, or is the differentiation intentional? If identifiers should be low-noise, change to `c.fg`. If the cyan color is a deliberate aesthetic choice for identifiers, keep it and add a comment.

**`Exception = { fg = c.purple }`** — `c.purple` is the color for functions and builtins. Exception using purple is semantically loose but creates a "special control flow" visual signal. Compare with `@keyword.exception` in `treesitter.lua` (which uses `c.type_name`). These two must agree: either both use the same color, or `@keyword.exception` links to `Exception`. Fix the inconsistency.

**`StorageClass`, `Structure` = `c.keyword`** — Storage modifiers and structure keywords using the keyword color is correct. Verify.

**`Delimiter = { fg = c.fg }`** — Delimiters as plain text (`c.fg`) is intentional low-noise. Correct.

**`Tag = { fg = c.yellow }`** — HTML/XML tags using yellow (`c.special`). Reasonable for markup. Verify it doesn't conflict with other yellow usages.

- [ ] **Step 3: Resolve the `Exception` / `@keyword.exception` inconsistency**

Current state:
- `syntax.lua`: `Exception = { fg = c.purple }`
- `treesitter.lua`: `@keyword.exception = { fg = c.type_name }`

These conflict. Pick one approach and apply it to both files:

**Option A** — Exception as keyword color (blue), consistent with other keyword groups:
```lua
-- syntax.lua
hl.Exception = { fg = c.keyword }
-- treesitter.lua
hl["@keyword.exception"] = { fg = c.keyword }
```

**Option B** — Exception links to a single definition, treesitter defers to syntax:
```lua
-- syntax.lua — keep existing color
hl.Exception = { fg = c.purple }
-- treesitter.lua — link to Exception instead of using type_name
hl["@keyword.exception"] = { link = "Exception" }
```

Apply whichever is most consistent with the theme's color role semantics.

- [ ] **Step 4: Run tests**

```bash
make test
```

Expected: all tests pass.

- [ ] **Step 5: Commit**

```bash
git add lua/void-space/highlights/syntax.lua lua/void-space/highlights/treesitter.lua
git commit -m "fix(highlights/syntax): resolve Exception color inconsistency with treesitter"
```

---

### Task 3: Audit `treesitter.lua`

**Files:**
- Modify: `lua/void-space/highlights/treesitter.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/treesitter.lua`.

- [ ] **Step 2: Apply the audit checklist**

**`@variable.member = { fg = c.type_name }`** — Member access (struct fields, object properties) uses `c.type_name` (cyan). This makes property access look like a type. Evaluate: is the visual distinction from plain `c.fg` useful or does it add noise? Consider whether `c.fg` or a dedicated attribute color (e.g. `c.type_name`) is more semantically accurate.

**`@function.macro` and `@constructor` both use `c.builtin`** — Macros and constructors using the builtin color (purple) is intentional: they behave like builtins even if user-defined. Correct.

**`@markup.list = { fg = c.constant }`** — List markers use `c.constant` (orange). Evaluate: is orange the best choice for list markers, or would `c.fg_dim` (lower noise) be more appropriate?

**`@markup.heading` levels** — Check the heading color progression makes sense visually: H1=yellow, H2=blue, H3=cyan, H4=green, H5=orange, H6=type_name. All bold. Verify no two adjacent levels share the same color.

**`@keyword.*` family** — Most keyword subtypes use `c.keyword` (blue) with optional italic. Verify all keyword subtypes consistently use `c.keyword` or have an explicit reason to deviate.

**`Exception` fix** — Apply the fix decided in Task 2 if it affects this file (see Task 2 Step 3).

- [ ] **Step 3: Apply fixes, run tests**

```bash
make test
```

Expected: all tests pass.

- [ ] **Step 4: Commit (if changes were made)**

```bash
git add lua/void-space/highlights/treesitter.lua
git commit -m "fix(highlights/treesitter): correct semantic color assignments"
```

---

### Task 4: Audit `lsp.lua`

**Files:**
- Modify: `lua/void-space/highlights/lsp.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/lsp.lua`.

- [ ] **Step 2: Apply the audit checklist**

**`LspInlayHint = { fg = c.fg_dim, bg = c.bg_float, italic = true }`** — `italic = true` is hardcoded, not from `opts`. Every other italic in the codebase uses `italic = opts.italic_comments` or `italic = opts.italic_keywords`. Decide: should inlay hints always be italic regardless of user preference (hardcoded), or should they follow `opts.italic_comments`?

If following opts:
```lua
hl.LspInlayHint = { fg = c.fg_dim, bg = c.bg_float, italic = opts.italic_comments }
```

**`@lsp.type.namespace = { fg = c.type }`** vs `@module = { fg = c.purple }` in treesitter — Both represent modules/namespaces. `@lsp.type.namespace` uses `c.type` (cyan), `@module` uses `c.purple`. LSP semantic tokens override treesitter, so in LSP-capable buffers namespaces will appear cyan, not purple. Evaluate whether these should agree. If yes, change one to match the other.

**Semantic token coverage** — Check that `@lsp.type.*` entries for `class`, `enum`, `function`, `method`, `struct` all link to their equivalent syntax group rather than hardcoding colors. This ensures palette changes propagate correctly. Current links look correct — verify no missing entries.

- [ ] **Step 3: Apply fixes, run tests**

```bash
make test
```

Expected: all tests pass.

- [ ] **Step 4: Commit (if changes were made)**

```bash
git add lua/void-space/highlights/lsp.lua
git commit -m "fix(highlights/lsp): align inlay hint italic with opts system"
```

---

### Task 5: Audit `diagnostics.lua`

**Files:**
- Modify: `lua/void-space/highlights/diagnostics.lua`

- [ ] **Step 1: Read the file**

Open `lua/void-space/highlights/diagnostics.lua`.

- [ ] **Step 2: Apply the audit checklist**

This module is the cleanest of the five. Verify the following invariants hold:

**Semantic color usage** — All groups use `c.error`, `c.warning`, `c.info`, `c.hint`, or `c.green`. No accent colors used directly. Verify.

**`DiagnosticVirtualText*` background** — All virtual text groups use `bg = c.bg_float`. This creates a subtle box effect at one lightness step above the normal background. Verify all 5 levels (`Error/Warn/Info/Hint/Ok`) are consistent.

**Floating and Sign groups** — `DiagnosticFloating*` and `DiagnosticSign*` both link to their base `Diagnostic*` group (no bg override). Verify these are pure links.

**`DiagnosticOk`** — Exists as `fg = c.green` and `sp = c.green, undercurl = true`. Verify `DiagnosticUnderlineOk` is present and complete.

- [ ] **Step 3: Apply fixes (if any), run tests**

```bash
make test
```

Expected: all tests pass.

- [ ] **Step 4: Commit (if changes were made)**

```bash
git add lua/void-space/highlights/diagnostics.lua
git commit -m "fix(highlights/diagnostics): correct semantic color assignments"
```

If no changes needed, skip.

---

### Task 6: Visual validation

**Files:** no changes

This task validates all 5 modules visually in Neovim. Load the theme in each scenario and verify the expected appearance. Run `nvim` with the colorscheme active — in your normal Neovim config ensure `colorscheme void-space` is set, or run:

```bash
nvim --cmd "set rtp+=. | colorscheme void-space"
```

- [ ] **Step 1: Validate `editor.lua` groups**

Open any file in Neovim and verify:

| What to do | What to check |
|------------|---------------|
| Move the cursor around | `CursorLine` is one step lighter than the normal background (subtle, not jarring) |
| Look at line numbers | `LineNr` uses a dim gutter color; current line number is brighter |
| Press `/` and type a term | `Search` highlights show inverted (dark text on yellow bg); `IncSearch` is slightly brighter |
| Select text in visual mode | `Visual` selection is visible but not garish |
| Open a float (`:Telescope find_files` or any `vim.lsp.buf.hover()`) | Float has a slightly lighter background than the main buffer |
| Open a split (`:vs`) | `WinSeparator` is a dim line, not distracting |
| Introduce a deliberate typo | `SpellBad` shows undercurl in red |

- [ ] **Step 2: Validate `syntax.lua` groups**

Open a Lua or Python file:

| What to check | Expected color |
|---------------|---------------|
| Comments (`-- comment`) | Dim (`fg_dim`, typically muted blue-gray) |
| String literals (`"hello"`) | Green |
| Function names (definition) | Purple |
| Keywords (`if`, `for`, `return`) | Blue |
| Type names (in a typed language) | Cyan |
| Constants / numbers | Orange |
| Identifiers (variable names) | The color decided in Task 2 (either cyan or fg) |
| Exceptions (`try/catch`) | The color decided in Task 2 (consistent with treesitter) |

- [ ] **Step 3: Validate `treesitter.lua` groups**

Open a Lua file with Treesitter active (`:checkhealth nvim-treesitter` to confirm):

| What to check | Expected color |
|---------------|---------------|
| `@variable` (local vars) | `fg` (plain text, no special color) |
| `@variable.member` (table field access) | The color decided in Task 3 |
| `@function.builtin` (e.g. `print`, `require`) | Purple (builtin) |
| `@string.escape` (e.g. `\n`) | Yellow (special) |

Open a Markdown file (`.md`):

| What to check | Expected |
|---------------|---------|
| `# Heading 1` | Yellow, bold |
| `## Heading 2` | Blue, bold |
| `### Heading 3` | Cyan, bold |
| Bullet list items marker | The color decided in Task 3 |
| `[link text](url)` | Link text cyan-ish, URL blue with underline |
| `` `inline code` `` | Green (string_lit) |

- [ ] **Step 4: Validate `lsp.lua` groups**

Open a file in an LSP-active project (any LSP-enabled language):

| What to check | Expected |
|---------------|---------|
| Hover over a variable that LSP knows about | `LspReferenceText` highlights all references with a subtle `sel` background |
| A method being written to | `LspReferenceWrite` reference has `sel` bg + bold |
| Inlay hints (if LSP provides them) | Dim foreground, `bg_float` background, italic (or not, per the decision in Task 4) |
| Namespace / module identifier | Color per decision in Task 4 |

- [ ] **Step 5: Validate `diagnostics.lua` groups**

Open a file with LSP diagnostics active. Introduce errors if needed:

| What to check | Expected |
|---------------|---------|
| Error marker in sign column | Red |
| Warning marker in sign column | Yellow |
| Undercurl on an error | Red undercurl under the problematic text |
| Virtual text after an error line | Red text, subtle `bg_float` box |
| Hover on an error (`:lua vim.diagnostic.open_float()`) | Float shows error with red label |

- [ ] **Step 6: Final commit**

No code changes in this task. If visual validation revealed issues not caught by the audit, go back to the relevant task, apply the fix, run `make test`, commit, then return here.

Once satisfied with the visual result:

```bash
git commit --allow-empty -m "chore(highlights): core review complete — audit + visual validation passed"
```
