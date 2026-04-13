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
| `TelescopePreviewNormal` | fg: fg, bg: bg_dark | Preview pane is darker than prompt/results |
| `TelescopePreviewBorder` | fg: bg_dark, bg: bg_dark | Preview border blends into the preview background (invisible) |
| `TelescopeSelection` | fg: fg, bg: sel | Selected result uses the selection background |
| `TelescopeMatching` | fg: yellow, bold | Fuzzy-match characters are yellow and bold |
| `TelescopeMultiSelection` | fg: purple, bg: sel | Multi-selected items show purple text |

**How to validate:** Open `:Telescope find_files`. Check that prompt and results share the same background (`bg_float`). Check preview is visibly darker. Type to see yellow match characters.

---

### neo_tree

File-explorer sidebar panel. The sidebar background is transparent-aware; the preview float and tab bar use separate locals.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `NeoTreeNormal` | fg: fg, bg: bg (transparent-aware) | Sidebar body matches normal buffer background |
| `NeoTreeRootName` | fg: blue, bold | Root directory entry is blue and bold |
| `NeoTreeDirectoryName` | fg: blue | All directory names are blue |
| `NeoTreeFileNameOpened` | fg: yellow | Currently open file is highlighted yellow |
| `NeoTreeModified` | fg: yellow | Unsaved-change indicator |
| `NeoTreeSymbolicLinkTarget` | fg: cyan | Symlink targets use the type color |
| `NeoTreeGitAdded` | fg: green | File newly added to the index |
| `NeoTreeGitModified` | fg: yellow | Tracked file with unstaged changes |
| `NeoTreeGitDeleted` | fg: red | Tracked file deleted from the index |
| `NeoTreeGitConflict` | fg: red, bold | Merge conflict — red and bold for urgency |
| `NeoTreeGitUntracked` | fg: orange | Untracked file — orange distinguishes from ignored (fg_dim) |
| `NeoTreeGitIgnored` | fg: fg_dim | Gitignored file — dim, lowest visual weight |
| `NeoTreeTitleBar` | fg: bg, bg: blue, bold | Panel title: inverted (dark text on blue) |
| `NeoTreeTabActive` | fg: fg, bg: sel, bold | Active neo-tree tab — full text on selection background |
| `NeoTreeTabInactive` | fg: fg_dim, bg: bg (transparent-aware) | Inactive tab — dim text on sidebar background |

**How to validate:** Open neo-tree in a git repository. Check directory/file colors, git status indicators. Verify that untracked (orange) is visually distinct from ignored (dim).

---

### noice

Replaces the built-in cmdline, message, and popup surfaces. Float-based surfaces use `bg_float`; the popupmenu uses `sel` (always visible).

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `NoiceCmdline` | fg: fg, bg: bg (transparent-aware) | Command-line background |
| `NoiceCmdlineIcon` | fg: cyan | `:` command icon |
| `NoiceCmdlineIconSearch` | fg: yellow | `/` search icon |
| `NoiceCmdlinePopupBorder` | fg: sel, bg: bg_float | Float border is dim (low visual weight) |
| `NoiceConfirmBorder` | fg: yellow | Confirm dialog border is yellow (action prompt) |
| `NoiceMini` | fg: fg, bg: bg_float (transparent-aware) | Mini notification bar uses the float background |
| `NoicePopupmenuSelected` | fg: bg, bg: blue | Selected menu item: inverted dark text on blue |
| `NoicePopupmenuMatch` | fg: yellow, bold | Fuzzy-match characters are yellow |
| `NoiceLspProgressSpinner` | fg: cyan | LSP operation progress spinner |
| `NoiceFormatProgressDone` | fg: green | Completed progress step |

**How to validate:** Press `:` to open the command line (cyan icon, float border appears). Press `/` to search (yellow icon). Trigger an LSP operation to see progress. In transparent mode, float backgrounds disappear.

---

### notify

