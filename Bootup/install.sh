#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

command -v brew >/dev/null || die "Homebrew not found, run './setup.sh essentials' first"

section "Installing everything in the Brewfile"
warn "App Store apps need you to be signed in to the App Store first."
status=0
brew bundle --file "$REPO_DIR/Brewfile" || status=1

section "Tidying up"
brew autoremove
brew cleanup

if [ $status -ne 0 ]; then
    warn "Some Brewfile entries failed, see above. Re-run to retry only those."
fi
exit $status
