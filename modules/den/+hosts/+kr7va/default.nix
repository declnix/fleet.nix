{ inputs
, den
, lib
, ...
}:
{
  den.aspects.kr7va = {
    nixos =
      { pkgs, ... }:
      {
        services.greetd = {
          enable = true;
          settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
        };

        networking.networkmanager.enable = true;

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
            claude-code
            codex
            gemini-cli
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
          (den.batteries.import-tree ./aspects)
        ]
        ++ (with den.aspects.bundles._; [
          development
        ])
        ++ [
          den.batteries.primary-user
          (den.batteries.user-shell "zsh")
          (den.batteries.unfree [ "claude-code" ])
        ];
    };

    includes =
      (with den.aspects.bundles._; [
        remote-control
      ])
      ++
      (with den.aspects.services._;
      [
        libvirt
        podman

      ])
      ++ (with den.aspects.misc._; [
        sudo
        fonts
      ])
      ++ [ (den.batteries.import-tree ./aspects/hardware) ];
  };

  den.hosts.x86_64-linux.kr7va = {
    users.declnix = { };
  };
}
