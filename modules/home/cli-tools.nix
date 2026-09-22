{ pkgs, ... }:

{
  home.packages = with pkgs; [
    actionlint
    age
    ansible
    arping
    awscli2 # Homebrew names this package "awscli".
    azure-cli
    biome
    eza
    fd
    fluxcd # Provides the `flux` command.
    gh
    ghostscript
    graphviz
    imagemagick
    k6
    kubectx
    kubernetes-helm # Homebrew names this package "helm".
    lazygit
    mkcert
    nmap
    nss.tools # Homebrew's "nss"; nixpkgs splits tools from the library.
    ripgrep
    sops
    sshpass
    wireguard-tools
    xorriso
  ];
}
