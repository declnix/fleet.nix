{ inputs
, lib
, config
, pkgs
, ...
}:
let
  ntmInput = inputs.tmf or (throw "inputs.tmf is required in flake inputs.");

  tmuxConfig = ntmInput.lib.tmuxConfiguration
    {
      inherit pkgs;
      modules = [ config.flakes.tmf ];
    };
in
{
  options.flakes.tmf = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config = {
    files.".config/tmux/tmux.conf".source = tmuxConfig;
    packages = [ pkgs.tmux ];
  };
}
