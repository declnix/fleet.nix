{ pkgs, lib, den, inputs, ... }:
{
  den.aspects.zsh = {
    zsh =
      { pkgs, inputs, lib, ... }:
      let
        patinaSrc = inputs.zsh-patina;
        patinaManifest = (lib.importTOML (patinaSrc + "/Cargo.toml")).package;
        patina = pkgs.rustPlatform.buildRustPackage {
          pname = patinaManifest.name;
          version = patinaManifest.version;
          src = patinaSrc;
          cargoLock.lockFile = patinaSrc + "/Cargo.lock";
        };

        fzf-tab = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "e394092c17277c84cb3d234917c4ac1073102ba6";
          sha256 = "sha256-WlmWLKHrLeptc5rqlHbKvthD73it9ij7IDT9QxN4jCc=";
        };
      in
      {
        plugins = {
          vi-mode = {
            package = pkgs.zsh-vi-mode;
            source = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          };

          autosuggestions = {
            package = pkgs.zsh-autosuggestions;
            source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          };

          autoenv = {
            package = pkgs.zsh-autoenv;
            source = "share/zsh-autoenv/autoenv.plugin.zsh";
          };

          syntax-highlighting = {
            package = patina;
            source = null;
            init = ''
              eval "$(${patina}/bin/zsh-patina activate)"
            '';
            after = [ "autosuggestions" ];
          };

          fzf-tab = {
            load = "idle";
            package = fzf-tab;
            source = "fzf-tab.plugin.zsh";
            init = "enable-fzf-tab";
          };

          fzf-history-search = {
            load = "idle";
            package = pkgs.zsh-fzf-history-search;
            source = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
          };

          omz-git = {
            load = "idle";
            package = pkgs.oh-my-zsh;
            sources = [
              "share/oh-my-zsh/lib/git.zsh"
              "share/oh-my-zsh/plugins/git/git.plugin.zsh"
            ];
          };
        };

        initConfig = ''
          HISTFILE="$HOME/.zsh_history"
          HISTSIZE=50000
          SAVEHIST=50000
          [[ -d "''${HISTFILE:h}" ]] || mkdir -p "''${HISTFILE:h}"

          setopt APPEND_HISTORY
          setopt HIST_IGNORE_SPACE
          setopt HIST_IGNORE_ALL_DUPS
          setopt HIST_SAVE_NO_DUPS
          setopt HIST_FIND_NO_DUPS

          PROMPT="%B%F{magenta}#%f%b "
        '';
      };

    includes = [
      (den.batteries.unfree [ "zsh-autoenv" ])
    ];
  };

  den.schema.user.includes = [
    ({ user }:
      den.batteries.forward {
        each = lib.singleton user;
        fromClass = _: "zsh";
        intoClass = _: "hjem";
        intoPath = _: [ "zsh" ];
        fromAspect = u: u.aspect;
        adaptArgs = args: { inherit (args) pkgs; inherit inputs lib; };
      })
  ];

  den.default.nixos.hjem.extraModules = lib.mkAfter [
    ({ inputs, lib, config, ... }:
      let
        dag = inputs.dag.lib { inherit lib; };

        renderPlugin = p:
          lib.concatStringsSep "\n" (
            (map (s: "source ${p.package}/${s}") (lib.optional (p.source != null) p.source ++ p.sources))
            ++ (lib.optional (p.init != "") p.init)
          );

        toDagEntry = name: p: {
          inherit name;
          value = dag.entryAfter p.after (renderPlugin p);
        };

        renderPluginDag = plugins:
          dag.render {
            entries = lib.listToAttrs (lib.mapAttrsToList toDagEntry plugins);
          };

        startupPlugins = lib.filterAttrs (_: p: p.load == "startup") config.zsh.plugins;
        idlePlugins = lib.filterAttrs (_: p: p.load == "idle") config.zsh.plugins;

        idleHookScript = ''
          autoload -Uz add-zsh-hook
          _nix_zsh_idle_check() {
            if (( KEYS_QUEUED_COUNT || PENDING )); then
              sched +1 _nix_zsh_idle_check
            else
              ${renderPluginDag idlePlugins}
            fi
          }
          _nix_zsh_idle_init() {
            add-zsh-hook -d precmd _nix_zsh_idle_init
            _nix_zsh_idle_check
          }
          add-zsh-hook precmd _nix_zsh_idle_init
        '';

        pluginSubmodule = lib.types.submodule {
          options = {
            package = lib.mkOption {
              type = lib.types.package;
              description = "Package containing plugin scripts.";
            };

            source = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Single plugin script path inside the package.";
            };

            sources = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Ordered plugin script paths inside the package.";
            };

            init = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Zsh commands run after sourcing plugin files.";
            };

            after = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Plugin names that must load before this plugin.";
            };

            load = lib.mkOption {
              type = lib.types.enum [ "startup" "idle" ];
              default = "startup";
              description = "Whether to load the plugin during startup or from the idle hook.";
            };
          };
        };
      in
      {
        options.zsh = {
          plugins = lib.mkOption {
            type = lib.types.attrsOf pluginSubmodule;
            default = { };
            description = "Zsh plugins rendered into rum.programs.zsh.initConfig.";
          };

          initConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Zsh commands emitted after rendered plugins.";
          };
        };

        config = {
          rum.programs.zsh = {
            enable = true;
            initConfig = lib.mkBefore ''
              ${renderPluginDag startupPlugins}
              ${lib.optionalString (idlePlugins != { }) idleHookScript}
              ${config.zsh.initConfig}
            '';
          };
        };
      })
  ];

  flake-file.inputs = {
    dag.url = "github:denful/dag";

    zsh-patina = {
      url = "github:michel-kraemer/zsh-patina";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
