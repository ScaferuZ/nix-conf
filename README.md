# nix-conf

NixOS, nix-darwin, and Home Manager configuration for Scaf's machines.

## Hosts

- `x220`: x86_64 NixOS laptop
- `macbook-pro`: Apple Silicon macOS laptop for user `scaf`
- `endra.rahman@work`: standalone Apple Silicon Home Manager profile for
  `/Users/endra.rahman`; it does not manage macOS or Homebrew

The flake pins NixOS/nix-darwin/Home Manager 25.11-era inputs. Package and
system changes should be made here, validated, and then activated rather than
installed imperatively.

## macOS prerequisites

The Mac bootstrap assumes:

1. An Apple Silicon Mac with a local administrator account named `scaf` and
   home directory `/Users/scaf`.
2. A working multi-user Nix installation with flakes enabled manually for
   bootstrap. The first activation then declares `nix-command` and `flakes`.
3. Homebrew installed at `/opt/homebrew`. nix-darwin manages its package state
   but does not install Homebrew itself.
4. Xcode Command Line Tools and Git.
5. Network access to GitHub, Nix caches, Homebrew, and declared third-party
   taps.

Install Nix from the [official Nix download page](https://nixos.org/download/)
and Homebrew from [brew.sh](https://brew.sh/) before continuing. Do not copy
credentials into this repository.

## Bootstrap the Mac

Clone the repository:

```sh
git clone https://github.com/ScaferuZ/nix-conf.git ~/.config/nix-conf
cd ~/.config/nix-conf
```

Validate the exact host output before activation:

```sh
nix flake check 'path:.' --all-systems --no-build
nix build 'path:.#darwinConfigurations.macbook-pro.system' --no-link
```

If nix-darwin is already installed, activate with:

```sh
sudo darwin-rebuild switch --flake 'path:.#macbook-pro'
```

For the first nix-darwin installation, invoke the release matching this
flake's pinned branch:

```sh
sudo nix run github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild \
  -- switch --flake 'path:.#macbook-pro'
```

A successful activation ends after Home Manager's activation steps. Confirm
that the running generation matches a fresh build:

```sh
test "$(readlink /run/current-system)" = \
  "$(nix build 'path:.#darwinConfigurations.macbook-pro.system' \
      --no-link --print-out-paths)"
```

### Existing Homebrew installations

Activation reconciles Homebrew with `modules/darwin/homebrew.nix`. It installs
missing declarations and uninstalls undeclared formulae, casks, and taps. It
does **not** use cask `zap`, so application data is not removed, but existing
machines should still inspect the cleanup plan first:

```sh
nix eval --raw \
  'path:.#darwinConfigurations.macbook-pro.config.homebrew.brewfile' \
  >/tmp/nix-conf.Brewfile
HOMEBREW_NO_AUTO_UPDATE=1 \
  brew bundle cleanup --file=/tmp/nix-conf.Brewfile
```

Homebrew upgrades and automatic updates are disabled during activation.
Homebrew 7 removed the cleanup option emitted by nix-darwin 25.11, so the
module contains a compatibility activation step using the supported cleanup
subcommand. Remove that shim together with `cleanup = "none"` when upgrading
to a nix-darwin release that uses `--force-cleanup` natively.

## What owns software

- `hosts/macbook-pro/default.nix` owns macOS system packages and the yabai/skhd
  launch agents.
- `modules/home/cli-tools.nix` and `modules/home/fzf.nix` own portable user
  CLIs through Home Manager.
- `modules/home/mac-dotfiles.nix` owns the Mac shell, Starship, tmux, and
  Neovim configuration plus its reproducible Python plugin host.
- `modules/darwin/homebrew.nix` owns native applications, fonts, fast-moving
  tools, language runtimes, and other documented Homebrew exceptions.
- Project-specific language and SDK versions belong in each project's
  `devShell` or equivalent project files, not this global profile.

The generated Homebrew Brewfile is the authoritative retained inventory. Check
it and the installed state with:

```sh
nix eval --raw \
  'path:.#darwinConfigurations.macbook-pro.config.homebrew.brewfile' \
  >/tmp/nix-conf.Brewfile
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade \
  --file=/tmp/nix-conf.Brewfile
brew missing
```

The configuration preserves the delayed launch of yabai and skhd until
`/nix/store` is available. Their configurations live in `config/yabai` and
`config/skhd`.

Home Manager is integrated on both systems. On macOS it manages `~/.zprofile`
to keep the Home Manager profile ahead of Homebrew while preserving optional
OrbStack initialization. It also reproduces the existing zsh aliases and shell
behavior, tmux plugins/keybindings/theme, Starship prompt, and the complete
Neovim configuration from `config/`. The newer Neovim binary remains owned by
Homebrew; its configuration is an editable symlink to this repository.

## Mutable user tools

The following fast-moving user tools intentionally remain outside Nix and
Homebrew's declarative inventory. Reinstall them after the declared Node.js
runtime is active:

```sh
npm install --global \
  npm \
  9router \
  @earendil-works/pi-coding-agent \
  @modelcontextprotocol/server-github \
  better-sqlite3 \
  oh-my-claude-sisyphus \
  sql.js \
  systray2 \
  yaml-language-server
```

`uv` and its `browser-use` tool are also a documented mutable exception because
`browser-use` is unavailable in the pinned Darwin nixpkgs set:

```sh
# Install uv from its official installer if `uv` is not already available.
uv tool install browser-use
```

These commands intentionally track current releases. The shell also preserves
optional user-managed Bun (`~/.bun`) and Go (`/usr/local/go`) installations;
install those from their official distributions only when needed. Record
project-specific versions in project configuration instead of pinning them
globally here.

## Secrets and local state

No credentials or private keys are stored in this repository. Restore them
from an approved encrypted backup or log in again after bootstrap. Relevant
local state includes, when used:

- `~/.ssh` and Git signing material
- `~/.aws`, `~/.azure`, `~/.config/gcloud`, and `~/.kube`
- `~/.config/sops/age/keys.txt` (mode `0600`)
- `~/.config/zsh/secrets.zsh` for shell API keys and private exports (mode `0600`)
- GitHub CLI authentication (`gh auth login`)
- Git Credential Manager / Keychain entries
- npm registry credentials and private package access
- browser profiles and application-specific data
- `~/Documents/orgmode`, `~/Documents/obsidian-notes`, and other personal notes

Typical interactive restoration steps are:

```sh
gh auth login
az login
gcloud auth login
# Either restore ~/.aws and ~/.kube, or configure them with approved tooling.
```

Never commit generated cloud credentials, kubeconfigs, SOPS age keys, SSH keys,
Homebrew tokens, shell API keys, or decrypted secret files. On a new Mac, create
`~/.config/zsh/secrets.zsh` with mode `0600` and add any required `export
NAME="value"` entries there.

## Manual post-install steps

macOS privacy and security controls cannot be fully configured declaratively:

1. Grant required Accessibility permissions to yabai and skhd.
2. Grant Screen Recording permissions where window-management features require
   them.
3. Allow yabai's scripting addition only where local security policy permits.
4. Run `mkcert -install` only if local development needs its CA; this modifies
   the user/system trust stores.
5. Complete sign-in and first-run prompts for managed GUI applications.
6. Install OrbStack separately if wanted. Its shell initialization is optional
   and safely ignored when absent.

Confirm services after permissions are granted:

```sh
launchctl print "gui/$(id -u)/org.nixos.yabai"
launchctl print "gui/$(id -u)/org.nixos.skhd"
```

## Work-laptop Home Manager profile

`homeConfigurations."endra.rahman@work"` is a separate `aarch64-darwin`
user-only profile for `/Users/endra.rahman`. It deliberately does not import
nix-darwin, Homebrew reconciliation, GUI casks, yabai/skhd, macOS defaults,
personal Git identity, credentials, or personal document aliases.

It provides AWS and Azure CLIs, Terraform, Ansible, Kubernetes and Flux tools,
SOPS, age, Git/GitHub tooling, common shell utilities, Pi, and the portable
zsh, Starship, tmux, and Neovim configuration. Most packages remain on the
pinned 25.11 Darwin input. Pi and Neovim use the separately pinned unstable
input; the latter is required because the captured configuration uses
`vim.pack` from Neovim 0.12.

Do not bypass employer controls. Confirm that local policy permits the Nix
multi-user daemon, `/nix`, required caches, and development tools before
installing Nix. Use the organization's approved Nix installation procedure;
this repository does not install Nix itself.

After an approved Nix installation, clone the repository on the work laptop:

```sh
git clone https://github.com/ScaferuZ/nix-conf.git ~/.config/nix-conf
cd ~/.config/nix-conf
```

Validate without changing the home directory:

```sh
nix flake check 'path:.' --all-systems --no-build
nix build \
  'path:.#homeConfigurations."endra.rahman@work".activationPackage' \
  --no-link
```

Before the first activation, move any colliding configuration into a
machine-local timestamped backup. Nothing is deleted:

```sh
backup="$HOME/.local/state/nix-conf-backups/$(date +%Y%m%d-%H%M%S)"
for path in \
  .zshrc \
  .tmux.conf \
  .config/starship.toml \
  .config/zsh/z.sh \
  .config/tmux/themes/token-flint-light.conf \
  .config/nvim
do
  source="$HOME/$path"
  if [ -e "$source" ] || [ -L "$source" ]; then
    mkdir -p "$backup/$(dirname "$path")"
    mv "$source" "$backup/$path"
  fi
done
printf 'Backup: %s\n' "$backup"
```

Perform the first standalone activation with the Home Manager release matching
this flake:

```sh
nix run github:nix-community/home-manager/release-25.11 -- \
  switch --flake 'path:.#endra.rahman@work'
```

Subsequent activations can use the managed command or the `rebuild` alias:

```sh
home-manager switch --flake 'path:.#endra.rahman@work'
```

Authenticate separately on the work laptop; never copy personal credentials
into the repository:

```sh
gh auth login
aws configure sso
```

Before creating commits, configure Git's `user.name` and `user.email` locally
with the employer-approved work identity; the profile intentionally does not
supply either value.

Restore only employer-approved SSH keys, AWS configuration, kubeconfigs, SOPS
age keys, and shell secrets. A local `~/.config/zsh/secrets.zsh` is sourced when
present and must remain untracked with mode `0600`.

## Rollback

List system generations and reactivate a known generation:

```sh
sudo nix-env --list-generations -p /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system-N-link/activate
```

A Nix generation rollback does not reinstall Homebrew packages removed by
cleanup. Restore an older declared Homebrew inventory from its Git revision and
run `brew bundle install --no-upgrade` against that revision's generated
Brewfile when needed.

## X220

Validate and activate the NixOS host with:

```sh
nix flake check 'path:.' --all-systems --no-build
sudo nixos-rebuild switch --flake 'path:.#x220'
```
