#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

CHECKBOX_VERSION="5.2.8" # The menu library, pinned like mac-cleaner-cli in clean.sh

command -v brew >/dev/null || die "Homebrew not found, run './setup.sh essentials' first"

BREWFILE="$REPO_DIR/Brewfile"

# Sets BREWFILE to just the ticked apps
pick_apps() {
    local work_dir picker_status
    work_dir="$(mktemp -d)"
    cp "$REPO_DIR/Bootup/pick-apps.mjs" "$work_dir/" || return 1
    command -v npm >/dev/null || return 1
    npm install --silent --no-audit --no-fund --prefix "$work_dir" "@inquirer/checkbox@$CHECKBOX_VERSION" || return 1
    node "$work_dir/pick-apps.mjs" "$BREWFILE" "$work_dir/Brewfile"
    picker_status=$?
    [ $picker_status -eq 130 ] && { warn "Cancelled, nothing installed."; exit 0; }
    [ $picker_status -eq 0 ] || return 1
    BREWFILE="$work_dir/Brewfile"
}

# Without a terminal there is nobody to tick boxes, so install the whole Brewfile
if [ -t 0 ] && ! pick_apps; then
    confirm "The app menu could not start. Install everything in the Brewfile?" || exit 1
fi

if [ ! -s "$BREWFILE" ]; then
    warn "Nothing ticked, nothing to install."
    exit 0
fi

section "Installing the selected apps"
warn "App Store apps need you to be signed in to the App Store first."
status=0
brew bundle --file "$BREWFILE" || status=1

section "Tidying up"
brew autoremove
brew cleanup

if [ $status -ne 0 ]; then
    warn "Some apps failed, see above. Re-run to retry only those."
fi
exit $status
