local M = {}

local function cache_dir()
  return vim.fn.stdpath("cache") .. "/void-space"
end

-- Variant names must not contain the separator tokens (_t, _i, _d followed by digits).
-- In practice this is safe since variants are controlled internal strings (e.g. "default", "nebula").
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
    vim.fn.delete(file)
  end
end

local function serialize(hl)
  local lines = { "-- void-space cache -- gerado automaticamente, nao editar", "return {" }
  for group, spec in pairs(hl) do
    lines[#lines + 1] = string.format("  [%q] = {", group)
    for k, v in pairs(spec) do
      if type(v) == "string" then
        lines[#lines + 1] = string.format("    %s = %q,", k, v)
      elseif type(v) == "boolean" then
        lines[#lines + 1] = string.format("    %s = %s,", k, tostring(v))
      end
    end
    lines[#lines + 1] = "  },"
  end
  lines[#lines + 1] = "}"
  return table.concat(lines, "\n")
end

---Serialize highlights table to disk.
---@param opts table VoidSpaceConfig
---@param highlights table group → spec
function M.save(opts, highlights)
  local path = M.path(opts)
  vim.fn.mkdir(cache_dir(), "p")
  local f = io.open(path, "w")
  if not f then return end
  f:write(serialize(highlights))
  f:close()
end

---Load cached highlights from disk. Returns nil if cache miss.
---@param opts table VoidSpaceConfig
---@return table|nil
function M.load(opts)
  local path = M.path(opts)
  local f = io.open(path, "r")
  if not f then return nil end
  f:close()
  local ok, result = pcall(dofile, path)
  if ok and type(result) == "table" then
    return result
  end
  return nil
end

return M
