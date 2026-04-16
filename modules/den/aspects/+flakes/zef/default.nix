{ pkgs, ... }:
{
  den.aspects.flakes.provides.zef = {
    zef = {
      plugins = {
        vi-mode.enable = true;
        autosuggestions.enable = true;
        syntax-highlighting.enable = true;
        fzf-tab.enable = true;
        fzf-history-search.enable = true;
        omz.git.enable = true;
      };

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

  flake-file.inputs.zef.url = "github:declnix/zef";
}
