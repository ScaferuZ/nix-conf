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
    gnumake
    graphviz
    imagemagick
    k6
    kubectx
    kubernetes-helm # Homebrew names this package "helm".
    kubectl
    lazydocker
    lazygit
    mkcert
    nmap
    nss.tools # Homebrew's "nss"; nixpkgs splits tools from the library.
    ripgrep
    sops
    sshpass
    terraform
    unzip
    wireguard-tools
    xorriso
  ];
}
