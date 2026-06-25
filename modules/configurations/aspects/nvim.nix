{ den, lib, ... }:
{
  den.aspects.nvim = {
    nixos = {
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
      };
    };

    hjem = {
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
      };
    };

    nvim = { pkgs, ... }:
      lib.mkMerge [
        {
          # ui
          theme.enable = true;
          tabline.nvimBufferline.enable = true;
          visuals.nvim-web-devicons.enable = true;
          mini.icons.enable = true;
        }
        {
          # completion
          autocomplete.blink-cmp = {
            enable = true;
            setupOpts = {
              sources = {
                default = lib.mkBefore [ "filemention" ];
                providers.filemention = {
                  name = "filemention";
                  module = "filemention.sources.blink";
                  enabled = true;
                  should_show_items = lib.generators.mkLuaInline ''
                    function(_, items)
                      return require("filemention").enabled(0) and #items > 0
                    end
                  '';
                };
              };
              keymap = {
                "<Down>" = [ "select_next" "fallback" ];
                "<Up>" = [ "select_prev" "fallback" ];
              };
              cmdline.keymap = {
                "<Down>" = [ "select_next" "show" "fallback" ];
                "<Up>" = [ "select_prev" "fallback" ];
              };
            };
          };
        }
        {
          # lsp
          lsp = {
            enable = true;
            formatOnSave = false;
            lspconfig.enable = true;
          };
          languages.nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
          };
          languages.markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };
        }
        {
          # fzf-lua
          fzf-lua.enable = true;
          maps.normal = {
            "<leader>ff" = {
              action = "<cmd>FzfLua files<CR>";
              desc = "Find files";
            };
            "<leader>fg" = {
              action = "<cmd>FzfLua live_grep<CR>";
              desc = "Search in files";
            };
            "<leader>fk" = {
              action = "<cmd>FzfLua keymaps<CR>";
              desc = "Find keymaps";
            };
            "<leader>fb" = {
              action = "<cmd>FzfLua buffers<CR>";
              desc = "Find buffers";
            };
            "<C-.>" = {
              action = "<cmd>FzfLua lsp_code_actions<CR>";
              desc = "Code actions";
            };
          };
        }
        {
          # file mentions
          extraPlugins.filemention.package = pkgs.vimUtils.buildVimPlugin {
            pname = "filemention.nvim";
            version = "unstable";
            src = pkgs.fetchFromGitHub {
              owner = "not-manu";
              repo = "filemention.nvim";
              rev = "d8aa9116fa441d0529c53bb5cb2c321f30d9544d";
              hash = "sha256-XeLy1GlSSD3xg5KZWQKJH+riTdcN8e2iIpF7dbGl2MY=";
            };
          };

          luaConfigPost = ''
            require('filemention').setup({
              root = "cwd",
            })
          '';
        }
        {
          # fyler
          extraPlugins.fyler.package = pkgs.vimPlugins.fyler-nvim;

          luaConfigPost = ''
            require('fyler').setup({
              configs = {
                window = {
                  kind = "floating",
                  relative = "editor",
                  border = "rounded",
                  width = 2000,
                  height = 1000,
                  row = 0,
                  col = 0,
                },
              },
            })
          '';

          maps.normal."<leader>e" = {
            action = "<cmd>Fyler<CR>";
            desc = "Toggle file explorer";
          };
        }
      ];
  };

  den.schema.user.includes = [
    ({ user, ... }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "nvim";
        intoClass = _: "hjem";
        intoPath = _: [ "nvf" "vim" ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; };
      })
  ];

  den.default.nixos.hjem.extraModules = lib.mkAfter [
    ({ inputs, lib, config, pkgs, ... }:
      let
        nvfInput = inputs.nvf or (throw "inputs.nvf is required in flake inputs.");
      in
      {
        options.nvf = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
        };

        config = {
          packages = [
            (nvfInput.lib.neovimConfiguration {
              inherit pkgs;
              modules = [ config.nvf ];
            }).neovim
          ];
        };
      })
  ];

  flake-file.inputs.nvf.url = "github:notashelf/nvf";
}
