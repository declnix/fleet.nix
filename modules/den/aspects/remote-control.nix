{ den, ... }:
{
  den.aspects.bundles.provides.remote-control = {
    includes = (with den.aspects.services._; [ tailscale ssh ]);
  };
}
