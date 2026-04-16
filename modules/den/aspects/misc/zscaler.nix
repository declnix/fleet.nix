{ ... }:
{
  den.aspects.misc.provides.zscaler = {
    nixos =
      { pkgs, ... }:
      {
        security.pki.certificateFiles = [
          "${pkgs.zscaler-cacert}/etc/ssl/certs/zscaler-ca.crt"
        ];
      };
  };
}
