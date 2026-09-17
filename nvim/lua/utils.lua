-- [[ toggle wrap on :ToggleWrap cmd  ]]
vim.api.nvim_create_user_command("ToggleWrap", function()
    vim.wo.wrap = not vim.wo.wrap
    print("Toggling wrap to: " .. tostring(vim.wo.wrap))
end, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})
