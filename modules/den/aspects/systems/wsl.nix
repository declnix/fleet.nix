{ den
, lib
, core
, ...
}:
{
  den.aspects.systems.provides.wsl = {
    wsl = {
      interop.register = true;
    };

    nixos = {
      programs.nix-ld.enable = true;
    };

    hjem = {
      rum.programs.git.settings.credential.helper =
        "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
    };
  };

  # Policy: if wsl is enabled, include our extra settings automatically
  den.policies.wsl-extras =
    { host, ... }:
    lib.optional ((host.wsl or { }).enable or false) (den.lib.policy.include den.aspects.systems.provides.wsl);

  den.schema.host.includes = [ den.policies.wsl-extras ];

  flake-file.inputs.nixos-wsl.url = "github:nix-community/nixos-wsl";
}
