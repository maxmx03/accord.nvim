local api = vim.api
local hl = api.nvim_set_hl
local ns_id = 0
local text = api.nvim_get_hl(ns_id, { name = 'AccordText' })
local icon = api.nvim_get_hl(ns_id, { name = 'AccordIcon' })

if vim.tbl_isempty(icon) then
  hl(ns_id, 'AccordIcon', { link = 'Keyword' })
end
if vim.tbl_isempty(text) then
  hl(ns_id, 'AccordText', { link = 'Comment' })
end
