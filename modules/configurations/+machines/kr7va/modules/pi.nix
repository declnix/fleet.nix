{ inputs, ... }:
{
  flake.nix.settings = {
    extra-substituters = [ "https://pi.cachix.org" ];
    extra-trusted-public-keys = [
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
    ];
  };

  den.aspects.kr7va.provides.declnix.nixos = { ... }: {
    nixpkgs.overlays = [ inputs.pi.overlays.default ];
  };

  den.aspects.kr7va.provides.declnix.hjem = { pkgs, ... }: {
    packages = [ pkgs.pi-coding-agent ];
  };
}
