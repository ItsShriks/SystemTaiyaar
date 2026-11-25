#!/bin/bash
# Weekly maintenance: update, move Downloads to iCloud, then clean.
# Reuses update.sh and clean.sh so the three steps never drift apart.
set -uo pipefail
source "$(dirname "$0")/lib.sh"

# Some cask upgrades ask for the admin password. Ask once upfront and keep
# sudo alive until this script ends, so nothing stalls halfway through.
if [ -t 0 ]; then
    echo "Enter your password once so cask upgrades don't stop to ask for it:"
    sudo -v && while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

# --greedy also upgrades casks that update themselves (Chrome, VS Code, ...)
BREW_GREEDY=1 bash "$REPO_DIR/Bootup/update.sh"

section "Moving Downloads to ☁️ Downloads"
SRC="$HOME/Downloads"
DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Downloads"
if [ ! -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
    warn "iCloud Drive not found, skipping"
elif ! compgen -G "$SRC/*" >/dev/null; then
    ok "Downloads folder is empty, skipping"
else
    mkdir -p "$DEST"
    moved=0 renamed=0
    for item in "$SRC"/*; do
        name="$(basename "$item")"
        target="$DEST/$name"
        # Never overwrite: a name already in iCloud gets " (2)", " (3)", ...
        if [ -e "$target" ]; then
            stem="$name" ext=""
            if [ ! -d "$item" ] && [[ "$name" == ?*.* ]]; then
                stem="${name%.*}" ext=".${name##*.}"
            fi
            n=2
            while [ -e "$DEST/$stem ($n)$ext" ]; do n=$((n + 1)); done
            target="$DEST/$stem ($n)$ext"
            warn "$name already in iCloud, saved as $(basename "$target")"
            renamed=$((renamed + 1))
        fi
        mv -n "$item" "$target" && moved=$((moved + 1))
    done
    ok "Moved $moved item(s) to ☁️ Downloads ($renamed renamed)"
fi

# Last, because mac-cleaner-cli waits for your input
bash "$REPO_DIR/Bootup/clean.sh"
