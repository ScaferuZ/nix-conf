{ ... }:

{
  imports = [
    ../../home/scaf/base.nix
    ../../modules/home/cli-tools.nix
    ../../modules/home/fzf.nix
    ../../modules/home/mac-dotfiles.nix
  ];

  # Keep the Nix-managed user profile ahead of Homebrew. Homebrew's shellenv
  # prepends its own bin directories, so restore the desired precedence after
  # loading it while preserving the existing OrbStack and local-bin setup.
  home.file.".zprofile" = {
    force = true;
    text = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Added by OrbStack: command-line tools and integration
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :

      # User-installed scripts, then declarative Home Manager packages.
      export PATH="$HOME/.local/bin:/etc/profiles/per-user/$USER/bin:$PATH"
    '';
  };

  # zsh, tmux, and Neovim configuration are repository-backed through
  # mac-dotfiles.nix. Credentials and document/data directories stay local.
}
