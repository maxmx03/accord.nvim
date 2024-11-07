require 'accord.highlights'
local record = require 'accord.state'
local Storage = require 'accord.storage'
local api = vim.api
local fn = vim.fn
local uv = vim.uv
local set_extmark = api.nvim_buf_set_extmark

---@param value string
local is_empty = function(value)
  return value == nil or value == ''
end

---@class accord
local M = {}
M.ns_id = api.nvim_create_namespace 'zero'
M.password = fn.expand '%:p'
M.config = {
  sign_text = '',
  sign_hl_group = 'AccordIcon',
}

---@class accord.config
---@field sign_text string
---@field sign_hl_group string

---@param config accord.config
M.setup = function(config)
  M.config = vim.tbl_deep_extend('force', M.config, config or {})
end

---@param text string
function M:set_extmark(text)
  if is_empty(text) then
    return
  end
  local buffer = api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local col = cursor[2]
  local config = self.config
  ---@type vim.api.keyset.set_extmark
  local opts = {
    id = uv.now(),
    sign_text = config.sign_text,
    sign_hl_group = config.sign_hl_group,
    virt_text = { { text, 'AccordText' } },
    ui_watched = true,
  }
  set_extmark(buffer, self.ns_id, line, col, opts)
  record.append {
    password = self.password,
    buffer = buffer,
    ns_id = self.ns_id,
    line = line,
    col = col,
    opts = opts,
  }
end

function M:get_extmarks()
  local storage = Storage:new { where = 'state', filename = 'accord' }
  local records = storage:get_by_password(self.password)

  for _, r in pairs(records) do
    if r and not vim.tbl_isempty(r) then
      record.append(r)
      set_extmark(r.buffer, r.ns_id, r.line, r.col, r.opts)
    end
  end
end

function M:clean_extmarks()
  local storage = Storage:new { where = 'state', filename = 'accord' }
  storage:clean()
end

return M
