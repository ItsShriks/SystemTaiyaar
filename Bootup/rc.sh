#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "RC files"
BACKUP_DIR="$HOME/.system-taiyaar-backup/$(date +%Y%m%d-%H%M%S)"

for name in .bashrc .bash_aliases; do
    source_file="$REPO_DIR/rc files/$name"
    target="$HOME/$name"
    if [ "$target" -ef "$source_file" ]; then
        ok "$name already linked"
        continue
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/$name"
        warn "Backed up existing $name to $BACKUP_DIR"
    fi
    ln -s "$source_file" "$target"
    ok "Linked $name"
done
echo "Run 'source ~/.bashrc' or open a new terminal to use them."
