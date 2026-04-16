{
  den.aspects.programs.provides.devbox = {
    hjem =
      { pkgs, ... }:
      {
        packages = [ pkgs.devbox ];
      };
  };
}
