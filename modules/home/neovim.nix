{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    
    extraPackages = with pkgs; [
      ripgrep
      fd
      xclip
    ];

    plugins = with pkgs.vimPlugins; [
      orgmode
      nvim-treesitter.withAllGrammars
    ];

    extraLuaConfig = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.clipboard = 'unnamedplus'

      vim.keymap.set('i', 'ii', '<Esc>', { noremap = true, silent = true })

      -- Setup Orgmode and point it to your Syncthing directory
      require('orgmode').setup({
        org_agenda_files = {'~/notes/**/*'},
        org_default_notes_file = '~/notes/refile.org',
      })
    '';
  };
}
