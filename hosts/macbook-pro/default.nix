{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  user = "scaf";
  yabaiConfig = pkgs.writeShellApplication {
    name = "yabairc";
    runtimeInputs = [
      pkgs.jq
      pkgs.yabai
    ];
    text = builtins.readFile ../../config/yabai/yabairc;
  };
  skhdConfig = pkgs.writeText "skhdrc" (builtins.readFile ../../config/skhd/skhdrc);
  servicePath =
    lib.makeBinPath [
      pkgs.skhd
      pkgs.yabai
    ]
    + ":/usr/bin:/bin:/usr/sbin:/sbin";
in
{
  imports = [
    ../../modules/darwin/homebrew.nix
  ];

  system.primaryUser = user;
  users.users.${user}.home = "/Users/${user}";

  environment.systemPackages = with pkgs; [
    git
    jq
    skhd
    tmux
    vim
    yabai
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
  };
  services.skhd.enable = true;

  # launchd can start before the encrypted Nix store is mounted. Start through
  # /bin/sh, wait for /nix/store, then use the configurations pinned in Git.
  launchd.user.agents.yabai.serviceConfig = {
    EnvironmentVariables = {
      USER = user;
      PATH = lib.mkForce "${servicePath}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin";
    };
    ProgramArguments = lib.mkForce [
      "/bin/sh"
      "-c"
      "/bin/wait4path /nix/store && exec ${pkgs.yabai}/bin/yabai --config ${yabaiConfig}/bin/yabairc"
    ];
  };

  launchd.user.agents.skhd.serviceConfig = {
    EnvironmentVariables = {
      USER = user;
      PATH = lib.mkForce "${servicePath}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin";
    };
    ProgramArguments = lib.mkForce [
      "/bin/sh"
      "-c"
      "/bin/wait4path /nix/store && exec ${pkgs.skhd}/bin/skhd -c ${skhdConfig}"
    ];
  };

  security.sudo.extraConfig = ''
    ${user} ALL=(root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
  '';

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
