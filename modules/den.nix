{ den, lib, inputs, ... }:
{
  imports = [
    inputs.den.flakeModules.dendritic
  ];

  den.default.includes = (with den.batteries; [
    mutual-provider
    hostname
    define-user
    inputs'
  ])
  ++ [ den.aspects.nix ];

  den.default.nixos = {
    system.stateVersion = "25.11";
  };

  flake-file.inputs = {
    den.url = lib.mkDefault "github:denful/den";
  };
}
