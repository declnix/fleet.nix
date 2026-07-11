{ inputs, ... }:
{
  den.aspects.kr7va = {
    provides.declnix = {
      hjem = {
        programs.noctalia = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile ./full-config.toml);
        };
      };

      nixos = {
        imports = [
          inputs.noctalia-greeter.nixosModules.default
        ];

        nix.settings = {
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };

        hjem.extraModules = [
          inputs.noctalia.hjemModules.default
        ];

        programs.noctalia-greeter = {
          enable = true;
          greeter-args = "--session niri --user declnix";
          settings.output.scale = 1.0;
        };
      };
    };
  };

  flake-file.nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
