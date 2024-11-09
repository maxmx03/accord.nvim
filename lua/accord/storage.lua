---@type log
local log = require 'accord.log'
local fn = vim.fn
---@type storage

---@class storage
---@field location string
local M = {}

---@class storage.new
---@field where 'cache' | 'config' | 'state' | 'data'
---@field filename string

---@param config storage.new
---@return storage
function M:new(config)
  local stdpath = fn.stdpath(config.where)
  ---@type storage
  local t = {
    location = string.format('%s/%s', stdpath, config.filename .. '.json'),
  }
  setmetatable(t, M)
  self.__index = self
  return t
end

---@class records
---@field password string
---@field ns_id number
---@field line number
---@field col number
---@field opts vim.api.keyset.set_extmark

---@param records records[]
function M:set(records)
  if vim.tbl_isempty(records) then
    return
  end
  local data = vim.json.encode(records)
  local ok, err = pcall(fn.writefile, { data }, self.location)
  if not ok then
    log.error(err)
  end
end

function M:clean()
  pcall(fn.writefile, {}, self.location)
end

function M:get_all()
  local ok, data = pcall(fn.readfile, self.location)
  if not ok then
    log.error "can't readfile"
  end
  if data[1] == nil then
    return {}
  end
  data = vim.json.decode(data[1])
  return data
end

---@param id number
function M:filter(id)
  local data = vim.tbl_filter(function(record)
    return record.opts.id ~= id
  end, self:get_all())
  if vim.tbl_isempty(data) then
    self:clean()
    return
  end
  self:set(data)
end

---@param password string
---@return records[]
function M:get_by_password(password)
  local ok, data = pcall(fn.readfile, self.location)
  if not ok then
    log.error "can't readfile"
  end
  data = vim.json.decode(data[1])
  local records = vim.tbl_filter(function(value)
    return value.password == password
  end, data)
  return records
end

return M
