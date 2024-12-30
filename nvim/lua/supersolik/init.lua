require("supersolik.set")
require("supersolik.lazy")
require("supersolik.remaps")
require("supersolik.theme")
require("supersolik.lsp")
require("supersolik.telescope")
require("supersolik.cmp")
require("supersolik.treesitter")
require("supersolik.utils")
require("supersolik.conform")
require("supersolik.oil")

-- no idea where to put it so let's just keep it here
-- NOTE: Alt + hjkl doesn't work with Ghostty because it supports native macOS text navigation stuff
-- so using Shift + hjkl instead from now on
require("mini.move").setup({
    mappings = {
        left = "<S-h>",
        right = "<S-l>",
        down = "<S-j>",
        up = "<S-k>",
    },
})

-- additional filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
    pattern = {
        ["Jenkinsfile.*"] = "groovy",
        ["Dockerfile.*"] = "dockerfile",
        ["Pipfile"] = "toml",
    },
})
