local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { { src = gh 'obsidian-nvim/obsidian.nvim', version = vim.version.range '*' } }

require('obsidian').setup {
  -- TODO: Replace '~/Documents/Obsidian' with your actual vault path
  workspaces = {
    {
      name = 'personal',
      path = '~/Documents/obsidian-notes',
    },
  },

  picker = {
    name = 'telescope.nvim',
  },

  legacy_commands = false,

  note_id_func = function(title)
    local suffix = ''
    if title ~= nil then
      suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. '-' .. suffix
  end,

  ui = {
    enable = true,
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = 'nc'
  end,
})

vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Obsidian [b]acklinks' })
vim.keymap.set('n', '<leader>od', '<cmd>Obsidian today<CR>', { desc = 'Obsidian [d]aily note' })
vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian links<CR>', { desc = 'Obsidian [l]inks' })
vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian open<CR>', { desc = '[O]pen in Obsidian app' })
vim.keymap.set('n', '<leader>oq', '<cmd>Obsidian quick_switch<CR>', { desc = 'Obsidian [q]uick switch' })
vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = 'Obsidian [s]earch' })
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian template<CR>', { desc = 'Obsidian [t]emplate' })
vim.keymap.set('n', '<leader>oT', '<cmd>Obsidian toc<CR>', { desc = 'Obsidian [T]OC' })
