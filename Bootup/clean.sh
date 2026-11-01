#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Running: conda clean --all -y"
if CONDA_BIN="$(find_conda)"; then
    "$CONDA_BIN" clean --all -y
    ok "Conda Cleanup completed"
else
    warn "Conda not found, skipping"
fi

section "Running: apt autoremove and clean"
sudo apt-get autoremove -y
sudo apt-get clean
ok "Apt Cleanup completed"
