{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/tmux.nix
    ../../modules/home/neovim.nix
    ../../modules/home/zsh.nix
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
        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-";
        "XF86AudioMute" = "exec wpctl set-mute  @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute"     = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
