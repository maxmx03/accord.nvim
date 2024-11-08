require 'accord.highlights'
---@class state
local record = require 'accord.state'
local log = require 'accord.log'
local Storage = require 'accord.storage'
local api = vim.api
local fn = vim.fn
local uv = vim.uv
local set_extmark = api.nvim_buf_set_extmark
local del_extmark = api.nvim_buf_del_extmark

---@param value string
local is_empty = function(value)
  return value == nil or value == ''
end

---@class accord
local M = {}

M.config = {
  sign_text = '',
  sign_hl_group = 'AccordIcon',
}
M.ns_id = api.nvim_create_namespace 'zero'

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
  local line = cursor[1] - 1
  local col = 1
  local config = self.config
  ---@type vim.api.keyset.set_extmark
  local opts = {
    id = uv.now(),
    sign_text = config.sign_text,
    sign_hl_group = config.sign_hl_group,
    virt_text = { { text, 'AccordText' } },
    ui_watched = true,
    priority = 100,
  }
  local password = fn.expand '%:p'
  set_extmark(buffer, self.ns_id, line, col, opts)
  record.append {
    password = password,
    buffer = buffer,
    ns_id = self.ns_id,
    line = line,
    col = col,
    opts = opts,
  }
end

function M:set_buff_extmarks()
  local password = fn.expand '%:p'
  local records = record:get_pass_records(password)
  if vim.tbl_isempty(records) then
    return
  end
  for _, r in pairs(records) do
    if api.nvim_buf_is_valid(r.buffer) then
      set_extmark(r.buffer, r.ns_id, r.line, r.col, r.opts)
    end
  end
end

function M:delete_extmark()
  local password = fn.expand '%:p'
  local cursor = api.nvim_win_get_cursor(0)
  ---@type records
  local extmark = record:get_by_pos(cursor, password)
  if vim.tbl_isempty(extmark) then
    log.warning 'extmark not found'
    return
  end
  del_extmark(extmark.buffer, extmark.ns_id, extmark.opts.id)
  record:filter(extmark.opts.id, password)
end

function M:clean_extmarks()
  local storage = Storage:new { where = 'state', filename = 'accord' }
  storage:clean()
end

return M
