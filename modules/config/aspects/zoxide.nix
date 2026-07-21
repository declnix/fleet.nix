{
  den.aspects.zoxide = {
    zsh = { lib, pkgs, ... }: {
      initConfig = ''
        eval "$(${lib.getExe pkgs.zoxide} init zsh)"
      '';
    };

    hjem = { pkgs, ... }: {
      packages = [ pkgs.zoxide ];
    };
  };
}
