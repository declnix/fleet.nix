set shell := ["bash", "-c"]
set quiet := true

host := `hostname`
hosts := "bur34u c4rg0x kr7va"

[no-exit-message]
_check_host host:
    @case " {{hosts}} " in \
      *" {{host}} "*) ;; \
      *) echo '¯\_(ツ)_/¯  Choose a host from modules/config/+machines.'; exit 1 ;; \
    esac

# [build] Build configuration for host
[no-exit-message]
build host=host:
    @just _check_host "{{host}}" 2>/dev/null
    nixos-rebuild build --flake ".#{{host}}" --show-trace --accept-flake-config

# [switch] Apply configuration to host
[no-exit-message]
switch host=host:
    @just _check_host "{{host}}" 2>/dev/null
    @if [ -f "modules/config/+machines/{{host}}/Makefile" ]; then make -C "modules/config/+machines/{{host}}"; fi
    sudo nixos-rebuild switch --flake ".#{{host}}" --show-trace --accept-flake-config

# [boot] Schedule configuration for next boot
[no-exit-message]
boot host=host:
    @just _check_host "{{host}}" 2>/dev/null
    sudo nixos-rebuild boot --flake ".#{{host}}" --accept-flake-config

# [format] Format repository
format:
    nix fmt

# [check] Verify flake
check:
    nix flake check --show-trace --accept-flake-config

default:
    @just --list
