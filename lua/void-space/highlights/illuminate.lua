local M = {}

function M.get(c, opts)
	local hl = {}

	hl.IlluminatedWordText = { bg = c.sel }
	hl.IlluminatedWordRead = { bg = c.sel }
	hl.IlluminatedWordWrite = { bg = c.sel, bold = true }

	return hl
end

return M