Notification popups grouped by severity. All severity levels share the same body spec; border, icon, and title follow the diagnostic color system.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `NotifyBackground` | bg: bg_float (transparent-aware) | Base float background |
| `NotifyERRORBorder` | fg: red | Error notification border — matches `DiagnosticError` |
| `NotifyERRORTitle` | fg: red, bold | Error title |
| `NotifyERRORBody` | fg: fg, bg: bg_float (transparent-aware) | Error notification body |
| `NotifyWARNBorder` | fg: yellow | Warning border — matches `DiagnosticWarn` |
| `NotifyINFOBorder` | fg: info (cyan) | Info border — matches `DiagnosticInfo` |
| `NotifyINFOTitle` | fg: info (cyan), bold | Info title — uses `c.info` (cyan), not the unrelated `c.blue` |
| `NotifyDEBUGBorder` | fg: fg_dim | Debug notifications are dim — no semantic severity color |
| `NotifyTRACEBorder` | fg: purple | Trace border uses the hint color (lowest diagnostic severity) |

**How to validate:** Run `:lua vim.notify("test", vim.log.levels.ERROR)` for each level. Verify ERROR=red, WARN=yellow, INFO=cyan, DEBUG=dim, TRACE=purple. INFO was previously blue — cyan is the correct `c.info` mapping.

---

### snacks

Multi-purpose plugin covering picker, notifier, dashboard, indent guides, scrollbar, git graph, and more. Transparent-aware on float surfaces; preview pane and backdrop are intentionally always opaque.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `SnacksBackdrop` | bg: bg_dark | Modal backdrop — always darkest layer (intentionally opaque) |
| `SnacksPickerNormal` | fg: fg, bg: bg_float (transparent-aware) | Picker float body |
| `SnacksPickerBorder` | fg: blue, bg: bg_float | Picker border is blue |
| `SnacksPickerTitle` | fg: bg, bg: blue, bold | Picker title: inverted (dark text on blue) |
| `SnacksPickerInput` | fg: fg, bg: bg_float (transparent-aware) | Input pane — same float background as the list |
| `SnacksPickerInputBorder` | fg: blue, bg: bg_float (transparent-aware) | Input pane border |
| `SnacksPickerPreview` | fg: fg, bg: bg_dark | Preview pane — always darker (not transparent-aware, matches telescope preview) |
| `SnacksPickerPreviewBorder` | fg: bg_dark, bg: bg_dark | Preview border blends into preview background (invisible) |
| `SnacksPickerMatch` | fg: yellow, bold | Fuzzy-match characters are yellow |
| `SnacksPickerSelected` | fg: purple | Multi-selected items show purple text |
| `SnacksNotifierBorderError` | fg: red | Error notification border |
| `SnacksNotifierBorderInfo` | fg: blue | Info notification border |
| `SnacksNotifierNormal` | fg: fg, bg: bg_float (transparent-aware) | Notification body |
| `SnacksDashboardHeader` | fg: blue | Dashboard header text |
| `SnacksDashboardTitle` | fg: yellow, bold | Dashboard section titles |
| `SnacksDashboardFooter` | fg: fg_dim, italic (opts) | Footer text; italic follows `opts.italic_comments` |
| `SnacksDashboardKey` | fg: cyan | Dashboard action keybind labels |
| `SnacksInputNormal` | fg: fg, bg: bg_float (transparent-aware) | Input widget body |
| `SnacksInputBorder` | fg: yellow, bg: bg_float (transparent-aware) | Input widget border (yellow = action prompt) |
| `SnacksTermTitle` | fg: bg, bg: orange, bold | Terminal float title: inverted on orange |
| `SnacksIndent` | fg: sel | Indent guide lines use the selection color (dim but visible) |
| `SnacksIndentScope` | fg: fg_dim | Active scope line is slightly brighter than guide lines |

**How to validate:** Open the snacks picker — verify input pane matches body background. Open the dashboard — verify header/title/footer/key colors. Trigger a notification for each severity. In transparent mode: picker body, input pane, and notification body become transparent; preview pane and backdrop remain opaque.

