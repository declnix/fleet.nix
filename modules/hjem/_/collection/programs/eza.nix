{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkAfter mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.rum.programs.eza;
in
{
  options.rum.programs.eza = {
    enable = mkEnableOption "eza";

    package = mkPackageOption pkgs "eza" { nullable = true; };

    icons = lib.options.mkEnableOption "icons" // { default = true; };

    flags = lib.options.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "--group-directories-first" ];
      description = "Flags to pass to eza.";
    };

    integrations = {
      zsh.enable = mkEnableOption "eza integration with zsh";
    };
  };

  config = mkIf cfg.enable {
    packages = mkIf (cfg.package != null) [ cfg.package ];

    rum.programs.zsh.initConfig = mkIf cfg.integrations.zsh.enable (
      let
        flags = lib.strings.concatStringsSep " " (cfg.flags ++ lib.optional cfg.icons "--icons");
      in
      mkAfter ''
        alias ls="${getExe cfg.package} ${flags}"
        alias ll="${getExe cfg.package} -lh ${flags}"
        alias la="${getExe cfg.package} -la ${flags}"
        alias tree="${getExe cfg.package} --tree ${flags}"
      ''
    );
  };
}
