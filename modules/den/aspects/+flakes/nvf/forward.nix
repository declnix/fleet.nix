{ lib, den, pkgs, ... }:
{
  den.schema.user.includes = [
    ({ user, ... }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "nvf";
        intoClass = _: "hjem";
        intoPath = _: [
          "flakes"
          "nvf"
          "vim"
        ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; };
      })
  ];
}
