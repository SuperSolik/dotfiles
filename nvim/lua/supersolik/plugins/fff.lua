return {
    "dmtrKovalenko/fff",
    build = function()
        require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
        enable_home_dir_scanning = false,
    },
    keys = {
        {
            "<leader>sf",
            function()
                require("fff").find_files()
            end,
            desc = "[S]earch [F]iles",
        },
        {
            "<leader>sg",
            function()
                require("fff").live_grep()
            end,
            desc = "[S]earch by [G]rep",
        },
        {
            "<leader>sw",
            function()
                require("fff").live_grep_under_cursor()
            end,
            mode = { "n", "x" },
            desc = "[S]earch current [W]ord or selection",
        },
    },
}
