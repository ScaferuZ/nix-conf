{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/tmux.nix
  ];

  home.username = "scaf";
  home.homeDirectory = "/home/scaf";
  home.sessionVariables = {
  MOZ_ENABLE_WAYLAND = "1";
  };

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    alacritty
    wl-clipboard
    wofi
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      input = {
        "*" = {
	  xkb_options = "ctrl:nocaps,altwin:swap_alt_win";
	};
      };
      workspaceLayout = "default";
      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec wofi --show run";
        "${modifier}+b" = "exec firefox";
        "${modifier}+q" = "kill";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaymsg exit";
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
