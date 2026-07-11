{ den
, ...
}:
{
  den.aspects.kr7va = {
    nixos =
      { ... }:
      {
        networking.networkmanager.enable = true;
        services.upower.enable = true;
        services.power-profiles-daemon.enable = true;

        time.timeZone = "Europe/Warsaw";

        services.logind.settings.Login = {
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "ignore";
        };
      };

    provides.declnix = {
      hjem = { pkgs, ... }: {
        rum.programs.fuzzel.enable = true;

        packages = with pkgs;
          [
            wget
            curl
            firefox
            gh
          ];
      };

      nixos = { pkgs, ... }: {
        services.openssh.settings.AllowUsers = [ "declnix" ];
        xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config.common.default = "*";
        };
      };

      user = {
        initialPassword = "password";
      };

      includes =
        [
          den.aspects.development
          den.batteries.primary-user
          (den.batteries.user-shell "zsh")
        ];
    };

    includes =
      (with den.aspects; [ tailscale ssh podman fonts ])
      ++ [ (den.batteries.import-tree ./modules/hardware) ];
  };

  den.hosts.x86_64-linux.kr7va = {
    users.declnix = { };
  };
}
