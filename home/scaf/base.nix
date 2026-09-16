{ pkgs, ... }:

{
  home.username = "scaf";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/scaf" else "/home/scaf";

  programs.home-manager.enable = true;

  # Do not change this after the first Home Manager activation.
  home.stateVersion = "25.11";
}
