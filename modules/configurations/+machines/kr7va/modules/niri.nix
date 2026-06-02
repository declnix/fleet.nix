{ ... }:
{
  den.aspects.kr7va.provides.declnix.hjem = { ... }: {

    rum.desktops.niri = {
      binds = {
        # System / App Spawning
        "Mod+Shift+Slash" = { action = "show-hotkey-overlay"; };
        "Mod+T" = {
          spawn = [ "alacritty" ];
          parameters.hotkey-overlay-title = "Open a Terminal: alacritty";
        };
        "Mod+D" = {
          spawn = [ "fuzzel" ];
          parameters.hotkey-overlay-title = "Run an Application: fuzzel";
        };
        "Mod+Shift+E" = { action = "quit"; };
        "Ctrl+Alt+Delete" = { action = "quit"; };

        # Audio / Brightness
        "XF86AudioRaiseVolume" = {
          spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" "-l" "1.0" ];
          parameters.allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
          parameters.allow-when-locked = true;
        };
        "XF86AudioMute" = {
          spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
          parameters.allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];
          parameters.allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];
          parameters.allow-when-locked = true;
        };

        # Navigation
        "Mod+H" = { action = "focus-column-left"; };
        "Mod+J" = { action = "focus-window-down"; };
        "Mod+K" = { action = "focus-window-up"; };
        "Mod+L" = { action = "focus-column-right"; };

        # Window Movement
        "Mod+Ctrl+H" = { action = "move-column-left"; };
        "Mod+Ctrl+J" = { action = "move-window-down"; };
        "Mod+Ctrl+K" = { action = "move-window-up"; };
        "Mod+Ctrl+L" = { action = "move-column-right"; };

        # Workspace Navigation
        "Mod+1" = { action = "focus-workspace 1"; };
        "Mod+2" = { action = "focus-workspace 2"; };
        "Mod+3" = { action = "focus-workspace 3"; };
        "Mod+4" = { action = "focus-workspace 4"; };
        "Mod+5" = { action = "focus-workspace 5"; };
        "Mod+6" = { action = "focus-workspace 6"; };
        "Mod+7" = { action = "focus-workspace 7"; };
        "Mod+8" = { action = "focus-workspace 8"; };
        "Mod+9" = { action = "focus-workspace 9"; };

        # Workspace Movement
        "Mod+Shift+1" = { action = "move-column-to-workspace 1"; };
        "Mod+Shift+2" = { action = "move-column-to-workspace 2"; };
        "Mod+Shift+3" = { action = "move-column-to-workspace 3"; };
        "Mod+Shift+4" = { action = "move-column-to-workspace 4"; };
        "Mod+Shift+5" = { action = "move-column-to-workspace 5"; };
        "Mod+Shift+6" = { action = "move-column-to-workspace 6"; };
        "Mod+Shift+7" = { action = "move-column-to-workspace 7"; };
        "Mod+Shift+8" = { action = "move-column-to-workspace 8"; };
        "Mod+Shift+9" = { action = "move-column-to-workspace 9"; };

        # Screenshots
        "Print" = { action = "screenshot"; };
        "Ctrl+Print" = { action = "screenshot-screen"; };
        "Alt+Print" = { action = "screenshot-window"; };
        "Super+Alt+L" = {
          spawn = [ "swaylock" ];
          parameters.hotkey-overlay-title = "Lock the Screen: swaylock";
        };
      };
      spawn-at-startup = [
        [ "swayidle" "-w" "timeout" "300" "swaylock -f" "timeout" "600" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors" ]
        [ "waybar" ]
      ];
      config = ''
        input {
          touchpad {
            tap
            natural-scroll
            scroll-method "two-finger"
          }
        }
      '';
    };
  };

  den.aspects.kr7va.provides.declnix.nixos = {
    programs.niri.enable = true;
  };
}
