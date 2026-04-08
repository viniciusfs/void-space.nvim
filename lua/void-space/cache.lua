local M = {}

local function cache_dir()
  return vim.fn.stdpath("cache") .. "/void-space"
end

local function cache_key(opts)
  return string.format("%s_t%d_i%d%d_d%d",
    opts.variant,
    opts.transparent and 1 or 0,
    opts.italic_comments and 1 or 0,
    opts.italic_keywords and 1 or 0,
    opts.dim_inactive and 1 or 0
  )
end

---Return the cache file path for the given config options.
---@param opts table VoidSpaceConfig
---@return string
function M.path(opts)
  return cache_dir() .. "/" .. cache_key(opts) .. ".lua"
end

---Split a newline-separated string into a list of lines (pure Lua).
---@param s string
---@return string[]
local function split_lines(s)
  local result = {}
  for part in s:gmatch("[^\n]+") do
    table.insert(result, part)
  end
  return result
end

---Remove all cache files for this theme.
function M.clear()
  local pattern = cache_dir() .. "/*.lua"
  local matches = vim.fn.glob(pattern)
  if matches == "" then return end
  for _, file in ipairs(split_lines(matches)) do
    if file ~= "" then
      vim.fn.delete(file)
    end
  end
end

return M
