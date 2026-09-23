-- Jupyter notebook (.ipynb) support: molten-nvim (execution) + jupytext (open
-- .ipynb as editable text) + image.nvim (inline plot rendering).

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- molten talks to Jupyter kernels through Neovim's Python remote-plugin host.
-- Home Manager provides a reproducible host with pynvim, ipykernel, and
-- jupytext; retain the old virtualenv as a fallback outside that environment.
vim.g.python3_host_prog = vim.env.NVIM_PYTHON3_HOST_PROG
  or vim.fn.expand '~/.virtualenvs/neovim/bin/python'

-- [[ image.nvim: renders kernel image output (e.g. matplotlib plots) inline ]]
vim.pack.add { gh '3rd/image.nvim' }
require('image').setup {
  backend = 'kitty', -- WezTerm implements the kitty graphics protocol
  processor = 'magick_cli', -- Use the ImageMagick CLI, avoids the luarocks magick dependency
  integrations = {}, -- molten drives rendering directly, so disable markdown/other auto-integrations
  max_width = 100,
  max_height = 12,
  max_height_window_percentage = math.huge,
  max_width_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
}

-- [[ jupytext.nvim: converts .ipynb <-> a plain editable buffer on open/save ]]
vim.pack.add { gh 'GCBallesteros/jupytext.nvim' }
require('jupytext').setup {
  style = 'markdown',
  output_extension = 'md',
  force_ft = 'markdown',
}

-- [[ molten-nvim: sends cells to a Jupyter kernel, shows output inline ]]
vim.pack.add { gh 'benlubas/molten-nvim' }

vim.g.molten_image_provider = 'image.nvim'
vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = false -- Manual output windows behave better with image.nvim
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true -- Show output as virtual text below the cell
vim.g.molten_virt_lines_off_by_1 = true

local map = function(keys, func, desc, mode)
  vim.keymap.set(mode or 'n', keys, func, { silent = true, desc = desc })
end

map('<leader>ji', ':MoltenInit<CR>', '[J]upyter [I]nit kernel')
map('<leader>jr', ':MoltenEvaluateOperator<CR>', '[J]upyter [R]un operator')
map('<leader>jl', ':MoltenEvaluateLine<CR>', '[J]upyter run [L]ine')
map('<leader>jc', ':MoltenReevaluateCell<CR>', '[J]upyter re-run [C]ell')
map('<leader>jr', ':<C-u>MoltenEvaluateVisual<CR>gv', '[J]upyter [R]un selection', 'v')
map('<leader>jd', ':MoltenDelete<CR>', '[J]upyter [D]elete cell')
map('<leader>jo', ':MoltenShowOutput<CR>', '[J]upyter show [O]utput')
map('<leader>jh', ':MoltenHideOutput<CR>', '[J]upyter [H]ide output')
map('<leader>je', ':MoltenEnterOutput<CR>', '[J]upyter [E]nter output window')
