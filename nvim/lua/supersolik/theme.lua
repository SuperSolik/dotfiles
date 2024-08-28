-- Theme config
-- require('rose-pine').setup({
--     variant = 'dawn',
--     dark_variant = 'dawn',
--     disable_background = false,
--     disable_float_background = false,
--     styles = {
--         italic = false
--     }
-- })
-- vim.cmd.colorscheme('rose-pine')

vim.o.background = "dark"

require("vscode").setup({
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = false,

    -- Enable italic comment
    italic_comments = false,

    -- Underline `@markup.link.*` variants
    underline_links = true,
})

vim.cmd.colorscheme("vscode")
