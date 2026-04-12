local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_float = opts.transparent and c.none or c.bg_float

	hl.FlashBackdrop = { fg = c.fg_dim }
	hl.FlashLabel = { fg = c.bg, bg = c.pink, bold = true }
	hl.FlashMatch = { fg = c.bg, bg = c.yellow }
	hl.FlashCurrent = { fg = c.bg, bg = c.orange, bold = true }
	hl.FlashCursor = { fg = c.bg, bg = c.cyan }
	hl.FlashPrompt = { fg = c.fg, bg = bg_float }
	hl.FlashPromptIcon = { fg = c.cyan, bg = bg_float }

	return hl
end

return M
