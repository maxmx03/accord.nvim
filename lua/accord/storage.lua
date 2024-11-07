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
---@field buffer number
---@field ns_id number
---@field line number
---@field col number
---@field opts vim.api.keyset.set_extmark

---@param records records[]
function M:set(records)
  local old_data = self:get_all()
  local data = vim.tbl_deep_extend('force', old_data, records)
  local arg1 = vim.json.encode(data)
  local ok, err = pcall(fn.writefile, { arg1 }, self.location)
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
