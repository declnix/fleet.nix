{
  den.aspects.programs.provides.fzf = {
    hjem =
      { pkgs, ... }:
      {
        rum.programs.fzf = {
          enable = true;
          integrations.zsh.enable = true;
        };
      };
  };
}
