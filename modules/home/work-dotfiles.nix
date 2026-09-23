{
  config,
  lib,
  pkgs,
  ...
}:

let
  nvimPython = pkgs.python313.withPackages (
    pythonPackages: with pythonPackages; [
      ipykernel
      jupytext
      pynvim
    ]
  );
in
{
  home.packages = [ nvimPython ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NVIM_PYTHON3_HOST_PROG = "${nvimPython}/bin/python3";
    SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
    VISUAL = "nvim";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      conf = "nvim ~/.config/nix-conf/hosts/work/home.nix";
      k = "kubectl";
      ld = "lazydocker";
      lg = "lazygit";
      ls = "eza -ll";
      re = "exec zsh";
      rebuild = "home-manager switch --flake 'path:$HOME/.config/nix-conf#endra.rahman@work'";
      tf = "terraform";
      v = "nvim";
      vim = "nvim";
    };

    initContent = lib.mkOrder 1000 ''
      typeset -U path
      path=($HOME/.local/bin $HOME/.nix-profile/bin $path)
      rehash

      setopt inc_append_history

      source ${config.xdg.configHome}/zsh/z.sh

      # Credentials and machine-local exports are never committed.
      [[ -r ${config.xdg.configHome}/zsh/secrets.zsh ]] \
        && source ${config.xdg.configHome}/zsh/secrets.zsh
    '';
  };

  xdg.configFile."zsh/z.sh".source = ../../config/zsh/z.sh;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../config/starship.toml);
  };

  programs.tmux = {
    enable = true;
    shortcut = "p";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      battery
      resurrect
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
    ];

    extraConfig = ''
      unbind r
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      set -g allow-passthrough on
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'
      set -as terminal-features 'tmux*:extkeys'
      set -ag terminal-overrides ',xterm-256color:RGB'
      set -g status-right '#{battery_icon} #{battery_percentage} | %a %h-%d %H:%M '
      set-option -g update-environment 'SSH_AUTH_SOCK'

      source-file ${config.xdg.configHome}/tmux/themes/token-flint-light.conf
    '';
  };

  home.file.".tmux.conf".text = "source-file ${config.xdg.configHome}/tmux/tmux.conf\n";
  xdg.configFile."tmux/themes/token-flint-light.conf".source =
    ../../config/tmux/themes/token-flint-light.conf;

  # Keep the Neovim configuration editable in the cloned repository.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-conf/config/nvim";
}
