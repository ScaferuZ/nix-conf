{ ... }:

{
  imports = [
    ../../home/scaf/base.nix
  ];

  # Existing ~/.zshrc, ~/.tmux.conf, and ~/.config/nvim are intentionally
  # left unmanaged during the first migration so activation cannot overwrite
  # working or uncommitted configuration. Migrate them one at a time later.
}
