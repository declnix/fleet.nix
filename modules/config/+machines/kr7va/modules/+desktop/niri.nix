{ inputs, ... }:
{
  den.aspects.kr7va = {
    provides.declnix = {
      hjem = { ... }: {
        files.".config/niri/config.kdl".text = ''
          input {
            touchpad {
              tap
              natural-scroll
              scroll-method "two-finger"
            }
          }

          spawn-at-startup "noctalia"

          binds {
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+T { spawn "alacritty"; }
            Mod+D { spawn "fuzzel"; }
            Mod+Q { close-window; }
            Mod+Shift+E { quit; }
            Ctrl+Alt+Delete { quit; }

            Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }
            Mod+O { toggle-overview; }
            Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
            Mod+Comma { spawn-sh "noctalia msg settings-toggle"; }

            XF86AudioRaiseVolume { spawn-sh "noctalia msg volume-up"; }
            XF86AudioLowerVolume { spawn-sh "noctalia msg volume-down"; }
            XF86AudioMute { spawn-sh "noctalia msg volume-mute"; }
            XF86MonBrightnessUp { spawn-sh "noctalia msg brightness-up"; }
            XF86MonBrightnessDown { spawn-sh "noctalia msg brightness-down"; }

            Mod+Left { focus-column-left; }
            Mod+Down { focus-window-down; }
            Mod+Up { focus-window-up; }
            Mod+Right { focus-column-right; }
            Mod+H { focus-column-left; }
            Mod+J { focus-window-down; }
            Mod+K { focus-window-up; }
            Mod+L { focus-column-right; }

            Mod+Ctrl+Left { move-column-left; }
            Mod+Ctrl+Down { move-window-down; }
            Mod+Ctrl+Up { move-window-up; }
            Mod+Ctrl+Right { move-column-right; }
            Mod+Ctrl+H { move-column-left; }
            Mod+Ctrl+J { move-window-down; }
            Mod+Ctrl+K { move-window-up; }
            Mod+Ctrl+L { move-column-right; }

            Mod+Home { focus-column-first; }
            Mod+End { focus-column-last; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End { move-column-to-last; }

            Mod+Shift+Left { focus-monitor-left; }
            Mod+Shift+Down { focus-monitor-down; }
            Mod+Shift+Up { focus-monitor-up; }
            Mod+Shift+Right { focus-monitor-right; }
            Mod+Shift+H { focus-monitor-left; }
            Mod+Shift+J { focus-monitor-down; }
            Mod+Shift+K { focus-monitor-up; }
            Mod+Shift+L { focus-monitor-right; }

            Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
            Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
            Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
            Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
            Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
            Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
            Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
            Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

            Mod+Page_Down { focus-workspace-down; }
            Mod+Page_Up { focus-workspace-up; }
            Mod+Alt+Down { focus-workspace-down; }
            Mod+Alt+Up { focus-workspace-up; }
            Mod+Alt+Right { focus-workspace-down; }
            Mod+Alt+Left { focus-workspace-up; }
            Mod+U { focus-workspace-down; }
            Mod+I { focus-workspace-up; }
            Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
            Mod+Ctrl+Page_Up { move-column-to-workspace-up; }
            Mod+Alt+Shift+Down { move-column-to-workspace-down; }
            Mod+Alt+Shift+Up { move-column-to-workspace-up; }
            Mod+Alt+Shift+Right { move-column-to-workspace-down; }
            Mod+Alt+Shift+Left { move-column-to-workspace-up; }
            Mod+Ctrl+U { move-column-to-workspace-down; }
            Mod+Ctrl+I { move-column-to-workspace-up; }
            Mod+Shift+Page_Down { move-workspace-down; }
            Mod+Shift+Page_Up { move-workspace-up; }
            Mod+Shift+U { move-workspace-down; }
            Mod+Shift+I { move-workspace-up; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }

            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            Mod+Shift+6 { move-column-to-workspace 6; }
            Mod+Shift+7 { move-column-to-workspace 7; }
            Mod+Shift+8 { move-column-to-workspace 8; }
            Mod+Shift+9 { move-column-to-workspace 9; }

            Mod+Ctrl+1 { move-column-to-workspace 1; }
            Mod+Ctrl+2 { move-column-to-workspace 2; }
            Mod+Ctrl+3 { move-column-to-workspace 3; }
            Mod+Ctrl+4 { move-column-to-workspace 4; }
            Mod+Ctrl+5 { move-column-to-workspace 5; }
            Mod+Ctrl+6 { move-column-to-workspace 6; }
            Mod+Ctrl+7 { move-column-to-workspace 7; }
            Mod+Ctrl+8 { move-column-to-workspace 8; }
            Mod+Ctrl+9 { move-column-to-workspace 9; }

            Mod+Period { expel-window-from-column; }
            Mod+R { switch-preset-column-width; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+C { center-column; }
            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }
            Mod+Shift+P { power-off-monitors; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }
          }

          window-rule {
            geometry-corner-radius 20
            clip-to-geometry true
          }

          window-rule {
            match app-id="dev.noctalia.Noctalia.Settings"
            open-floating true
            default-column-width { fixed 1080; }
            default-window-height { fixed 920; }
          }

          debug {
            honor-xdg-activation-with-invalid-serial
          }
        '';
      };

      nixos = {
        imports = [
          inputs.niri-flake.nixosModules.niri
        ];

        nix.settings = {
          extra-substituters = [ "https://niri.cachix.org" ];
          extra-trusted-public-keys = [
            "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          ];
        };

        programs.niri.enable = true;
      };
    };
  };

  flake-file.nixConfig = {
    extra-substituters = [ "https://niri.cachix.org" ];
    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  flake-file.inputs.niri-flake.url = "github:sodiboo/niri-flake";
}
