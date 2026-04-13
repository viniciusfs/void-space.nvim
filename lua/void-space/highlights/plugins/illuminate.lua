local M = {}

function M.get(c, opts)
	local hl = {}

	-- Word references under cursor: text/read use sel bg; write usage adds bold
	hl.IlluminatedWordText = { bg = c.sel }
	hl.IlluminatedWordRead = { bg = c.sel }
	hl.IlluminatedWordWrite = { bg = c.sel, bold = true }

	return hl
end

return M