---

### which_key

Popup float listing available keybindings for the current prefix. Float surfaces are transparent-aware.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `WhichKeyFloat` | bg: bg_float (transparent-aware) | Float body background one step lighter than `bg` |
| `WhichKeyBorder` | fg: sel, bg: bg_float | Float border is dim (low visual weight) |
| `WhichKeyTitle` | fg: yellow, bg: bg_float, bold | Title bar: yellow text, bold |
| `WhichKey` | fg: cyan | Key label characters are cyan |
| `WhichKeyGroup` | fg: blue | Group prefix labels are blue (structural keyword role) |
| `WhichKeyDesc` | fg: fg | Key descriptions are plain text |
| `WhichKeySeparator` | fg: fg_dim | Separator character is dim |
| `WhichKeyValue` | fg: green | Value annotations (e.g. current option state) are green |
| `WhichKeyIconRed` | fg: red | Icon color group for red-tinted icons — explicit color, not a diagnostic role |

**How to validate:** Press `<leader>` (or any mapped prefix) and wait for the popup. Verify key=cyan, group=blue, descriptions=plain, title=yellow. In transparent mode, the float background disappears.

---

### illuminate

Highlights all occurrences of the word under the cursor. Uses the selection accent background — no float or opaque surfaces.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `IlluminatedWordText` | bg: sel | Generic text reference — subtle background tint |
| `IlluminatedWordRead` | bg: sel | Read access — same tint as text (distinguishable by user override if desired) |
| `IlluminatedWordWrite` | bg: sel, bold | Write access — same tint but bold to signal mutation |

**How to validate:** Open a source file, place cursor on a variable name. All occurrences should get a background tint matching `Visual`. The occurrence under a write (assignment) should additionally be bold.

---

### trouble

Diagnostic list panel (sidebar). Transparent-aware on both the panel background and the preview float overlay. Icon colors must match the core `DiagnosticX` groups.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `TroubleNormal` | fg: fg, bg: bg (transparent-aware) | Panel body matches normal buffer background |
| `TroubleNormalNC` | fg: fg_dim, bg: bg (transparent-aware) | Non-current panel state — dim text |
| `TroubleCount` | fg: fg, bg: sel | Diagnostic count badge: plain text on selection background |
| `TroubleDirectory` | fg: blue | Directory path entries — structural blue |
| `TroubleFile` | fg: blue | File name entries — structural blue |
| `TroubleIndent` | fg: sel | Indent guide lines — selection color, dim |
| `TroublePreview` | bg: bg_float (transparent-aware) | Preview overlay — float background |
| `TroubleIconError` | fg: red | Error icon — matches `DiagnosticError` |
| `TroubleIconWarn` | fg: yellow | Warn icon — matches `DiagnosticWarn` |
| `TroubleIconInfo` | fg: info (cyan) | Info icon — matches `DiagnosticInfo` (was `c.blue` before fix) |
| `TroubleIconHint` | fg: hint (purple) | Hint icon — matches `DiagnosticHint` (was `c.cyan` before fix) |
| `TroubleSignError` | link: DiagnosticError | Sign column — delegates to core diagnostic group |
| `TroubleTextError` | link: DiagnosticError | Inline text — delegates to core diagnostic group |

**How to validate:** Open `:Trouble diagnostics`. Verify error icon=red, warn=yellow, info=cyan, hint=purple — all consistent with the gutter diagnostic signs. Check that the preview overlay uses `bg_float`. In transparent mode, panel background and preview float become transparent.

---

### todo_comments

