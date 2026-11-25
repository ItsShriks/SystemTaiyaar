#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "RC files"
BACKUP_DIR="$HOME/.system-taiyaar-backup/$(date +%Y%m%d-%H%M%S)"
LOCAL_GITCONFIG="$HOME/.gitconfig.local"

# The shared .gitconfig has no name or email, so keep yours in ~/.gitconfig.local
# before an old ~/.gitconfig gets backed up.
if [ -f "$HOME/.gitconfig" ] && [ ! "$HOME/.gitconfig" -ef "$REPO_DIR/rc files/.gitconfig" ]; then
    for key in user.name user.email; do
        value="$(git config --file "$HOME/.gitconfig" --get "$key")"
        if [ -n "$value" ] && [ -z "$(git config --file "$LOCAL_GITCONFIG" --get "$key" 2>/dev/null)" ]; then
            git config --file "$LOCAL_GITCONFIG" "$key" "$value"
            ok "Kept git $key in ~/.gitconfig.local"
        fi
    done
fi

for name in .zshrc .zsh_aliases .gitconfig .gitignore_global; do
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

if [ -z "$(git config --file "$LOCAL_GITCONFIG" --get user.email 2>/dev/null)" ]; then
    warn "No git name/email yet. Run './setup.sh essentials' or: git config --file ~/.gitconfig.local user.email you@example.com"
fi
echo "Run 'source ~/.zshrc' or open a new terminal to use them."
