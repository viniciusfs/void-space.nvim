local M = {}

function M.get(c, opts)
	local hl = {}

	-- Header, footer, and body text
	hl.DashboardHeader = { fg = c.blue }
	hl.DashboardFooter = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.DashboardDesc = { fg = c.fg }
	hl.DashboardKey = { fg = c.cyan }
	hl.DashboardIcon = { fg = c.blue }
	hl.DashboardFiles = { fg = c.fg }
	hl.DashboardShortcut = { fg = c.cyan }
	hl.DashboardShortCutIcon = { fg = c.cyan }
	-- Section titles and project entries
	hl.DashboardProjectTitle = { fg = c.yellow, bold = true }
	hl.DashboardProjectTitleIcon = { fg = c.yellow }
	hl.DashboardMruTitle = { fg = c.yellow, bold = true }
	hl.DashboardRecentProjects = { fg = c.blue }

	return hl
end

return M