Highlights `TODO`, `FIX`, `NOTE`, and similar comment keywords. Two display styles: badge (inverted background) and foreground (colored text). Sign column links to the foreground style.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `TodoBgFIX` | fg: bg, bg: red, bold | FIX badge — dark text on red, bold |
| `TodoBgHACK` | fg: bg, bg: yellow, bold | HACK badge — dark text on yellow |
| `TodoBgNOTE` | fg: bg, bg: cyan, bold | NOTE badge — dark text on cyan |
| `TodoBgPERF` | fg: bg, bg: purple, bold | PERF badge — dark text on purple |
| `TodoBgTEST` | fg: bg, bg: pink, bold | TEST badge — dark text on pink |
| `TodoBgTODO` | fg: bg, bg: blue, bold | TODO badge — dark text on blue |
| `TodoBgWARN` | fg: bg, bg: orange, bold | WARN badge — dark text on orange (distinct from HACK yellow) |
| `TodoFgFIX` | fg: red | FIX foreground — red text for critical issues |
| `TodoFgNOTE` | fg: cyan | NOTE foreground — info/cyan role |
| `TodoFgTODO` | fg: blue | TODO foreground — keyword/action blue |
| `TodoSignFIX` | link: TodoFgFIX | Sign column — links to foreground color group |

**How to validate:** Open a file with `-- TODO:`, `-- FIX:`, `-- NOTE:`, `-- WARN:`, `-- HACK:`, `-- PERF:`, `-- TEST:` comments. In badge mode (`:TodoTrouble` or virtual text): each keyword shows dark text on its category color, bold. In foreground mode (sign column): matches the foreground color. Verify FIX=red, HACK=yellow, NOTE=cyan, PERF=purple, TEST=pink, TODO=blue, WARN=orange.

---

### indent

Indent guide lines for indent-blankline.nvim. Supports both v3 (`Ibl*`) and v2 legacy (`IndentBlankline*`) API groups. No backgrounds — foreground-only.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `IblIndent` | fg: sel | Guide lines are dim `sel` — barely visible, not distracting |
| `IblScope` | fg: fg_dim | Active scope line is slightly brighter than guide lines |
| `IndentBlanklineChar` | fg: sel | v2 equivalent of `IblIndent` |
| `IndentBlanklineContextChar` | fg: fg_dim | v2 equivalent of `IblScope` |
| `IndentBlanklineContextStart` | sp: fg_dim, underline | v2 scope start marker — underline in `fg_dim` color |
| `IndentBlanklineSpaceChar` | link: Whitespace | Delegates to built-in whitespace group |

**How to validate:** Open a file with nested code. Indent guide lines should be barely perceptible (`sel` color). The active block's guide should be slightly brighter (`fg_dim`).

---

### flash

Jump-navigation overlay for flash.nvim. Uses the inverted badge pattern (dark text on accent background) for all label/match groups. The prompt line is `bg_float`-based and transparent-aware.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `FlashBackdrop` | fg: fg_dim | Non-jump text is dimmed during navigation |
| `FlashLabel` | fg: bg, bg: pink, bold | Primary jump label — dark text on pink, bold (high contrast) |
| `FlashMatch` | fg: bg, bg: yellow | Search match characters — dark on yellow |
| `FlashCurrent` | fg: bg, bg: orange, bold | Currently selected match — dark on orange, bold |
| `FlashCursor` | fg: bg, bg: cyan | Cursor position highlight — dark on cyan |
| `FlashPrompt` | fg: fg, bg: bg_float (transparent-aware) | Prompt line background |
| `FlashPromptIcon` | fg: cyan, bg: bg_float (transparent-aware) | Prompt icon — cyan on float background |

**How to validate:** Trigger flash (e.g. `s` key). Backdrop should dim background text. Jump labels should be bold pink badges. Current match should be orange. In transparent mode, the prompt background becomes transparent while badges remain visible.

---

### fidget

LSP progress spinner in the corner. Two groups covering title and task description.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `FidgetTitle` | fg: yellow, bold | Spinner title (e.g. "rust-analyzer") — yellow and bold for visibility |
| `FidgetTask` | fg: fg_dim | In-progress task description — dim to avoid distraction |

**How to validate:** Open a file with an active LSP server. The spinner title should be yellow and bold; the task text below it should be dim.

---

### mini

