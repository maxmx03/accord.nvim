local au = vim.api.nvim_create_autocmd

au('VimEnter', {
  callback = function()
    ---@type storage
    local Storage = require 'accord.storage'
    local storage = Storage:new { where = 'state', filename = 'accord' }
    local state = require 'accord.state'
    local records = storage:get_all()
    state.accords = records
  end,
})

au('VimLeave', {
  callback = function()
    ---@type storage
    local Storage = require 'accord.storage'
    local storage = Storage:new { where = 'state', filename = 'accord' }
    local state = require 'accord.state'
    storage:set(state.accords)
  end,
})
