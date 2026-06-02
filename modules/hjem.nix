{ inputs
, ...
}:
{
  den = {
    default = {
      nixos.hjem.extraModules = [
        {
          _module.args = { inherit inputs; };
        }
        inputs.hjem-impure.hjemModules.default
        inputs.hjem-rum.hjemModules.default
      ];

      hjem.impure.enable = true;
    };

    schema = {
      user.classes = [ "hjem" ];
      host.hjem.enable = true;
    };
  };

  flake-file.inputs = {
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-impure = {
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
  };
}
