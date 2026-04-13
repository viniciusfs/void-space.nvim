local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_float = opts.transparent and c.none or c.bg_float

	-- Notification float base background
	hl.NotifyBackground = { bg = bg_float }

	-- ERROR level: red (c.error)
	hl.NotifyERRORBorder = { fg = c.red }
	hl.NotifyERRORIcon = { fg = c.red }
	hl.NotifyERRORTitle = { fg = c.red, bold = true }
	hl.NotifyERRORBody = { fg = c.fg, bg = bg_float }

	-- WARN level: yellow (c.warning)
	hl.NotifyWARNBorder = { fg = c.yellow }
	hl.NotifyWARNIcon = { fg = c.yellow }
	hl.NotifyWARNTitle = { fg = c.yellow, bold = true }
	hl.NotifyWARNBody = { fg = c.fg, bg = bg_float }

	-- INFO level: cyan (c.info) — consistent with DiagnosticInfo
	hl.NotifyINFOBorder = { fg = c.info }
	hl.NotifyINFOIcon = { fg = c.info }
	hl.NotifyINFOTitle = { fg = c.info, bold = true }
	hl.NotifyINFOBody = { fg = c.fg, bg = bg_float }

	-- DEBUG level: dim (no severity role)
	hl.NotifyDEBUGBorder = { fg = c.fg_dim }
	hl.NotifyDEBUGIcon = { fg = c.fg_dim }
	hl.NotifyDEBUGTitle = { fg = c.fg_dim, bold = true }
	hl.NotifyDEBUGBody = { fg = c.fg, bg = bg_float }

	-- TRACE level: purple (c.hint)
	hl.NotifyTRACEBorder = { fg = c.purple }
	hl.NotifyTRACEIcon = { fg = c.purple }
	hl.NotifyTRACETitle = { fg = c.purple, bold = true }
	hl.NotifyTRACEBody = { fg = c.fg, bg = bg_float }

	return hl
end

return M
