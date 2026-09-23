{ ... }:

{
  imports = [
    ../../modules/home/fzf.nix
    ../../modules/home/work-cli.nix
    ../../modules/home/work-dotfiles.nix
  ];

  home.username = "endra.rahman";
  home.homeDirectory = "/Users/endra.rahman";

  programs.home-manager.enable = true;

  # Do not change this after the first Home Manager activation.
  home.stateVersion = "25.11";
}
