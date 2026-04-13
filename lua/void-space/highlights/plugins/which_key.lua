local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware float background
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Core display: key, group heading, description, separator, value annotation
	hl.WhichKey = { fg = c.cyan }
	hl.WhichKeyGroup = { fg = c.blue }
	hl.WhichKeyDesc = { fg = c.fg }
	hl.WhichKeySeparator = { fg = c.fg_dim }
	hl.WhichKeyValue = { fg = c.green }
	-- Float container: background, border, title
	hl.WhichKeyFloat = { bg = bg_float }
	hl.WhichKeyBorder = { fg = c.sel, bg = bg_float }
	hl.WhichKeyTitle = { fg = c.yellow, bg = bg_float, bold = true }
	hl.WhichKeyNormal = { fg = c.fg, bg = bg_float }
	-- Explicit icon color groups — which-key uses these to tint icons by category
	hl.WhichKeyIcon = { fg = c.cyan }
	hl.WhichKeyIconBlue = { fg = c.blue }
	hl.WhichKeyIconCyan = { fg = c.cyan }
	hl.WhichKeyIconGreen = { fg = c.green }
	hl.WhichKeyIconGrey = { fg = c.fg_dim }
	hl.WhichKeyIconOrange = { fg = c.orange }
	hl.WhichKeyIconPurple = { fg = c.purple }
	hl.WhichKeyIconRed = { fg = c.red }
	hl.WhichKeyIconYellow = { fg = c.yellow }

	return hl
end

return M
