{ den, ... }:
{
  den.aspects.misc.provides.fonts = {
    nixos =
      { pkgs, ... }:
      {
        fonts.packages = with pkgs.nerd-fonts; [
          fira-code
          jetbrains-mono
        ];
      };
  };
}
