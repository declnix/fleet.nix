{ den, ... }:
{
  den.aspects.kr7va.provides.declnix = {
    hjem = { pkgs, ... }: {
      packages = with pkgs; [
        claude-code
        codex
        gemini-cli
      ];
    };

    includes = [
      (den.batteries.unfree [ "claude-code" ])
    ];
  };
}
