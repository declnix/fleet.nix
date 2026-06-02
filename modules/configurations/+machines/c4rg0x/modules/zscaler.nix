{ ... }:
{
  den.aspects.c4rg0x.provides.declnix.nixos =
    { pkgs, ... }:
    {
      security.pki.certificateFiles = [
        "${pkgs.zscaler-cacert}/etc/ssl/certs/zscaler-ca.crt"
      ];
    };
}
