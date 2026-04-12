local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_float = opts.transparent and c.none or c.bg_float

	hl.NotifyBackground = { bg = bg_float }

	hl.NotifyERRORBorder = { fg = c.red }
	hl.NotifyERRORIcon = { fg = c.red }
	hl.NotifyERRORTitle = { fg = c.red, bold = true }
	hl.NotifyERRORBody = { fg = c.fg, bg = bg_float }

	hl.NotifyWARNBorder = { fg = c.yellow }
	hl.NotifyWARNIcon = { fg = c.yellow }
	hl.NotifyWARNTitle = { fg = c.yellow, bold = true }
	hl.NotifyWARNBody = { fg = c.fg, bg = bg_float }

	hl.NotifyINFOBorder = { fg = c.blue }
	hl.NotifyINFOIcon = { fg = c.blue }
	hl.NotifyINFOTitle = { fg = c.blue, bold = true }
	hl.NotifyINFOBody = { fg = c.fg, bg = bg_float }

	hl.NotifyDEBUGBorder = { fg = c.fg_dim }
	hl.NotifyDEBUGIcon = { fg = c.fg_dim }
	hl.NotifyDEBUGTitle = { fg = c.fg_dim, bold = true }
	hl.NotifyDEBUGBody = { fg = c.fg, bg = bg_float }

	hl.NotifyTRACEBorder = { fg = c.purple }
	hl.NotifyTRACEIcon = { fg = c.purple }
	hl.NotifyTRACETitle = { fg = c.purple, bold = true }
	hl.NotifyTRACEBody = { fg = c.fg, bg = bg_float }

	return hl
end

return M
