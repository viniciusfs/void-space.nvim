local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_normal = opts.transparent and c.none or c.bg
	local bg_float = opts.transparent and c.none or c.bg_float
	local bg_sidebar = opts.transparent and c.none or c.bg

	-- Normal buffers & floats
	hl.Normal = { fg = c.fg, bg = bg_normal }
	hl.NormalNC = opts.dim_inactive and { fg = c.fg_dim, bg = c.bg_dark } or { link = "Normal" }
	hl.NormalFloat = { fg = c.fg, bg = bg_float }
	hl.FloatBorder = { fg = c.sel, bg = bg_float }
	hl.FloatTitle = { fg = c.yellow, bg = bg_float, bold = true }
	hl.FloatFooter = { fg = c.fg_dim, bg = bg_float }

	-- Cursor & current line
	hl.ColorColumn = { bg = c.sel }
	hl.Conceal = { fg = c.fg_dim }
	hl.Cursor = { fg = c.bg_float, bg = c.fg }
	hl.lCursor = { link = "Cursor" }
	hl.CursorIM = { link = "Cursor" }
	hl.CursorColumn = { bg = c.bg_float }
	hl.CursorLine = { bg = c.bg_float }
	hl.CursorLineNr = { fg = c.fg, bg = c.bg_float }
	hl.CursorLineFold = { link = "CursorLine" }
	hl.CursorLineSign = { link = "CursorLine" }

	-- File tree & navigation
	hl.Directory = { fg = c.blue }
	hl.EndOfBuffer = { fg = c.sel }

	-- Messages & prompts
	hl.ErrorMsg = { fg = c.red, bg = bg_normal, bold = true }
	hl.WarningMsg = { fg = c.yellow }
	hl.ModeMsg = { fg = c.green }
	hl.MoreMsg = { fg = c.green }
	hl.Question = { fg = c.green }

	-- Folds
	hl.FoldColumn = { fg = c.cyan, bg = bg_sidebar }
	hl.Folded = { fg = c.fg_dim, bg = bg_sidebar }

	-- Line numbers
	hl.LineNr = { fg = c.sel }
	hl.LineNrAbove = { link = "LineNr" }
	hl.LineNrBelow = { link = "LineNr" }

	-- Matching
	-- MatchParen uses fg=bg_float (a background color) so the matched character is
	-- readable on the pink highlight background (inverted rendering pattern).
	hl.MatchParen = { fg = c.bg_float, bg = c.pink, bold = true }

	-- Command line & message area
	hl.MsgArea = { fg = c.fg, bg = bg_normal }
	hl.MsgSeparator = { fg = c.fg_dim, bg = c.bg_float }

	-- Non-text characters
	hl.NonText = { fg = c.fg_dim }
	hl.SpecialKey = { fg = c.fg_dim }
	hl.Whitespace = { fg = c.sel }

	-- Completion menu (Pmenu)
	hl.Pmenu = { fg = c.fg, bg = c.sel }
	hl.PmenuSel = { fg = c.bg_float, bg = c.blue, bold = true }
	hl.PmenuKind = { fg = c.cyan, bg = c.sel }
	hl.PmenuKindSel = { fg = c.bg, bg = c.blue }
	hl.PmenuExtra = { fg = c.fg_dim, bg = c.sel }
	hl.PmenuExtraSel = { fg = c.bg_float, bg = c.blue }
	hl.PmenuSbar = { bg = c.sel }
	hl.PmenuThumb = { bg = c.fg }

	-- Search
	-- Search/IncSearch use fg=bg (inverted) to show dark text on a colored highlight.
	hl.Search = { fg = c.bg, bg = c.yellow }
	hl.IncSearch = { fg = c.bg, bg = c.bright_yellow, bold = true }
	hl.CurSearch = { link = "IncSearch" }
	hl.Substitute = { fg = c.bg, bg = c.orange }

	-- Gutter & splits
	hl.SignColumn = { fg = c.fg_dim, bg = bg_sidebar }
	hl.VertSplit = { fg = c.sel, bg = bg_normal }
	hl.WinSeparator = { fg = c.sel, bg = bg_normal }

	-- Spell checking
	hl.SpellBad = { sp = c.red, undercurl = true }
	hl.SpellCap = { sp = c.blue, undercurl = true }
	hl.SpellLocal = { sp = c.cyan, undercurl = true }
	hl.SpellRare = { sp = c.purple, undercurl = true }

	-- Status line & tab line
	hl.StatusLine = { fg = c.fg, bg = c.sel }
	hl.StatusLineNC = { fg = c.fg_dim, bg = c.bg_float }
	hl.StatusLineTerm = { link = "StatusLine" }

	hl.TabLine = { fg = c.fg_dim, bg = c.bg }
	hl.TabLineFill = { bg = c.bg_float }
	hl.TabLineSel = { fg = c.fg, bg = c.sel, bold = true }

	-- Titles & visual selection
	hl.Title = { fg = c.yellow, bold = true }
	hl.Visual = { fg = c.fg, bg = c.sel }
	hl.VisualNOS = { link = "Visual" }

	-- Window bar
	hl.WildMenu = { fg = c.bg_float, bg = c.blue }
	hl.WinBar = { fg = c.fg, bg = bg_normal }
	hl.WinBarNC = { fg = c.fg_dim, bg = bg_normal }

	-- Quickfix
	hl.QuickFixLine = { bg = c.bg_float, bold = true }

	-- Diff (block) — inverted: fg=bg so text is readable on a colored background
	hl.DiffAdd = { fg = c.bg, bg = c.green }
	hl.DiffChange = { fg = c.bg, bg = c.yellow }
	hl.DiffDelete = { fg = c.bg, bg = c.red }
	hl.DiffText = { fg = c.bg, bg = c.blue }

	-- Diff (inline) — fg only, no background, for inline diff views
	hl.diffAdded = { fg = c.green }
	hl.diffRemoved = { fg = c.red }
	hl.diffChanged = { fg = c.yellow }
	hl.diffOldFile = { fg = c.orange }
	hl.diffNewFile = { fg = c.green }
	hl.diffFile = { fg = c.blue }
	hl.diffLine = { fg = c.fg_dim }
	hl.diffIndexLine = { fg = c.purple }

	return hl
end

return M
