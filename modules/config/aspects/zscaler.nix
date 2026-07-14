{ ... }:
{
  den.aspects.zscaler = {
    nixos =
      { lib, pkgs, ... }:
      {
        security.pki.certificateFiles = [
          "${pkgs.zscaler-cacert}/etc/ssl/certs/zscaler-ca.crt"
        ];

        nix.settings.ssl-cert-file =
          "/etc/ssl/certs/ca-certificates.crt";

        systemd.services.nix-daemon.serviceConfig.Environment = lib.mkAfter [
          "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
          "CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt"
        ];
      };
  };
}
