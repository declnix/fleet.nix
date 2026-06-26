{ pkgs, lib, den, ... }:
{
  den.aspects.zsh = {
    zsh = {
      shell = {
        editing = {
          viMode.enable = true;
          autosuggestions.enable = true;
        };

        highlighting.enable = true;

        completion = {
          fzfTab.enable = true;
          fzfHistory.enable = true;
        };
      };

      integrations.git.enable = true;

      initExtra = ''
        if [[ -n $SSH_CLIENT ]]; then
          PROMPT="%F{green}%n@%m%f %B%F{magenta}❯%f%b "
        else
          PROMPT="%B%F{magenta}❯%f%b "
        fi
      '';

      history = {
        size = 50000;
        save = 50000;
      };

      setopt = [
        "APPEND_HISTORY"
        "HIST_IGNORE_SPACE"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_SAVE_NO_DUPS"
        "HIST_FIND_NO_DUPS"
      ];
    };
  };

  den.schema.user.includes = [
    ({ user }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "zsh";
        intoClass = _: "hjem";
        intoPath = _: [ "zsh-nix" ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; };
      })
  ];

  den.default.nixos.hjem.extraModules = lib.mkAfter [
    ({ inputs, lib, config, pkgs, ... }:
      let
        zsh-nix = inputs.zsh-nix or (throw "inputs.zsh-nix is required in flake inputs.");
        zshConfig = zsh-nix.lib.zshConfiguration {
          inherit pkgs;
          modules = [ config.zsh-nix ];
        };
      in
      {
        options.zsh-nix = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
        };

        config = {
          rum.programs.zsh = {
            enable = true;
            initConfig = lib.mkBefore (builtins.readFile "${zshConfig}/.zshrc");
          };
        };
      })
  ];

  flake-file.inputs.zsh-nix.url = "github:declnix/zsh.nix";
}
