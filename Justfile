set shell := ["bash", "-c"]
set quiet := true

# Default host
host := `hostname`

# --- System Management ---

# [switch] Apply configuration to the current system
switch host=host:
    sudo nixos-rebuild switch --flake ".#{{host}}" --show-trace

# [boot] Schedule configuration change for next reboot
boot host=host:
    sudo nixos-rebuild boot --flake ".#{{host}}"

# [vm] Build and test configuration in a local VM
vm host=host:
    nixos-rebuild build-vm --flake ".#{{host}}"
    ./result/bin/run-{{host}}-vm

# --- Flake & Development ---

# [update] Update all flake inputs or a specific one
update input="":
    #!/usr/bin/env bash
    if [ -z "{{input}}" ]; then
        nix flake update
    else
        nix flake update "{{input}}"
    fi

# [fmt] Format all code in the repository
fmt:
    nix fmt

# [check] Verify configuration integrity
check:
    nix flake check --show-trace

# --- Maintenance ---

# [cleanup] Deep system garbage collection and optimization
cleanup:
    sudo nix-collect-garbage -d
    sudo nix-store --optimise
    nix-store --gc

# --- Help ---
default:
    @just --list
