{ den, ... }:
{
  den.aspects.git = {
    hjem = { ... }: {
      rum.programs.git = {
        enable = true;
      };
    };

    includes = [ den.aspects.gh ];
  };
}
