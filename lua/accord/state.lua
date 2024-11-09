-- local log = require 'accord.log'

---@class state
local M = {}

---@type records[]
M.records = {}

M.append = function(t)
  table.insert(M.records, t)
end

---@param pos integer[]
---@param password string
function M:get_by_pos(pos, password)
  local extmark = {}
  local line = pos[1] - 1
  for _, record in ipairs(self.records) do
    if record.line == line and record.password == password then
      extmark = record
    end
  end
  return extmark
end

---@param id number
function M:filter(id)
  M.records = vim.tbl_filter(function(record)
    return record.opts.id ~= id
  end, M.records)
end

---@param password string
---@return records[]
function M:get_pass_records(password)
  local records = vim.deepcopy(M.records)
  records = vim.tbl_filter(function(record)
    return record.password == password
  end, records)
  return records
end

return M
