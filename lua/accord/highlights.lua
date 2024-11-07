local hl = vim.api.nvim_set_hl

local colors = {
  dark = '#f5eccf',
  light = '#a9a083',
}
local background = vim.o.background
hl(0, 'AccordIcon', { fg = colors[background] })
hl(0, 'AccordText', { link = 'AccordIcon' })
