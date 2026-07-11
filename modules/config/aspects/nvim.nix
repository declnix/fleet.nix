{ den, lib, inputs, ... }:
{
  den.aspects.nvim = {
    nvim = { pkgs, ... }:
      lib.mkMerge [
        {
          # ui
          theme.enable = true;
          tabline.nvimBufferline.enable = true;
          statusline.lualine.enable = true;
          visuals.nvim-web-devicons.enable = true;
          mini.icons.enable = true;

          luaConfigPost = ''
            vim.o.mouse = "a"
          '';
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
          fzf-lua = {
            enable = true;
            setupOpts = {
              keymap = {
                fzf = {
                  "ctrl-y" = "transform-query(pbpaste)";
                  "alt-v" = "transform-query(pbpaste)";
                };
              };
            };
          };
          keymaps = [
            {
              key = "<leader>ff";
              mode = "n";
              action = "<cmd>FzfLua files<CR>";
              desc = "Find files";
            }
            {
              key = "<leader>fg";
              mode = "n";
              action = "<cmd>FzfLua live_grep<CR>";
              desc = "Search in files";
            }
            {
              key = "<leader>fk";
              mode = "n";
              action = "<cmd>FzfLua keymaps<CR>";
              desc = "Find keymaps";
            }
            {
              key = "<leader>fb";
              mode = "n";
              action = "<cmd>FzfLua buffers<CR>";
              desc = "Find buffers";
            }
            {
              key = "<C-.>";
              mode = "n";
              action = "<cmd>FzfLua lsp_code_actions<CR>";
              desc = "Code actions";
            }
          ];
        }
        {
          # VS Code-style editor keymaps
          keymaps = [
            {
              key = "<C-Tab>";
              mode = "n";
              action = "<cmd>BufferLineCycleNext<CR>";
              desc = "Next buffer";
            }
            {
              key = "<C-S-Tab>";
              mode = "n";
              action = "<cmd>BufferLineCyclePrev<CR>";
              desc = "Previous buffer";
            }
            {
              key = "<F2>";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.rename()<CR>";
              desc = "Rename symbol";
            }
            {
              key = "<F12>";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.definition()<CR>";
              desc = "Go to definition";
            }
            {
              key = "<S-F12>";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.references()<CR>";
              desc = "Find references";
            }
          ];
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
              views = {
                finder = {
                  win = {
                    kind = "split_left_most",
                    kinds = {
                      split_left_most = {
                        width = 36,
                        options = {
                          winfixwidth = true,
                        },
                      },
                    },
                  },
                },
              },
            })
          '';

          keymaps = [
            {
              key = "<C-b>";
              mode = "n";
              action = "<cmd>lua require('fyler').toggle({ kind = 'split_left_most' })<CR>";
              desc = "Toggle file explorer";
            }
            {
              key = "<leader>e";
              mode = "n";
              action = "<cmd>lua require('fyler').toggle({ kind = 'split_left_most' })<CR>";
              desc = "Toggle file explorer";
            }
          ];
        }
      ];

    hjem = {
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
      };
    };

    nixos = {
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
      };
    };
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
    {
      _module.args.inputs = { inherit (inputs) nvf; };
    }
  ];

  flake-file.inputs.nvf.url = "github:notashelf/nvf";
}
