{ lib, den, ... }:
{
  den.schema.user.includes = [
    ({ user, host }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "tmf";
        intoClass = _: "hjem";
        intoPath = _: [
          "flakes"
          "tmf"
        ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; };
      })
  ];
}
