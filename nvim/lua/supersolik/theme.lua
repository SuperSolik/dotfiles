-- Theme config
require('rose-pine').setup({
    variant = 'main',
    dark_variant = 'main',
    disable_background = true,
    disable_float_background = true,
    styles = {
        italic = false
    }
})

vim.cmd.colorscheme('rose-pine')
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
