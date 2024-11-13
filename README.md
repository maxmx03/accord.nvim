# Accord.nvim

Write private comments using Neovim's extmark.

## Installation

`lazy.nvim`

```lua
return {
    'maxmx03/accord.nvim',
    opts = {
        sign_text = '',
        sign_hl_group = 'AccordIcon',
    }
}
```

`plug`

```vim
Plug 'maxmx03/accord.nvim'

lua << EOF
require 'accord'.setup({
    sign_text = '',
    sign_hl_group = 'AccordIcon',
    })
EOF
```

## Commands

```txt
AccordRecord // add extmark
AccordRemember // restore extmarks
AccordClean // delete extmarks
AccordDelete // delete extmark under the cursor
```

## Highlights

```txt
AccordText
AccordIcon
```

![latest 1](https://github.com/user-attachments/assets/16326d5c-e078-4be1-8035-84de44706739)