Highlights for mini.nvim modules. Covers animate, clue, completion, cursorword, deps, diff, files, hipatterns, icons, indentscope, jump, map, notify, operator, pick, starter, statusline, surround, tabline, test, and trailspace. Float surfaces are transparent-aware; the minimap is intentionally always dark.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `MiniCursorword` | bg: sel | Word under cursor — same selection tint as `Visual` |
| `MiniDepsHint` | fg: hint (purple) | Deps log hint level — matches `DiagnosticHint` |
| `MiniDepsInfo` | fg: info (cyan) | Deps log info level — matches `DiagnosticInfo` |
| `MiniDepsChangeAdded` | fg: green | Package added |
| `MiniDepsChangeRemoved` | fg: red | Package removed |
| `MiniDiffSignAdd` | fg: green, bg: bg (transparent-aware) | Diff add sign in gutter |
| `MiniDiffOverAdd` | bg: bg_float (transparent-aware) | Diff added-line overlay in buffer |
| `MiniFilesBorder` | fg: sel, bg: bg_float | Files browser border — dim |
| `MiniFilesTitle` | fg: yellow, bg: bg_float, bold | Files browser title |
| `MiniFilesTitleFocused` | fg: bright_yellow, bg: bg_float, bold | Files browser focused pane title — brighter yellow |
| `MiniHipatternsFixme` | fg: bg, bg: red, bold | FIXME badge — dark text on red |
| `MiniHipatternsNote` | fg: bg, bg: cyan, bold | NOTE badge — dark text on cyan |
| `MiniJump2dSpot` | fg: bg, bg: pink, bold | Jump2d primary spot — dark on pink, bold |
| `MiniMapNormal` | fg: fg_dim, bg: bg_dark | Minimap sidebar — intentionally always dark (not transparent-aware) |
| `MiniNotifyNormal` | fg: fg, bg: bg_float (transparent-aware) | Notification float body |
| `MiniNotifyTitle` | fg: yellow, bg: bg_float, bold | Notification title |
| `MiniPickNormal` | fg: fg, bg: bg_float (transparent-aware) | Picker float body |
| `MiniPickHeader` | fg: bg, bg: blue, bold | Picker header — inverted on blue |
| `MiniPickMatchRanges` | fg: yellow, bold | Fuzzy-match characters |
| `MiniPickMatchMarked` | bg: bg_float (transparent-aware), bold | Marked items — float background |
| `MiniPickPreviewLine` | bg: bg_float (transparent-aware) | Preview line — float background |
| `MiniStarterHeader` | fg: blue | Starter screen header |
| `MiniStarterFooter` | fg: fg_dim, italic (opts) | Footer — italic follows `opts.italic_comments` |
| `MiniStatuslineModeNormal` | fg: bg, bg: blue, bold | Normal mode pill — inverted on blue |
| `MiniStatuslineModeInsert` | fg: bg, bg: green, bold | Insert mode pill — inverted on green |
| `MiniStatuslineModeVisual` | fg: bg, bg: purple, bold | Visual mode pill — inverted on purple |
| `MiniStatuslineFilename` | fg: fg, bg: bg_float (transparent-aware) | Filename section background |
| `MiniStatuslineInactive` | fg: fg_dim, bg: bg_float (transparent-aware) | Inactive window statusline |
| `MiniTablineCurrent` | fg: fg, bg: bg (transparent-aware), bold | Active buffer tab — normal buffer background |
| `MiniTablineFill` | bg: bg_float (transparent-aware) | Tabline fill area |
| `MiniTablineHidden` | fg: fg_dim, bg: bg_float | Hidden (non-visible) buffer tab |
| `MiniTablineTabpagesection` | fg: bg, bg: blue, bold | Tab pages indicator — inverted on blue |
| `MiniTrailspace` | bg: red | Trailing whitespace — red background for visibility |

**How to validate:** Trigger each mini.nvim submodule in turn. Key checks: deps log uses cyan for info and purple for hint; diff overlays and picker preview are transparent in transparent mode; statusline mode pills are inverted; tabline current tab uses buffer background (not float background).
