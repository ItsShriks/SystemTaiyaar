#!/bin/bash
# Shared helpers, sourced by every script in Bootup/.

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
SEPARATOR="${BLUE}------------------------------------------------------------${NC}"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

section() { echo -e "\n$SEPARATOR\n>>> $1\n$SEPARATOR"; }
ok()      { echo -e "${GREEN}$1${NC}"; }
warn()    { echo -e "${YELLOW}$1${NC}"; }
die()     { echo -e "${RED}Error: $1${NC}" >&2; exit 1; }

# Usage: confirm "Question" [y|n]. Takes the default when there is no terminal.
confirm() {
    local default="${2:-n}" hint="y/N" reply
    [ "$default" = y ] && hint="Y/n"
    if [ ! -t 0 ]; then
        [ "$default" = y ]
        return
    fi
    read -r -p "$1 ($hint): " reply
    [[ "${reply:-$default}" =~ ^[Yy]$ ]]
}

# Prints the path of the conda binary, wherever it was installed.
find_conda() {
    local root
    if [ -n "${CONDA_EXE:-}" ] && [ -x "$CONDA_EXE" ]; then
        echo "$CONDA_EXE"
        return 0
    fi
    for root in "$HOME/miniconda3" "$HOME/miniforge3" "$HOME/anaconda3"; do
        if [ -x "$root/bin/conda" ]; then
            echo "$root/bin/conda"
            return 0
        fi
    done
    return 1
}
