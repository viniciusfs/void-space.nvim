local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_sidebar = opts.transparent and c.none or c.bg

	hl.TroubleNormal = { fg = c.fg, bg = bg_sidebar }
	hl.TroubleNormalNC = { fg = c.fg_dim, bg = bg_sidebar }
	hl.TroubleCount = { fg = c.fg, bg = c.sel }
	hl.TroublePos = { fg = c.fg_dim }
	hl.TroubleSource = { fg = c.fg_dim }
	hl.TroubleText = { fg = c.fg }
	hl.TroubleDirectory = { fg = c.blue }
	hl.TroubleFile = { fg = c.blue }
	hl.TroubleCode = { fg = c.fg_dim }
	hl.TroubleIndent = { fg = c.sel }
	hl.TroublePreview = { bg = c.bg_float }

	hl.TroubleIconError = { fg = c.red }
	hl.TroubleIconWarn = { fg = c.yellow }
	hl.TroubleIconHint = { fg = c.cyan }
	hl.TroubleIconInfo = { fg = c.blue }
	hl.TroubleIconDirectory = { fg = c.blue }
	hl.TroubleIconFile = { fg = c.fg }

	hl.TroubleSignError = { link = "DiagnosticError" }
	hl.TroubleSignWarn = { link = "DiagnosticWarn" }
	hl.TroubleSignHint = { link = "DiagnosticHint" }
	hl.TroubleSignInfo = { link = "DiagnosticInfo" }

	hl.TroubleTextError = { link = "DiagnosticError" }
	hl.TroubleTextWarn = { link = "DiagnosticWarn" }
	hl.TroubleTextHint = { link = "DiagnosticHint" }
	hl.TroubleTextInfo = { link = "DiagnosticInfo" }

	return hl
end

return M
