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
      "plannotator/tap"
      {
        name = "sikarugir-app/sikarugir";
        clone_target = "https://github.com/Sikarugir-App/homebrew-sikarugir";
      }
    ];

    brews = [
      "beads"
      "beads_viewer"
      "composer"
      # Keep the newer Homebrew codec build for media workflows.
      "ffmpeg"
      "firefoxpwa"
      # nixpkgs 25.11 trails this fast-moving release; keep it on Homebrew.
      "gemini-cli"
      "herdr"
      "hunk"
      "mole"
      # Preserve Homebrew's native macOS media integration.
      "mpv"
      # Keep the newer binary compatible with the unmanaged ~/.config/nvim repo.
      "neovim"
      "node"
      "php@8.2"
      "pipx"
      "pnpm"
      "pyenv"
      "python@3.11"
      "python@3.12"
      "rtk"
      # Keep the newer macOS-native notification binary.
      "terminal-notifier"
      # Keep this pair aligned with the Homebrew Neovim toolchain.
      "tree-sitter"
      "tree-sitter-cli"
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
