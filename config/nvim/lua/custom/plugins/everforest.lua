local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'sainnhe/everforest' }

vim.g.everforest_background = 'hard'

-- Colorscheme is set by token.lua; uncomment below to use everforest instead.
-- vim.o.background = 'dark'
-- vim.cmd.colorscheme 'everforest'
