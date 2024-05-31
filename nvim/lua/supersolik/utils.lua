local wrap_is_enabled = false

-- [[ toggle wrap on :ToggleWrap cmd  ]]
vim.api.nvim_create_user_command('ToggleWrap', function()
    wrap_is_enabled = not wrap_is_enabled
    vim.wo.wrap = wrap_is_enabled
    print('Toggling wrap to: ' .. tostring(wrap_is_enabled))
end, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
