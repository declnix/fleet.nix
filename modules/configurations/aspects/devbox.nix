{
  den.aspects.devbox = {
    hjem =
      { pkgs, ... }:
      {
        packages = [ pkgs.devbox ];
      };
  };
}
