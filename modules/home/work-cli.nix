{ pkgs, unstablePkgs, ... }:

{
  home.packages = with pkgs; [
    actionlint
    age
    ansible
    awscli2
    azure-cli
    eza
    fd
    fluxcd
    gh
    git
    gnumake
    jq
    kubectx
    kubernetes-helm
    kubectl
    lazydocker
    lazygit
    ripgrep
    sops
    terraform
    unzip
    yq-go

    # The captured configuration uses vim.pack, which requires Neovim 0.12.
    unstablePkgs.neovim

    # Pi is packaged upstream and pinned by the unstable flake input.
    unstablePkgs.pi-coding-agent
  ];
}
