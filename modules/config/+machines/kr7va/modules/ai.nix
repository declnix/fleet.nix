{ den, inputs, ... }:
{
  den.aspects.kr7va = {
    provides.declnix = {
      hjem = { pkgs, ... }: {
        packages = with pkgs; [
          antigravity-cli
          claude-code
          codex
          gemini-cli
        ];
      };

      nixos = { ... }: {
        nixpkgs.overlays = [
          (final: _prev: {
            antigravity-cli = inputs.antigravity.packages.${final.system}.antigravity-cli;
          })
        ];
      };

      includes = [
        (den.batteries.unfree [ "claude-code" ])
      ];
    };
  };

  flake-file.inputs.antigravity = {
    url = "github:Hy4ri/antigravity-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
