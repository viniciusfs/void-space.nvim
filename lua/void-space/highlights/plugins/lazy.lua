local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware float background
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Float chrome and action buttons
	hl.LazyNormal = { fg = c.fg, bg = bg_float }
	hl.LazyButton = { fg = c.fg, bg = c.sel }
	hl.LazyButtonActive = { fg = c.bg, bg = c.blue, bold = true }
	hl.LazyH1 = { link = "LazyButtonActive" }
	-- Section headings
	hl.LazyH2 = { fg = c.yellow, bold = true }
	-- Commit log: hash, type, scope, issue, comments
	hl.LazyComment = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.LazyCommit = { fg = c.green }
	hl.LazyCommitType = { fg = c.blue }
	hl.LazyCommitScope = { fg = c.purple }
	hl.LazyCommitIssue = { fg = c.red }
	-- Plugin metadata: path, URL, local, special
	hl.LazyDir = { fg = c.blue }
	hl.LazyUrl = { fg = c.cyan, underline = true }
	hl.LazyLocal = { fg = c.orange }
	hl.LazySpecial = { fg = c.cyan }
	-- Plugin properties and values
	hl.LazyProp = { fg = c.fg_dim }
	hl.LazyValue = { fg = c.green }
	-- Load condition indicator
	hl.LazyNoCond = { fg = c.fg_dim }
	-- Load reasons (why the plugin was loaded)
	hl.LazyReasonCmd = { fg = c.orange }
	hl.LazyReasonEvent = { fg = c.purple }
	hl.LazyReasonFt = { fg = c.blue }
	hl.LazyReasonImport = { fg = c.cyan }
	hl.LazyReasonKeys = { fg = c.yellow }
	hl.LazyReasonPlugin = { fg = c.pink }
	hl.LazyReasonRequire = { fg = c.orange }
	hl.LazyReasonRuntime = { fg = c.red }
	hl.LazyReasonSource = { fg = c.cyan }
	hl.LazyReasonSpec = { fg = c.yellow }
	hl.LazyReasonStart = { fg = c.green }
	-- Progress and task output
	hl.LazyProgressDone = { fg = c.green, bold = true }
	hl.LazyProgressTodo = { fg = c.fg_dim }
	hl.LazyTaskOutput = { fg = c.fg }
	hl.LazyTaskError = { fg = c.red }

	return hl
end

return M
