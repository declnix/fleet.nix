{ ... }: {
  den.aspects.bur34u = {
    provides.to-users = {
      hjem = { pkgs, ... }: {
        packages = with pkgs; [ glab ];
      };
    };
  };
}
