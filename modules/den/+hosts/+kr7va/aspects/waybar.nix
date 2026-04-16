{ den, ... }:
{
  den.aspects.kr7va.provides.declnix.hjem = {
    rum.programs.waybar = {
      enable = true;
      extraConfig = builtins.toJSON {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "custom/nixos" ];
        modules-center = [ ];
        modules-right = [ "network" "battery" "clock" ];
        "custom/nixos" = { format = ""; tooltip = false; };
        clock = { format = "󰃰  {:%d %b %H:%M}"; tooltip = false; };
        network = {
          format-wifi = "󰤨  {essid}";
          format-disconnected = "󰤭";
          tooltip = false;
        };
        battery = {
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          states = { warning = 30; critical = 15; };
          tooltip = false;
        };
      };
      extraStyle = ''
        * { all: unset; font-family: "JetBrainsMono Nerd Font"; font-size: 13px; }
        window#waybar { background: #1a1a1a; color: #e0e0e0; }
        .modules-left { padding: 2px 8px; }
        .modules-right { padding: 2px 8px; }
        #custom-nixos { color: #7ebae4; margin: 0 6px; }
        #network, #battery, #clock { margin: 0 6px; }
        #network { color: #4a9eff; }
        #battery { color: #44cc44; }
        #battery.charging { color: #44cc44; }
        #battery.warning:not(.charging) { color: #ffaa00; }
        #battery.critical:not(.charging) { color: #ff4444; }
      '';
    };
  };

  den.aspects.kr7va.provides.declnix.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.waybar ];
  };
}
