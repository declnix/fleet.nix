{ ... }:
{
  den.aspects.kr7va.provides.declnix.hjem = { pkgs, ... }: {
    packages = [ pkgs.swaylock-effects pkgs.swayidle ];
    files.".config/swaylock/config".text = ''
      color=000000
      show-failed-attempts
      clock
      indicator-idle-visible
      font=JetBrainsMono Nerd Font
      text-color=cdd6f4
      text-ver-color=cdd6f4
      text-wrong-color=f38ba8
      ring-color=585b70
      ring-ver-color=89b4fa
      ring-wrong-color=f38ba8
      key-hl-color=cdd6f4
    '';
  };

  den.aspects.kr7va.provides.declnix.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.swaylock-effects pkgs.swayidle ];
    security.pam.services.swaylock = { };
  };
}
