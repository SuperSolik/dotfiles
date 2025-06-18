require("remaps")
require("set")
require("lazy-plugins")
require("theme")
require("utils")

-- additional filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
    pattern = {
        ["[jJ]enkinsfile.*"] = "groovy",
        [".*[jJ]enkinsfile"] = "groovy",
        ["[dD]ockerfile.*"] = "dockerfile",
        ["Pipfile"] = "toml",
    },
})
