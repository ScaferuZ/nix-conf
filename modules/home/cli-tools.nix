{ pkgs, ... }:

{
  home.packages = with pkgs; [
    actionlint
    age
    eza
    fd
    gh
    kubectx
    kubernetes-helm # Homebrew names this package "helm".
    lazygit
    mkcert
    ripgrep
    sops
  ];
}
