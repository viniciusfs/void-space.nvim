local M = {}

function M.get(c, opts)
	local hl = {}

	-- Base diagnostic colors — used by virtual text, signs, and floats via links.
	hl.DiagnosticError = { fg = c.error }
	hl.DiagnosticWarn = { fg = c.warning }
	hl.DiagnosticInfo = { fg = c.info }
	hl.DiagnosticHint = { fg = c.hint }
	hl.DiagnosticOk = { fg = c.green }

	-- Undercurl — sp sets the color of the wavy underline; no fg/bg override.
	hl.DiagnosticUnderlineError = { sp = c.error, undercurl = true }
	hl.DiagnosticUnderlineWarn = { sp = c.warning, undercurl = true }
	hl.DiagnosticUnderlineInfo = { sp = c.info, undercurl = true }
	hl.DiagnosticUnderlineHint = { sp = c.hint, undercurl = true }
	hl.DiagnosticUnderlineOk = { sp = c.green, undercurl = true }

	-- Virtual text — bg=bg_float creates a subtle box at one lightness step above bg.
	hl.DiagnosticVirtualTextError = { fg = c.error, bg = c.bg_float }
	hl.DiagnosticVirtualTextWarn = { fg = c.warning, bg = c.bg_float }
	hl.DiagnosticVirtualTextInfo = { fg = c.info, bg = c.bg_float }
	hl.DiagnosticVirtualTextHint = { fg = c.hint, bg = c.bg_float }
	hl.DiagnosticVirtualTextOk = { fg = c.green, bg = c.bg_float }

	-- Floating diagnostics — link to base colors, no bg override.
	hl.DiagnosticFloatingError = { link = "DiagnosticError" }
	hl.DiagnosticFloatingWarn = { link = "DiagnosticWarn" }
	hl.DiagnosticFloatingInfo = { link = "DiagnosticInfo" }
	hl.DiagnosticFloatingHint = { link = "DiagnosticHint" }

	-- Sign column — link to base colors.
	hl.DiagnosticSignError = { link = "DiagnosticError" }
	hl.DiagnosticSignWarn = { link = "DiagnosticWarn" }
	hl.DiagnosticSignInfo = { link = "DiagnosticInfo" }
	hl.DiagnosticSignHint = { link = "DiagnosticHint" }

	return hl
end

return M
