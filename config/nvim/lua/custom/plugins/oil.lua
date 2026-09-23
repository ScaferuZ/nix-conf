local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add { gh 'stevearc/oil.nvim' }
if vim.g.have_nerd_font then
  vim.pack.add { gh 'nvim-tree/nvim-web-devicons' }
end

require('oil').setup {
  columns = { 'icon' },
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-k>'] = false,
    ['<C-j>'] = false,
    ['<M-h>'] = 'actions.select_split',
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      local folder_skip = { 'dev-tools.locks', 'dune.lock', '_build' }
      return vim.tbl_contains(folder_skip, name)
    end,
  },
}

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<space>-', require('oil').toggle_float)
