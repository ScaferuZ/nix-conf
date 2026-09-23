{
  config,
  lib,
  pkgs,
  ...
}:

let
  cleanupBrewfile = pkgs.writeText "Brewfile" config.homebrew.brewfile;
in
{
  # Homebrew remains the source of truth for native, fast-moving, and mutable
  # ecosystem packages that were intentionally retained after migration.
  homebrew = {
    enable = true;

    # Only taps that currently provide a declared formula or cask are listed.
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
      "python@3.13" # Runtime dependency of the gcloud-cli cask.
      "rtk"
      "sdl2-compat" # Runtime dependency of the retained ffmpeg and mpv builds.
      # Keep the newer macOS-native notification binary.
      "terminal-notifier"
      # Keep this pair aligned with the Homebrew Neovim toolchain.
      "tree-sitter"
      "tree-sitter-cli"
      "yarn"
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

    # Reconcile packages without coupling activation to mass upgrades.
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # nix-darwin 25.11 emits Homebrew's removed `brew bundle --cleanup`
      # switch. The compatibility activation step below uses the supported
      # `brew bundle cleanup --force` subcommand instead.
      cleanup = "none";
    };
  };

  system.activationScripts.homebrew.text = lib.mkAfter ''
    # Remove undeclared packages without `--zap`, which could remove app data.
    echo >&2 "Homebrew bundle cleanup..."
    if [ -f "${config.homebrew.brewPrefix}/brew" ]; then
      PATH="${config.homebrew.brewPrefix}:${lib.makeBinPath [ pkgs.mas ]}:$PATH" \
      sudo \
        --preserve-env=PATH \
        --user=${lib.escapeShellArg config.homebrew.user} \
        --set-home \
        env \
        HOMEBREW_NO_AUTO_UPDATE=1 brew bundle cleanup \
          --file='${cleanupBrewfile}' \
          --force
    fi
  '';
}
