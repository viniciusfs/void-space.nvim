local M = {}

function M.get(c, opts)
	local hl = {}

	-- LSP progress spinner: title (yellow/bold) and task description (dim)
	hl.FidgetTitle = { fg = c.yellow, bold = true }
	hl.FidgetTask = { fg = c.fg_dim }

	return hl
end

return M
