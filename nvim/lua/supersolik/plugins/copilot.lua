return {
    {
        "github/copilot.vim",
        config = function()
            -- disable copilot tab mapping and use Ctrl-Tab to accept suggestions
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<leader>cp", 'copilot#Accept("")', { expr = true, replace_keycodes = false })
        end,
    },
}
