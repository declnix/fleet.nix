{ inputs
, lib
, config
, pkgs
, ...
}:
let
  zef =
    inputs.zef
      or (throw "inputs.nix-zsh is required in flake inputs.");

  zshConfig =
    zef.lib.zshConfiguration {
      inherit pkgs;

      modules = [
        config.flakes.zef
      ];
    };
in
{
  options.flakes.zef = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config = {
    rum.programs.zsh.enable = true;
    rum.programs.zsh.initConfig = lib.mkBefore (
      builtins.readFile zshConfig
    );
  };
}
