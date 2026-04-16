{ inputs
, lib
, config
, pkgs
, ...
}:
let
  nvfInput = inputs.nvf or (throw "inputs.nvf is required in flake inputs.");
in
{
  options.flakes.nvf = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config = {
    packages = [
      (nvfInput.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ config.flakes.nvf ];
      }).neovim
    ];
  };
}
