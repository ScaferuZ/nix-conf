local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  {
    src = gh 'ThorstenRhau/token',
    version = vim.version.range '*',
  },
}

require('token').setup {
  plugins = {
    gitsigns = true,
  },
}

vim.o.background = 'light'
vim.cmd.colorscheme 'token-flint'
