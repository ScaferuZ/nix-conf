{ ... }:

{
  # Homebrew remains the source of truth for these packages during the first
  # migration phase. Later beads move portable CLI tools to Home Manager in
  # small, tested batches.
  homebrew = {
    enable = true;

    # Only taps that currently provide a declared formula or cask are listed.
    # cleanup = "none" means existing unused taps are not removed on activation.
    taps = [
      "anomalyco/tap"
      "can1357/tap"
      "dgunzy/tap"
      "floci-io/floci"
      "fluxcd/tap"
      "plannotator/tap"
      {
        name = "sikarugir-app/sikarugir";
        clone_target = "https://github.com/Sikarugir-App/homebrew-sikarugir";
      }
    ];

    brews = [
      "actionlint"
      "age"
      "ansible"
      "arping"
      "awscli"
      "azure-cli"
      "beads"
      "beads_viewer"
      "biome"
      "composer"
      "eza"
      "fd"
      "ffmpeg"
      "firefoxpwa"
      "fzf"
      "gemini-cli"
      "gh"
      "ghostscript"
      "graphviz"
      "helm"
      "herdr"
      "hunk"
      "imagemagick"
      "k6"
      "kubectx"
      "lazygit"
      "mkcert"
      "mole"
      "mpv"
      "neovim"
      "nmap"
      "node"
      "nss"
      "php@8.2"
      "pipx"
      "pnpm"
      "pyenv"
      "python@3.11"
      "python@3.12"
      "ripgrep"
      "rtk"
      "sops"
      "sshpass"
      "terminal-notifier"
      "tree-sitter"
      "tree-sitter-cli"
      "wireguard-tools"
      "xorriso"
      "yarn"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
    ];

    casks = [
      "codex"
      "copilot-cli"
      "dotnet-sdk@8"
      "font-iosevka-term-nerd-font"
      "font-sauce-code-pro-nerd-font"
      "gcloud-cli"
      "git-credential-manager"
      "google-chrome"
      "jordanbaird-ice"
      "libreoffice"
      "ngrok"
      "pearcleaner"
      "wezterm@nightly"
      "whisky"
    ];

    # nix-darwin 25.11 predates typed `trusted` fields. Keep the trusted
    # third-party entries as raw Brewfile lines until the release is upgraded.
    extraConfig = ''
      brew "anomalyco/tap/opencode", trusted: true
      brew "can1357/tap/omp", trusted: true
      brew "dgunzy/tap/flux9s", trusted: true
      brew "floci-io/floci/floci", trusted: true
      brew "fluxcd/tap/flux", trusted: true
      brew "plannotator/tap/plannotator-tui", trusted: true
      cask "sikarugir-app/sikarugir/sikarugir", trusted: true
    '';

    # Keep the first activation non-destructive and avoid coupling this
    # migration to a mass package upgrade.
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
  };
}
