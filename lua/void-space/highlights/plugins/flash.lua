local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware float background for the prompt line
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Background dimming and jump label badges (inverted: dark text on accent bg)
	hl.FlashBackdrop = { fg = c.fg_dim }
	hl.FlashLabel = { fg = c.bg, bg = c.pink, bold = true }
	hl.FlashMatch = { fg = c.bg, bg = c.yellow }
	hl.FlashCurrent = { fg = c.bg, bg = c.orange, bold = true }
	hl.FlashCursor = { fg = c.bg, bg = c.cyan }
	-- Prompt line (inline command input at bottom)
	hl.FlashPrompt = { fg = c.fg, bg = bg_float }
	hl.FlashPromptIcon = { fg = c.cyan, bg = bg_float }

	return hl
end

return M
