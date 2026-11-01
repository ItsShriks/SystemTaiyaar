#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Running: Homebrew Update"
brew update
ok "Homebrew update completed"

section "Running: Homebrew Upgrade"
brew upgrade
ok "Homebrew upgrade completed"

if CONDA_BIN="$(find_conda)"; then
    section "Running: conda update -n base conda"
    "$CONDA_BIN" update -n base conda -y
    ok "Base Conda update completed"

    section "Running: conda update --all"
    "$CONDA_BIN" update -n base --all -y
    ok "All Conda packages update completed"
else
    warn "Conda not found, skipping"
fi
