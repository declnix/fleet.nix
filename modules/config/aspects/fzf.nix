{
  den.aspects.fzf = {
    zsh = { lib, pkgs, ... }: {
      initConfig = ''
        source <(${lib.getExe pkgs.fzf} --zsh)
      '';
    };

    hjem = { pkgs, ... }: {
      packages = [ pkgs.fzf ];
    };
  };
}
