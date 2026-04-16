{ lib, ... }:
{
  den.aspects.flakes.provides.nvf.provides.fyler = {
    nvf = { pkgs, ... }: {
      extraPlugins = {
        fyler = {
          package = pkgs.vimPlugins.fyler-nvim;
        };
      };
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
      maps = {
        normal = {
          "<leader>e" = {
            action = "<cmd>Fyler<CR>";
            desc = "Toggle file explorer";
          };
        };
      };
    };
  };
}
