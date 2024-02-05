local wrap_is_enabled = false

vim.api.nvim_create_user_command('WrapToggle', function()
    wrap_is_enabled = not wrap_is_enabled
    vim.wo.wrap = wrap_is_enabled
    print('Toggling wrap to: ' .. tostring(wrap_is_enabled))
end, {})
