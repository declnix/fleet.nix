{ ... }:
{
  den.aspects.bat = {
    zsh = { lib, pkgs, ... }: {
      initConfig = ''
        alias cat='${lib.getExe pkgs.bat}'
      '';
    };

    hjem = { pkgs, ... }: {
      packages = [ pkgs.bat ];
    };
  };
}
