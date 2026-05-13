{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top"; 
        height = 22;      
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "network" "cpu" "memory" "clock" ];

        network = {
          format-wifi = "WIFI: {essid} ({signalStrength}%)";
          format-ethernet = "ETH: {ipaddr}";
          format-disconnected = "OFFLINE";
          tooltip = false;
        };

        cpu = {
          format = "CPU: {usage}%";
          tooltip = false;
        };

        memory = {
          format = "RAM: {}%";
          tooltip = false;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: monospace;
        font-size: 11px;
        border: none;
        border-radius: 0;
        min-height: 0; 
      }
      
      window#waybar {
        background-color: #000000; /* Pure black background */
        color: #cccccc;            /* Light gray text */
      }

      #workspaces button {
        padding: 0 8px;
        color: #666666;            /* Dim gray for inactive workspaces */
        background: transparent;
      }
      
      #workspaces button.focused {
        color: #ffffff;            /* Bright white for active workspace */
        background-color: #222222; /* Dark gray highlight, zero color */
      }

      #network, #cpu, #memory, #clock, #window {
        padding: 0 6px;
      }
    '';
  };
}
