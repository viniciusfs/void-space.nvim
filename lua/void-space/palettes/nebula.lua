-- void-space: nebula palette variant

local M = {}

-- ------------
-- Named colors from htmlcsscolor.com
-- ------------
local _blackrussian = "#080C1A" -- black russian variant
local _midnight_express = "#0D1530" -- midnight express
local _lucky_point = "#1C2550" -- lucky point
local _deep_koamaru = "#2A2D6A" -- deep koamaru
local _governor_bay = "#4A4F8A" -- governor bay
local _royal_blue = "#3A6AD4" -- royal blue
local _cornflower_blue = "#5B8EF0" -- cornflower blue
local _maya_blue = "#78C8F0" -- maya blue
local _lavender = "#DDE4FF" -- lavender
local _echo_blue = "#A8B4D8" -- echo blue
local _wild_watermelon = "#F05070" -- wild watermelon
local _pale_goldenrod = "#F0E8A8" -- pale goldenrod
local _lightning_yellow = "#F0A830" -- lightning yellow
local _purple_heart = "#7B3FBF" -- purple heart
local _dark_orchid = "#A53DB8" -- dark orchid
local _medium_orchid = "#C847D9" -- medium orchid
local _free_speech_magenta = "#E060C8" -- free speech magenta
local _heliotrope = "#C87EFF" -- heliotrope
local _green = "#709d6c"

-- -------------------------
-- Semantic color
-- -------------------------
-- Backgrounds & Foregrounds
M.bg_dark = _blackrussian
M.bg = _midnight_express
M.bg_float = _lucky_point
M.sel = _deep_koamaru
M.fg = _lavender
M.fg_dim = _echo_blue

-- Accent colors
M.red = _wild_watermelon
M.green = _maya_blue
M.yellow = _pale_goldenrod
M.blue = _royal_blue
M.cyan = _maya_blue
M.purple = _purple_heart
M.orange = _lightning_yellow
M.pink = _free_speech_magenta
M.bright_yellow = _pale_goldenrod

-- Syntax roles
M.comment = _governor_bay
M.keyword = _cornflower_blue
M.func = _maya_blue
M.type_name = _dark_orchid
M.string_lit = _green
M.constant = _pale_goldenrod
M.operator = _heliotrope
M.type = M.orange
M.builtin = M.blue
M.special = M.cyan

-- Diagnostics
M.error = _wild_watermelon
M.warning = _lightning_yellow
M.info = _cornflower_blue
M.hint = _maya_blue

M.none = "NONE"

return M
