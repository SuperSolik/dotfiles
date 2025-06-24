return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
        lazy = false,
        keys = {
            { "-", "<CMD>Oil<CR>", desc = "Open parent folder" },
            {
                "<space>-",
                function()
                    require("oil").toggle_float()
                end,
                desc = "Toggle Oil float",
            },
        },
        opts = {
            default_file_explorer = true,
            columns = { "icon" },
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    -- Return true for files you still want to hide.
                    -- Example below shows absolutely everything,
                    -- including "." and ".." and ".git".
                    return false
                end,
            },
        },
    },
}
