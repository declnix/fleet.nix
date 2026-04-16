{ den, pkgs, ... }:
{
  den.aspects.kr7va.provides.declnix.hjem = {
    rum.programs.alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "None";
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };
  };
}
