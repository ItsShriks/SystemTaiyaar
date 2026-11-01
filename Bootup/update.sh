#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Running: apt update and upgrade"
sudo apt-get update && sudo apt-get upgrade -y
ok "Apt upgrade completed"

if command -v snap >/dev/null; then
    section "Running: snap refresh"
    sudo snap refresh
    ok "Snap refresh completed"
fi

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
