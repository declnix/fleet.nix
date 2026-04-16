{ den, programs, flakes, ... }:
{
  den.aspects.bundles.provides.console = {
    includes = (with den.aspects.programs._; [ bat eza fzf zoxide ]) ++ (with den.aspects.flakes._; [ tmf zef ]);
  };
}
