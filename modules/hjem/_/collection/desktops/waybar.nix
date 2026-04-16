{ config
, pkgs
, lib
, ...
}:
{
  options.rum.programs.waybar = {
    enable = lib.mkEnableOption "waybar";
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
    extraStyle = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };
  config = lib.mkIf config.rum.programs.waybar.enable {
    packages = [ pkgs.waybar ];
    files.".config/waybar/config".text = config.rum.programs.waybar.extraConfig;
    files.".config/waybar/style.css".text = config.rum.programs.waybar.extraStyle;
  };
}
