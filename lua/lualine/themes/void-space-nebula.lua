-- Lualine theme for void-space (nebula variant)
-- Loaded automatically when lualine is configured with theme = 'void-space-nebula'

local c = require("void-space.palette").get("nebula")

local vs = {}

vs.normal = {
	a = { fg = c.bg, bg = c.blue, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.insert = {
	a = { fg = c.bg, bg = c.green, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.visual = {
	a = { fg = c.bg, bg = c.purple, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.replace = {
	a = { fg = c.bg, bg = c.red, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.command = {
	a = { fg = c.bg, bg = c.yellow, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.terminal = {
	a = { fg = c.bg, bg = c.cyan, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.inactive = {
	a = { fg = c.fg_dim, bg = c.bg_float },
	b = { fg = c.fg_dim, bg = c.bg_float },
	c = { fg = c.fg_dim, bg = c.bg_float },
}

return vs
