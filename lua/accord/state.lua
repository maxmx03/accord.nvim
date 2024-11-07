local au = vim.api.nvim_create_autocmd
---@type storage
local Storage = require 'accord.storage'
local storage = Storage:new { where = 'state', filename = 'accord' }

local M = {}

M.accords = {}

au('VimLeave', {
  callback = function()
    local state = require 'accord.state'
    storage:set(state.accords)
  end,
})

M.append = function(t)
  table.insert(M.accords, t)
end

return M
