return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
        lazy = false,
        config = function()
            require("oil").setup({
                columns = { "icon" },
                view_options = {
                    show_hidden = true,
                },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent folder" })
            vim.keymap.set("n", "<space>-", require("oil").toggle_float)
        end,
    },
}
