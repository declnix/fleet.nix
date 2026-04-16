{ ... }:
{
  den.aspects.flakes.provides.tmf = {
    tmf = {
      plugins = {
        sensible.enable = true;
        resurrect.enable = true;
        continuum.enable = true;
      };
      history = 50000;
      statusBar.enable = true;
      statusBar.position = "bottom";

      initExtra = ''
        set -g mouse on
        set -g status-style "bg=default"
        set -g status-left ""
        set -g status-right "#[fg=white,bold] #S"
        set -g window-status-format "#[fg=gray]  /#I:#W "
        set -g window-status-current-format "#[fg=cyan,bold]  /#I:#W "

        # Open new panes/windows in current directory
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        # New session with current directory name and switch
        bind C-s run-shell "tmux new-session -d -s \"$(basename #{pane_current_path})\" -c \"#{pane_current_path}\" \; switch-client -t \"$(basename #{pane_current_path})\""

        # Repeatable movement/swapping (using prefix)
        # Swap panes
        bind -r H swap-pane -U
        bind -r L swap-pane -D
        # Swap windows
        bind -r J swap-window -t -1
        bind -r K swap-window -t +1

        # Repeatable navigation
        # Navigate panes
        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R
        # Navigate windows
        bind -r p previous-window
        bind -r n next-window
      '';
    };
  };

  flake-file.inputs.tmf.url = "github:declnix/tmf";
}
