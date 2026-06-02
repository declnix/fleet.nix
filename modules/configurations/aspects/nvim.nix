{ den, lib, ... }:
{
  den.aspects.nvim = {
    nvim = { pkgs, ... }:
      # ui
      {
        theme.enable = true;
        tabline.nvimBufferline.enable = true;
        visuals.nvim-web-devicons.enable = true;
        mini.icons.enable = true;
      } // {
        # completion
        autocomplete.blink-cmp.enable = true;
      } // {
        # lsp
        lsp = {
          enable = true;
          formatOnSave = true;
          lspconfig.enable = true;
        };
        languages.nix = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
        };
      } // {
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
        };
      } // {
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
  ];

  flake-file.inputs.nvf.url = "github:notashelf/nvf";
}
