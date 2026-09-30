local languages = {
    "c",
    "cpp",
    "go",
    "lua",
    "python",
    "rust",
    "vimdoc",
    "vim",
    "bash",
    "html",
    "templ",
    "sql",
    "typescript",
    "javascript",
    "json",
    "toml",
    "yaml",
    "terraform",
}

local function map_select(key, query)
    vim.keymap.set({ "x", "o" }, key, function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end)
end

local function map_move(key, method, query)
    vim.keymap.set({ "n", "x", "o" }, key, function()
        require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
    end)
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()
            require("nvim-treesitter").install(languages)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = languages,
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
                config = function()
                    require("nvim-treesitter-textobjects").setup({
                        select = { lookahead = true },
                        move = { set_jumps = true },
                    })

                    map_select("aa", "@parameter.outer")
                    map_select("ia", "@parameter.inner")
                    map_select("af", "@function.outer")
                    map_select("if", "@function.inner")
                    map_select("ac", "@class.outer")
                    map_select("ic", "@class.inner")

                    map_move("]m", "goto_next_start", "@function.outer")
                    map_move("]]", "goto_next_start", "@class.outer")
                    map_move("]M", "goto_next_end", "@function.outer")
                    map_move("][", "goto_next_end", "@class.outer")
                    map_move("[m", "goto_previous_start", "@function.outer")
                    map_move("[[", "goto_previous_start", "@class.outer")
                    map_move("[M", "goto_previous_end", "@function.outer")
                    map_move("[]", "goto_previous_end", "@class.outer")

                    vim.keymap.set("n", "<leader>a", function()
                        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                    end)
                    vim.keymap.set("n", "<leader>A", function()
                        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
                    end)
                end,
            },
        },
    },
}
