local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add { gh 'nvim-orgmode/orgmode' }

require('orgmode').setup {
  org_agenda_files = vim.fn.expand '~/Documents/orgmode/**/*',
  org_default_notes_file = vim.fn.expand '~/Documents/orgmode/refile.org',
}
