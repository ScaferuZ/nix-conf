{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    
    enableZshIntegration = true;

    defaultOptions = [
      "--color=bg+:#222222,bg:#000000,spinner:#ffffff,hl:#ffffff"
      "--color=fg:#cccccc,header:#ffffff,info:#cccccc,pointer:#ffffff"
      "--color=marker:#ffffff,fg+:#ffffff,prompt:#ffffff,hl+:#ffffff"
      "--border"       # Adds a clean border around the search window
      "--layout=reverse" # Puts the search bar at the top instead of the bottom
    ];
  };
}
