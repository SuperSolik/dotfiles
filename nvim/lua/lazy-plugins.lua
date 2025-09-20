-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- NOTE: First, some plugins that don't require any configuration

    -- Git related plugins
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",

    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",

    -- work with parens, quotes
    "tpope/vim-surround",

    -- case insensitive search-and-replace and more
    "tpope/vim-abolish",

    require("supersolik.plugins.cmp"),
    require("supersolik.plugins.telescope"),
    require("supersolik.plugins.lsp"),
    require("supersolik.plugins.treesitter"),
    require("supersolik.plugins.oil"),
    require("supersolik.plugins.conform"),

    { "Mofiqul/vscode.nvim" },
    {
        -- Set lualine as statusline
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },

    -- move selected text
    {
        "echasnovski/mini.move",
        version = "*",
        opts = {
            mappings = {
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
            },
        },
    },

    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    require("supersolik.plugins.copilot"),
}, {})
