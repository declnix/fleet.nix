{ den, lib, inputs, ... }:
{
  imports = [
    inputs.den.flakeModules.dendritic
  ];

  perSystem = { lib, ... }: {
    agents.instructions = lib.mkOrder 300 [
      ''
        ## Den File & Aspect Structure Ordering

        To keep configuration files consistent, follow this standardized order of keys/attributes:

        ### 1. File-Level Attribute Ordering

        Within a `.nix` configuration file, order the top-level attributes as follows:

        1. **Aspect Definition (`den.aspects.<name>`)**: Defines the feature/aspect; always at the top.
        2. **Policies (`den.policies.<name>`)**: Relations/routing between entities.
        3. **Schema Registrations (`den.schema.<type>.includes`)**: Wiring into the Den schema (e.g., custom class forwarders).
        4. **Target Extensions (`den.default.<target>.extraModules`)**: Auxiliary options and configurations.
        5. **Flake Source Declarations (`flake-file.inputs.<name>.url`)**: External input definitions at the very bottom.

        ### 2. Inner-Aspect Attribute Ordering

        Within a `den.aspects.<name> = { ... }` block, order attributes as follows:

        1. **Sub-aspects and Provisions (`provides` / `_`)**: Declared first to highlight exposed sub-capabilities.
        2. **Custom / Application Classes (`zsh`, `tmux`, `nvim`, etc.)**: App-level configuration.
        3. **User-level Classes (`hjem`, `homeManager`)**: Configurations targeted at the user environments.
        4. **System-level Classes (`nixos`, `darwin`)**: Configurations targeted at OS levels.
        5. **Auxiliary Account Classes (`user`)**: Base system user settings.
        6. **Composition / Includes (`includes`)**: Aspect dependencies, listed at the end.

        ### 3. Provides Attribute Style

        When an aspect has any `provides` entries, declare `provides` as a nested key inside the `den.aspects.<name> = { ... }` block, even if there is only one provision.

        Do not write provisions with chained top-level assignments such as:

        ```nix
        den.aspects.kr7va.provides.declnix.nixos = { ... };
        ```

        Prefer:

        ```nix
        den.aspects.kr7va = {
          provides.declnix.nixos = { ... };
        };
        ```

        ### 4. Inline Plugin Package Definitions

        For plugin-oriented aspects such as `zsh` and `tmux`, keep package fetches/builds inline with the plugin declaration that uses them. Do not hoist plugin packages into a shared outer `let` unless the same derivation is intentionally reused by multiple plugin entries or non-plugin settings.

        ### 5. Simple Console Tool Aspects

        For simple console tool aspects that only install a package and add shell aliases or hooks, prefer direct `hjem.packages` plus `zsh.initConfig`. Do not create a custom `rum.programs.<tool>` module or `den.default.nixos.hjem.extraModules` block unless the tool needs reusable options, conditional behavior, or non-trivial integration logic.
      ''
    ];
  };

  den.default.includes = (with den.batteries; [
    mutual-provider
    hostname
    define-user
    inputs'
  ])
  ++ (with den.aspects; [
    clipboard
    comma
    nix
  ]);

  den.default.nixos = {
    system.stateVersion = "25.11";
  };

  flake-file.inputs = {
    den.url = lib.mkDefault "github:denful/den";
  };
}
