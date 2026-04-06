local M = {}

function M.get(c, opts)
	local hl = {}

	hl.RenderMarkdownH1 = { fg = c.yellow, bg = c.bg_float, bold = true }
	hl.RenderMarkdownH2 = { fg = c.blue, bg = c.bg_float, bold = true }
	hl.RenderMarkdownH3 = { fg = c.cyan, bg = c.bg_float, bold = true }
	hl.RenderMarkdownH4 = { fg = c.green, bg = c.bg_float, bold = true }
	hl.RenderMarkdownH5 = { fg = c.orange, bg = c.bg_float, bold = true }
	hl.RenderMarkdownH6 = { fg = c.purple, bg = c.bg_float, bold = true }
	hl.RenderMarkdownH1Bg = { bg = c.bg_float }
	hl.RenderMarkdownH2Bg = { bg = c.bg_float }
	hl.RenderMarkdownH3Bg = { bg = c.bg_float }
	hl.RenderMarkdownH4Bg = { bg = c.bg_float }
	hl.RenderMarkdownH5Bg = { bg = c.bg_float }
	hl.RenderMarkdownH6Bg = { bg = c.bg_float }
	hl.RenderMarkdownCode = { bg = c.bg_float }
	hl.RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_float }
	hl.RenderMarkdownBullet = { fg = c.red }
	hl.RenderMarkdownQuote = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.RenderMarkdownDash = { fg = c.sel }
	hl.RenderMarkdownLink = { fg = c.blue, underline = true }
	hl.RenderMarkdownChecked = { fg = c.green }
	hl.RenderMarkdownUnchecked = { fg = c.fg_dim }
	hl.RenderMarkdownTableHead = { fg = c.yellow, bold = true }
	hl.RenderMarkdownTableRow = { fg = c.fg }
	hl.RenderMarkdownTableFill = { fg = c.sel }

	return hl
end

return M
