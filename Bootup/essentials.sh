#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Essentials"
sudo apt-get update || die "apt update failed"
sudo apt-get install -y git curl wget ca-certificates build-essential openssh-client xclip unzip || die "apt install failed"
ok "Essentials installed"

section "GitHub CLI"
if command -v gh >/dev/null; then
    ok "gh already installed"
else
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg || die "Could not download the GitHub CLI key"
    sudo chmod a+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
        sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update && sudo apt-get install -y gh || die "gh install failed"
    ok "gh installed"
fi

section "GitLab CLI"
if command -v glab >/dev/null; then
    ok "glab already installed"
elif command -v snap >/dev/null && sudo snap install glab; then
    ok "glab installed"
else
    warn "Could not install glab. The ssh step will show how to add your key by hand."
fi

section "Git identity"
for key in user.name user.email; do
    if [ -z "$(git config --global "$key")" ] && [ -t 0 ]; then
        read -r -p "git $key: " value
        [ -n "$value" ] && git config --global "$key" "$value"
    fi
    echo "$key = $(git config --global "$key")"
done
