{ lib, den, ... }:
{
  den.schema.user.includes = [
    ({ user, host }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "zef";
        intoClass = _: "hjem";
        intoPath = _: [
          "flakes"
          "zef"
        ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; };
      })
  ];
}
