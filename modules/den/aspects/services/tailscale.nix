{
  den.aspects.services.provides.tailscale = {
    nixos = {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    };
  };
}
