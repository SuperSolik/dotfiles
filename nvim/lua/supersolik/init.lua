require('supersolik.set')
require('supersolik.lazy')
require('supersolik.remaps')
require('supersolik.theme')
require('supersolik.lsp')
require('supersolik.telescope')
require('supersolik.cmp')
require('supersolik.treesitter')

-- no idea where to put it so let's just keep it here
require('mini.move'):setup()

-- additional filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
