{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.rum.programs.bat;
in
{
  options.rum.programs.bat = {
    enable = mkEnableOption "bat";
    package = mkPackageOption pkgs "bat" { nullable = true; };
    integrations = {
      zsh.enable = mkEnableOption "bat alias for cat in zsh";
    };
  };

  config = mkIf cfg.enable {
    packages = mkIf (cfg.package != null) [ cfg.package ];

    rum.programs.zsh.initConfig = mkIf cfg.integrations.zsh.enable ''
      alias cat='${getExe cfg.package}'
    '';
  };
}
