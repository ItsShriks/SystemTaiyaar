#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

MAC_CLEANER_VERSION="1.3.5" # Pinned because it deletes files; bump after checking a new release

section "Running: Homebrew Clean"
if command -v brew >/dev/null; then
    # brew cleanup -s
    brew cleanup
    ok "Brew Cleanup completed"

    section "Autoremoving Brew"
    brew autoremove
    ok "Brew Autoremove completed"
else
    warn "Homebrew not found, skipping"
fi

section "Running: conda clean --all -y"
if CONDA_BIN="$(find_conda)"; then
    "$CONDA_BIN" clean --all -y
    ok "Conda Cleanup completed"
else
    warn "Conda not found, skipping"
fi

section "Running: mac-cleaner-cli"
if ! command -v npx >/dev/null; then
    warn "npx not found, run './setup.sh essentials' first. Skipping"
elif [ ! -t 0 ]; then
    warn "mac-cleaner-cli asks what to delete and needs a terminal. Skipping"
else
    # Interactive: it scans, then lets you pick what to delete
    npx --yes "mac-cleaner-cli@$MAC_CLEANER_VERSION"
fi
