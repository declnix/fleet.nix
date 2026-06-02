{
  den.aspects.ssh = {
    nixos = {
      services.openssh = {
        enable = true;
        ports = [ 2222 ];
        settings = {
          PasswordAuthentication = true;
          KbdInteractiveAuthentication = true;
          PermitRootLogin = "no";
          X11Forwarding = false;
        };
      };
    };
  };
}
