{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "p"; 
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      battery
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];

    extraConfig = ''
      # Reload config (Note: Home Manager puts the config in ~/.config/tmux/tmux.conf)
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Manual Vim-like pane switching
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # True color RGB overrides
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
