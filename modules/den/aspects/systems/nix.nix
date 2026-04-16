{ den, ... }:
{
  den.aspects.systems.provides.nix = {
    nixos = {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
    };
  };
}
