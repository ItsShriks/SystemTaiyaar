#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

status=0

section "Apps"
sudo apt-get install -y terminator || status=1
if command -v snap >/dev/null; then
    sudo snap install --classic code || status=1
else
    warn "snap not found, skipping VS Code"
fi

# NVIDIA GPUs Only
if command -v lspci >/dev/null && lspci | grep -qi nvidia; then
    section "NVIDIA drivers"
    sudo ubuntu-drivers install || status=1
fi

section "Miniconda"
if find_conda >/dev/null; then
    ok "Conda already installed"
else
    installer="$(mktemp -d)/miniconda.sh"
    # -b accepts the Anaconda license, as the interactive installer would ask you to
    if wget -q -O "$installer" "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh" &&
        bash "$installer" -b -p "$HOME/miniconda3"; then
        ok "Miniconda installed to ~/miniconda3"
    else
        warn "Miniconda install failed"
        status=1
    fi
fi

if [ -f "$REPO_DIR/requirements.txt" ]; then
    section "Python packages"
    "$(dirname "$(find_conda)")/pip" install -r "$REPO_DIR/requirements.txt" || status=1
fi

exit $status
