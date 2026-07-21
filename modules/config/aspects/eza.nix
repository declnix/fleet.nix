{ ... }:
{
  den.aspects.eza = {
    zsh = { lib, pkgs, ... }: {
      initConfig =
        let
          flags = "--group-directories-first --icons=always";
        in
        ''
          alias ls="${lib.getExe pkgs.eza} ${flags}"
          alias ll="${lib.getExe pkgs.eza} -lh ${flags}"
          alias la="${lib.getExe pkgs.eza} -la ${flags}"
          alias tree="${lib.getExe pkgs.eza} --tree ${flags}"
        '';
    };

    hjem = { pkgs, ... }: {
      packages = [ pkgs.eza ];
    };
  };
}
