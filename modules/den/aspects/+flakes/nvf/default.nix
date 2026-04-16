{ den
, lib
, flakes
, ...
}:
{
  imports = [
    ./extraPlugins/fyler.nix
  ];

  den.aspects.flakes.provides.nvf = {
    nvf = { pkgs, ... }: {
      theme.enable = true;
      tabline.nvimBufferline.enable = true;
      visuals.nvim-web-devicons.enable = true;
      mini.icons.enable = true;
      autocomplete.blink-cmp.enable = true;
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
      maps = {
        normal = {
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
            desc = "Find keymaps";
          };
        };
      };
      fzf-lua.enable = true;
    };

    includes = with den.aspects.flakes.provides.nvf._; [ fyler ];
  };
  flake-file.inputs.nvf.url = "github:notashelf/nvf";
}
