#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Homebrew"
if command -v brew >/dev/null; then
    ok "Homebrew already installed"
else
    # Also installs the Xcode Command Line Tools
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || die "Homebrew install failed"
    load_brew || die "Homebrew installed but brew was not found"
fi

if ! grep -qs "brew shellenv" "$HOME/.zprofile"; then
    echo "eval \"\$($(command -v brew) shellenv zsh)\"" >> "$HOME/.zprofile"
    ok "Added Homebrew to ~/.zprofile"
fi

section "Essentials"
brew install git gh glab node || die "brew install failed"
ok "Essentials installed"

section "Git identity"
for key in user.name user.email; do
    if [ -z "$(git config --global "$key")" ] && [ -t 0 ]; then
        read -r -p "git $key: " value
        [ -n "$value" ] && git config --global "$key" "$value"
    fi
    echo "$key = $(git config --global "$key")"
done
