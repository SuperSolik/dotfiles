require("conform").setup({
    notify_on_error = false,
    formatters_by_ft = {
        lua = { "stylua" },
        -- go = { "gofmt" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        c = { "clang_format" },
        cpp = { "clang_format" },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
        async = false,
    },
    formatters = {
        stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
    },
})
