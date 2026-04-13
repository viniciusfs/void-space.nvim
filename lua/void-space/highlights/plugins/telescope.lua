local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware float background shared by prompt and results panels
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Overall float body and results panel
	hl.TelescopeNormal = { fg = c.fg, bg = bg_float }
	hl.TelescopeBorder = { fg = c.sel, bg = bg_float }
	-- Prompt panel (input area) — same bg_float as results
	hl.TelescopePromptNormal = { fg = c.fg, bg = bg_float }
	-- Blue border anchors the input area visually
	hl.TelescopePromptBorder = { fg = c.blue, bg = bg_float }
	-- Title bars: inverted (dark text on colored background)
	hl.TelescopePromptTitle = { fg = c.bg, bg = c.blue, bold = true }
	hl.TelescopePromptPrefix = { fg = c.cyan, bg = bg_float }
	hl.TelescopePromptCounter = { fg = c.fg_dim, bg = bg_float }
	-- Results list
	hl.TelescopeResultsNormal = { fg = c.fg, bg = bg_float }
	hl.TelescopeResultsBorder = { fg = c.blue, bg = bg_float }
	hl.TelescopeResultsTitle = { fg = c.bg, bg = c.blue, bold = true }
	-- Preview pane — intentionally darker (bg_dark) than the other panels
	hl.TelescopePreviewNormal = { fg = c.fg, bg = c.bg_dark }
	hl.TelescopePreviewBorder = { fg = c.bg_dark, bg = c.bg_dark }
	hl.TelescopePreviewTitle = { fg = c.bg, bg = c.cyan, bold = true }
	-- Selection and match highlighting
	hl.TelescopeSelection = { fg = c.fg, bg = c.sel }
	hl.TelescopeSelectionCaret = { fg = c.cyan, bg = c.sel }
	hl.TelescopeMultiSelection = { fg = c.purple, bg = c.sel }
	-- Matched characters are yellow + bold (highest contrast signal)
	hl.TelescopeMatching = { fg = c.yellow, bold = true }

	return hl
end

return M
