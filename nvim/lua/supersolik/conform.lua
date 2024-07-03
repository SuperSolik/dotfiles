require("conform").setup({
    notify_on_error = false,
    formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        json = { "prettier" },
        c = { "clang_format" },
        cpp = { "clang_format" },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    formatters = {
        stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
    },
})
