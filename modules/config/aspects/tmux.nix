{ lib, den, inputs, ... }:
{
  den.aspects.tmux = {
    tmux = {
      history.limit = 50000;
      tmux-resurrect.enable = true;
      tmux-continuum.enable = true;
      tmux-continuum.boot.startCommand = "new-session -Ad -s default";
      status.enable = true;
      status.position = "bottom";

      initExtra = ''
        set -g mouse on
        set -g status-style "bg=default"
        set -g status-left ""
        set -g status-right "#[fg=white,bold] #S"
        set -g window-status-format "#[fg=gray]  /#I:#W "
        set -g window-status-current-format "#[fg=cyan,bold]  /#I:#W "

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

    user = {
      linger = true;
    };
  };

  den.schema.user.includes = [
    ({ user }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "tmux";
        intoClass = _: "hjem";
        intoPath = _: [ "flakes" "tmux" ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; };
      })
  ];

  den.default.nixos.hjem.extraModules = lib.mkAfter [
    ({ inputs, lib, config, pkgs, ... }:
      let
        tmuxNixInput = inputs.tmux-nix or (throw "inputs.tmux-nix is required in flake inputs.");
        tmuxConfig = tmuxNixInput.lib.tmuxConfiguration {
          inherit pkgs;
          modules = [ config.flakes.tmux ];
        };
      in
      {
        options.flakes.tmux = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
        };

        config = {
          files.".config/tmux/tmux.conf".source = "${tmuxConfig}/.tmux.conf";
          packages = [ pkgs.tmux ];
          systemd.services.tmux-default-session = {
            description = "Tmux default session";
            wantedBy = [ "default.target" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${lib.getExe pkgs.tmux} -f %h/.config/tmux/tmux.conf new-session -Ad -s default";
              RemainAfterExit = true;
            };
          };
        };
      })
    {
      _module.args.inputs = { inherit (inputs) tmux-nix; };
    }
  ];

  flake-file.inputs.tmux-nix.url = "github:declnix/tmux.nix";
}
