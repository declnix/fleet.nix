{ den, ... }:
{
  den.aspects.bundles.provides.development = {
    includes = (with den.aspects.bundles._; [ console ]) ++ (with den.aspects.programs._; [ direnv git ripgrep devbox ]) ++ (with den.aspects.flakes._; [ nvf ]);
  };
}
