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
| `Identifier` | fg | Variable names — plain text color (no special weight) |
| `Exception` | keyword (blue) | Exception keywords match treesitter `@keyword.exception` |
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
| `@variable.member` | fg | Object property access is plain text (no type color) |
| `@function` | func (purple) | Function names at definition and call |
| `@function.builtin` | builtin (purple) | `print`, `require`, `len` etc. |
| `@keyword` | keyword (blue) | All keyword subtypes default to blue |
| `@keyword.exception` | keyword (blue) | Consistent with `Exception` in syntax.lua |
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
| `@lsp.type.namespace` | type (cyan) | Namespaces are cyan — consistent with `@module` in treesitter |
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
