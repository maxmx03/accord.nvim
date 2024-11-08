local cmd = vim.api.nvim_create_user_command
---@type accord
local accord = require 'accord'

cmd('AccordRecord', function()
  vim.ui.input({ prompt = 'Enter comment' }, function(text)
    if text == nil or text == '' then
      return
    end
    accord:set_extmark(text)
  end)
end, {})

cmd('AccordRemember', function()
  accord:set_buff_extmarks()
end, {})

cmd('AccordClean', function()
  accord:clean_extmarks()
end, {})

cmd('AccordDelete', function()
  accord:delete_extmark()
end, {})
