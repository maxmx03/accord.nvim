local levels = vim.log.levels

---@class log
local M = {}

---@param msg string
M.error = function(msg)
  if type(msg) == 'string' then
    msg = 'Accord: ' .. msg
    vim.notify(msg, levels.ERROR)
  end
end

---@param msg string
M.warning = function(msg)
  if type(msg) == 'string' then
    msg = 'Accord: ' .. msg
    vim.notify(msg, levels.WARN)
  end
end

return M
