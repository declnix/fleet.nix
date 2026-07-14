{ den, ... }:
{
  den.aspects.c4rg0x = {
    provides.nixos-user = { user, ... }: {
      nixos = {
        users.users.${user.userName}.initialPassword = "test";
      };

      includes = (with den.batteries; [
        primary-user
        (user-shell "zsh")
      ])
      ++ (with den.aspects; [ development zscaler ]);
    };

  };

  den.hosts.x86_64-linux.c4rg0x = {
    wsl.enable = true;
    users.nixos-user.userName = "nixos";
  };
}
