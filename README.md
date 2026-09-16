# nix-conf

NixOS, nix-darwin, and Home Manager configuration for Scaf's machines.

## Hosts

- `x220`: x86_64 NixOS laptop
- `macbook-pro`: Apple Silicon macOS laptop

## Apply a configuration

Clone the repository first:

```sh
git clone https://github.com/ScaferuZ/nix-conf.git ~/.config/nix-conf
cd ~/.config/nix-conf
```

On macOS with nix-darwin already installed:

```sh
sudo darwin-rebuild switch --flake .#macbook-pro
```

On the X220:

```sh
sudo nixos-rebuild switch --flake .#x220
```

## Validate before switching

```sh
nix flake check --all-systems --no-build
nix build .#darwinConfigurations.macbook-pro.system --no-link
```

The macOS configuration preserves the delayed launch of yabai and skhd until
`/nix/store` is available. Their configurations live in `config/yabai` and
`config/skhd`.

Home Manager is integrated on both systems. Existing macOS zsh, tmux, and
Neovim dotfiles are intentionally not managed yet; migrate them individually
to avoid overwriting local configuration.
