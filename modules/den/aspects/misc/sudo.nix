{
  den.aspects.misc.provides.sudo = {
    nixos = {
      security.sudo.enable = true;
      security.sudo.wheelNeedsPassword = false;
    };
  };
}
