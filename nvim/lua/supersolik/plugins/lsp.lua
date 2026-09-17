-- [[ Configure LSP ]]

return {
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            -- Mason must be loaded before its dependents so we need to set it up here.
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },

            -- Allows extra capabilities provided by blink.cmp
            "saghen/blink.cmp",
        },
        config = function()
            local log_path = vim.lsp.log.get_filename()
            local log = vim.uv.fs_stat(log_path)
            if log and log.size > 10 * 1024 * 1024 then
                vim.fn.writefile({}, log_path)
            end

            local highlight_group = vim.api.nvim_create_augroup("supersolik-lsp-highlight", { clear = true })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("supersolik-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

                    map("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("<leader>gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    map("<leader>gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    -- See `:help K` for why this keymap
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

                    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
                    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
                    map("<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, "[W]orkspace [L]ist Folders")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client:supports_method(
                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
                            event.buf
                        )
                    then
                        vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })

                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_group,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_group,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end

                    if
                        client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                    then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("supersolik-lsp-detach", { clear = true }),
                callback = function(event)
                    vim.schedule(function()
                        local supports_highlight = vim.iter(vim.lsp.get_clients({ bufnr = event.buf })):any(function(client)
                            return client:supports_method(
                                vim.lsp.protocol.Methods.textDocument_documentHighlight,
                                event.buf
                            )
                        end)
                        if not supports_highlight then
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
                        end
                    end)
                end,
            })

            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                },
                virtual_lines = true,
                virtual_text = false,
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local servers = {
                ts_ls = {},
                clangd = {},
                ty = {},
                ruff = {},
                terraformls = {},
                dockerls = {},
                -- NOTE: enable if needed
                gopls = {},
                -- templ = {},
                -- arduino_language_server = {},
                -- html = { filetypes = { "html" } },
                -- jdtls = {},

                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },
            }

            local ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
                "pinact",
                -- Formatters
                "clang-format",
                "prettier",
                "sqlfmt",
                "stylua",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {},
                automatic_enable = false,
            })

            for server_name, server in pairs(servers) do
                server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                vim.lsp.config(server_name, server)
                vim.lsp.enable(server_name)
            end
        end,
    },
}
