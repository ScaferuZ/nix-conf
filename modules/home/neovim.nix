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

    extraLuaConfig = ''
      -- Set leader key to space (Best practice for modern Neovim)
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- Enable hybrid line numbers
      -- Shows absolute number on current line, relative on all others
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Map 'ii' to escape in insert mode
      vim.keymap.set('i', 'ii', '<Esc>', { noremap = true, silent = true })

      -- Nice-to-have lightweight defaults
      vim.opt.tabstop = 4         -- 4 spaces for a tab
      vim.opt.shiftwidth = 4      -- 4 spaces for indenting
      vim.opt.expandtab = true    -- Convert tabs to spaces
      vim.opt.smartindent = true  -- Auto-indent new lines
      vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard
    '';
  };
}
