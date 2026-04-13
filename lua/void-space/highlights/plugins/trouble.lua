local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware backgrounds: sidebar for the panel, float for the preview overlay
	local bg_sidebar = opts.transparent and c.none or c.bg
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Panel chrome (main window and non-focused cursor state)
	hl.TroubleNormal = { fg = c.fg, bg = bg_sidebar }
	hl.TroubleNormalNC = { fg = c.fg_dim, bg = bg_sidebar }
	-- Metadata: diagnostic counts, positions, sources, indentation
	hl.TroubleCount = { fg = c.fg, bg = c.sel }
	hl.TroublePos = { fg = c.fg_dim }
	hl.TroubleSource = { fg = c.fg_dim }
	hl.TroubleText = { fg = c.fg }
	-- File tree entries (directory and file paths use blue = structural)
	hl.TroubleDirectory = { fg = c.blue }
	hl.TroubleFile = { fg = c.blue }
	hl.TroubleCode = { fg = c.fg_dim }
	hl.TroubleIndent = { fg = c.sel }
	hl.TroublePreview = { bg = bg_float }

	-- Severity icons — must match corresponding DiagnosticX colors
	hl.TroubleIconError = { fg = c.red }
	hl.TroubleIconWarn = { fg = c.yellow }
	hl.TroubleIconHint = { fg = c.hint }
	hl.TroubleIconInfo = { fg = c.info }
	hl.TroubleIconDirectory = { fg = c.blue }
	hl.TroubleIconFile = { fg = c.fg }

	-- Severity signs and text — link to core diagnostic groups for consistency
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
