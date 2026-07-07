{ lib, ... }: {
  den.aspects.bur34u = {
    nixos = {
      systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "-/etc/proxy";

      security.sudo.extraConfig = ''
        Defaults env_keep += "${lib.concatStringsSep " " [
          "http_proxy"
          "https_proxy"
          "no_proxy"
          "HTTP_PROXY"
          "HTTPS_PROXY"
          "NO_PROXY"
        ]}"
      '';
    };

    provides.to-users = {
      zsh = {
        initConfig = ''
          if [ -f /etc/proxy ]; then
            set -a; source /etc/proxy; set +a
          fi
        '';
      };
    };
  };
}
