-- void-space: default palette (deep-space inspired)

local M = {}

-- ------------
-- Named colors from htmlcsscolor.com
-- ------------
local _black_russian1 = "#141820"
local _black_russian2 = "#1a1f28"
local _midnight_express = "#232936"
local _cloud_brust = "#323c4d"
local _waikawa_gray = "#5f7090"
local _rock_blue = "#99a7be"
local _tapestry = "#c68b8f"
local _envy = "#8fb98c"
local _barley_corn = "#b39b64"
local _danube = "#618bc2"
local _cold_purple = "#9b88d0"
local _pelorous = "#4ab5c4"
local _medium_wood = "#ba8873"
local _orchid = "#cc7dd0"
local _putty = "#d5ad75"

-- -------------------------
-- Semantic color
-- -------------------------
-- Backgrounds & Foregrounds
M.bg_dark = _black_russian1
M.bg = _black_russian2
M.bg_float = _midnight_express
M.sel = _cloud_brust
M.fg_dim = _waikawa_gray
M.fg = _rock_blue

-- Accent colors
M.green = _envy
M.yellow = _barley_corn
M.red = _tapestry
M.purple = _cold_purple
M.blue = _danube
M.cyan = _pelorous
M.pink = _orchid
M.orange = _medium_wood

M.bright_yellow = _putty

-- Syntax roles
M.comment = M.fg_dim
M.keyword = M.blue
M.func = M.purple
M.type_name = M.cyan
M.string_lit = M.green
M.constant = M.orange
M.operator = M.fg
M.type = M.cyan
M.builtin = M.purple
M.special = M.yellow

-- Diagnostics
M.error = M.red
M.warning = M.yellow
M.info = M.cyan
M.hint = M.purple

M.none = "NONE"
M.bg_inverted = M.bg

return M
