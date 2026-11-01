#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Essentials"
sudo apt-get update || die "apt update failed"
sudo apt-get install -y git curl wget ca-certificates build-essential openssh-client xclip unzip || die "apt install failed"
ok "Essentials installed"

section "Git identity"
for key in user.name user.email; do
    if [ -z "$(git config --global "$key")" ] && [ -t 0 ]; then
        read -r -p "git $key: " value
        [ -n "$value" ] && git config --global "$key" "$value"
    fi
    echo "$key = $(git config --global "$key")"
done
