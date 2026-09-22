{ pkgs, ... }:

{
  home.packages = with pkgs; [
    actionlint
    age
    ansible
    awscli2 # Homebrew names this package "awscli".
    azure-cli
    biome
    eza
    fd
    fluxcd # Provides the `flux` command.
    gh
    graphviz
    imagemagick
    k6
    kubectx
    kubernetes-helm # Homebrew names this package "helm".
    lazygit
    mkcert
    ripgrep
    sops
  ];
}
