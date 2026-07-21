{
  den.aspects.direnv = {
    zsh = { lib, pkgs, ... }: {
      initConfig = ''
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"
      '';
    };

    hjem = { pkgs, ... }: {
      packages = [ pkgs.direnv ];
    };
  };
}
