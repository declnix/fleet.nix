set shell := ["bash", "-c"]
set quiet := true

host := `hostname`
machines_dir := "modules/config/+machines"

[no-exit-message]
_check_host host:
    @if [ ! -d "{{machines_dir}}/{{host}}" ]; then echo '¯\_(ツ)_/¯  Choose a host from {{machines_dir}}.'; exit 1; fi

# [build] Build configuration for host
[no-exit-message]
build host=host:
    @just _check_host "{{host}}" 2>/dev/null
    nixos-rebuild build --flake ".#{{host}}" -L --show-trace --accept-flake-config

# [switch] Apply configuration to host
[no-exit-message]
switch host=host:
    @just _check_host "{{host}}" 2>/dev/null
    @if [ -f "{{machines_dir}}/{{host}}/Makefile" ]; then printf '\033[1;36m󰙨  make  \033[0;36m%s\033[0m\n\033[0;36m------------------------\033[0m\n' "{{host}}"; make -s -C "{{machines_dir}}/{{host}}" all; fi
    @printf '\n\033[1;32m󱄅  switch  \033[0;32m%s\033[0m\n\033[0;32m------------------------\033[0m\n' "{{host}}"
    nixos-rebuild switch --flake ".#{{host}}" --elevate=sudo  -L --show-trace --accept-flake-config
    @printf '\n'

# [boot] Schedule configuration for next boot
[no-exit-message]
boot host=host:
    @just _check_host "{{host}}" 2>/dev/null
    nixos-rebuild boot --flake ".#{{host}}" --elevate=sudo -L --accept-flake-config

# [format] Format repository
format:
    nix fmt

# [check] Verify flake
check:
    nix flake check --show-trace --accept-flake-config

default:
    @just --list
