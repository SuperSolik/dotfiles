require("oil").setup({
    columns = { "icon" },
    view_options = {
        show_hidden = true,
    },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent folder" })
vim.keymap.set("n", "<space>-", require("oil").toggle_float)
