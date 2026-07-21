{ den
, ...
}:
{
  den.aspects.bur34u = {
    provides.nixos-user = { user, ... }: {
      nvim = {
        # LSP server presets
        lsp.presets = {
          angular-language-server.enable = true;
          typescript-language-server.enable = true;
        };

        # TypeScript LSP configuration
        lsp.servers.typescript-language-server.filetypes = [
          "typescript"
          "typescriptreact"
          "javascript"
          "javascriptreact"
        ];


        # Language support
        languages = {
          typescript = {
            enable = true;
            lsp = {
              enable = true;
              servers = [ "angular-language-server" ];
            };
            treesitter.enable = true;
          };

          html = {
            enable = true;
            lsp = {
              enable = true;
              servers = [ "angular-language-server" ];
            };
            treesitter.enable = true;
          };

          css = {
            enable = true;
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };

          java = {
            enable = true;
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };

          kotlin = {
            enable = true;
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };
        };
      };

      zsh = { pkgs, ... }: {
        plugins = {
          omz-mvn = {
            load = "idle";
            package = pkgs.oh-my-zsh;
            source = "share/oh-my-zsh/plugins/mvn/mvn.plugin.zsh";
          };

          omz-npm = {
            load = "idle";
            package = pkgs.oh-my-zsh;
            source = "share/oh-my-zsh/plugins/npm/npm.plugin.zsh";
          };
        };
      };

      hjem = { pkgs, ... }: {
        environment.sessionVariables.JDTLS_JVM_ARGS = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
      };

      nixos = {
        users.users.${user.userName}.initialPassword = "test";
      };

      includes = [
        den.batteries.primary-user
        (den.batteries.user-shell "zsh")
      ]
      ++ [ den.aspects.development ];
    };

    nixos = {
      # Reserve ports for local development services.
      boot.kernel.sysctl."net.ipv4.ip_local_reserved_ports" = "61000-64999";
    };

    includes = with den.aspects; [ podman fonts ];
  };

  den.hosts.x86_64-linux.bur34u = {
    wsl.enable = true;
    users.nixos-user.userName = "nixos";
  };
}
