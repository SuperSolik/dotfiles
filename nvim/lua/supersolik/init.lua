require('supersolik.set')
require('supersolik.lazy')
require('supersolik.remaps')
require('supersolik.theme')
require('supersolik.lsp')
require('supersolik.telescope')
require('supersolik.cmp')
require('supersolik.treesitter')
require('supersolik.utils')

-- no idea where to put it so let's just keep it here
require('mini.move'):setup()

-- additional filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
    pattern = {
        ['Jenkinsfile.*'] = 'groovy',
        ['Dockerfile.*'] = 'dockerfile'
    }
})
