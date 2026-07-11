# Global Instructions

- Commit messages: use `scope: short description`, e.g. `kr7va: add audio support`.
- Before any Nix operation, run `git add .` so new files are tracked.

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
