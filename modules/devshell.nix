{ ... }:
{
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.just
      ];

      shellHook = ''
        ${config.pre-commit.shellHook}
      '';
    };
  };
}
