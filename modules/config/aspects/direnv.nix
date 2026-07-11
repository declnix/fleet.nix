{
  den.aspects.direnv = {
    hjem =
      { ... }:
      {
        rum.programs.direnv = {
          enable = true;
          integrations.zsh.enable = true;
        };
      };
  };
}
