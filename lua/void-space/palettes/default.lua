-- void-space: default palette (deep-space inspired)

local M = {}

-- ------------
-- Named colors from htmlcsscolor.com
-- ------------
local _black_russian1 = "#141820"
local _black_russian2 = "#1a1f28"
local _midnight_express = "#232936"
local _cloud_brust = "#323c4d"
local _chambray = "#52627f"
local _rock_blue = "#99a7be"
local _tapestry = "#c68b8f"
local _amulet = "#94b592"
local _barley_corn = "#b39b64"
local _danube = "#618bc2"
local _lilac_bush = "#9e87c5"
local _fountain_blue = "#59abb4"
local _medium_wood = "#ba8873"
local _orchid = "#c47ec4"
local _putty = "#d5ad75"

-- -------------------------
-- Semantic color
-- -------------------------
-- Backgrounds & Foregrounds
M.bg_dark = _black_russian1
M.bg = _black_russian2
M.bg_float = _midnight_express
M.sel = _cloud_brust
M.fg_dim = _chambray
M.fg = _rock_blue

-- Accent colors
M.green = _amulet
M.yellow = _barley_corn
M.red = _tapestry
M.purple = _lilac_bush
M.blue = _danube
M.cyan = _fountain_blue
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

return M
