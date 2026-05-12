{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # These two completely replace the need for Oh-My-Zsh plugins
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Basic navigation
      ls = "ls -la";
      ".." = "cd ..";
      
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#x220";
      
      # Neovim muscle memory
      v = "nvim";
      vim = "nvim";
      
      # Git shortcuts
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
    };

    # Automatically drop into a tmux session if one isn't active
    # (Comment this out if you don't want it to be automatic)
    # initExtra = ''
    #   if [ -z "$TMUX" ]; then
    #     tmux attach || tmux new
    #   fi
    # '';
  };
}
