{
  den.aspects.programs.provides.direnv = {
    hjem =
      { pkgs, ... }:
      {
        rum.programs.direnv = {
          enable = true;
          integrations.zsh.enable = true;
        };
      };
  };
}
