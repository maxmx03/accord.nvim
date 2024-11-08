-- local log = require 'accord.log'

---@class state
local M = {}

---@type records[]
M.accords = {}

M.append = function(t)
  table.insert(M.accords, t)
end

---@param pos integer[]
---@param password string
function M:get_by_pos(pos, password)
  local extmark = {}
  for _, accord in ipairs(self.accords) do
    if accord.line == pos[1] and accord.password == password then
      extmark = accord
    end
  end
  return extmark
end

---@param id number
---@param password string
function M:filter(id, password)
  local accords = vim.deepcopy(M.accords)
  M.accords = vim.tbl_filter(function(accord)
    return accord.opts.id ~= id and accord.password == password
  end, accords)
end

---@param password string
---@return records[]
function M:get_pass_records(password)
  local accords = vim.deepcopy(M.accords)
  M.accords = vim.tbl_filter(function(accord)
    return accord.password == password
  end, accords)
  return accords
end

return M
