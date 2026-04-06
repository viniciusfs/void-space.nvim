local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_float = opts.transparent and c.none or c.bg_float

	hl.TelescopeNormal = { fg = c.fg, bg = bg_float }
	hl.TelescopeBorder = { fg = c.sel, bg = bg_float }
	hl.TelescopePromptNormal = { fg = c.fg, bg = c.bg_float }
	hl.TelescopePromptBorder = { fg = c.blue, bg = c.bg_float }
	hl.TelescopePromptTitle = { fg = c.bg, bg = c.blue, bold = true }
	hl.TelescopePromptPrefix = { fg = c.cyan, bg = c.bg_float }
	hl.TelescopePromptCounter = { fg = c.fg_dim, bg = c.bg_float }
	hl.TelescopeResultsNormal = { fg = c.fg, bg = bg_float }
	hl.TelescopeResultsBorder = { fg = c.blue, bg = bg_float }
	hl.TelescopeResultsTitle = { fg = c.bg, bg = c.blue, bold = true }
	hl.TelescopePreviewNormal = { fg = c.fg, bg = c.bg_dark }
	hl.TelescopePreviewBorder = { fg = c.bg_dark, bg = c.bg_dark }
	hl.TelescopePreviewTitle = { fg = c.bg, bg = c.cyan, bold = true }
	hl.TelescopeSelection = { fg = c.fg, bg = c.sel }
	hl.TelescopeSelectionCaret = { fg = c.cyan, bg = c.sel }
	hl.TelescopeMultiSelection = { fg = c.purple, bg = c.sel }
	hl.TelescopeMatching = { fg = c.yellow, bold = true }

	return hl
end

return M
