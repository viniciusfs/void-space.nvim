local M = {}

function M.get(c, opts)
	local hl = {}

	hl.TodoBgFIX = { fg = c.bg, bg = c.red, bold = true }
	hl.TodoBgHACK = { fg = c.bg, bg = c.yellow, bold = true }
	hl.TodoBgNOTE = { fg = c.bg, bg = c.cyan, bold = true }
	hl.TodoBgPERF = { fg = c.bg, bg = c.purple, bold = true }
	hl.TodoBgTEST = { fg = c.bg, bg = c.pink, bold = true }
	hl.TodoBgTODO = { fg = c.bg, bg = c.blue, bold = true }
	hl.TodoBgWARN = { fg = c.bg, bg = c.orange, bold = true }

	hl.TodoFgFIX = { fg = c.red }
	hl.TodoFgHACK = { fg = c.yellow }
	hl.TodoFgNOTE = { fg = c.cyan }
	hl.TodoFgPERF = { fg = c.purple }
	hl.TodoFgTEST = { fg = c.pink }
	hl.TodoFgTODO = { fg = c.blue }
	hl.TodoFgWARN = { fg = c.orange }

	hl.TodoSignFIX = { link = "TodoFgFIX" }
	hl.TodoSignHACK = { link = "TodoFgHACK" }
	hl.TodoSignNOTE = { link = "TodoFgNOTE" }
	hl.TodoSignPERF = { link = "TodoFgPERF" }
	hl.TodoSignTEST = { link = "TodoFgTEST" }
	hl.TodoSignTODO = { link = "TodoFgTODO" }
	hl.TodoSignWARN = { link = "TodoFgWARN" }

	return hl
end

return M
