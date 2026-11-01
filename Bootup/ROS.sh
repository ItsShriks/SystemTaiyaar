#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

ROBOSTACK_DIR="$HOME/robostack"
DEFAULT_ENVS="humble noetic" # The environments behind the rosex2 and rosex aliases

section "Pixi"
export PATH="$HOME/.pixi/bin:$PATH"
if command -v pixi >/dev/null; then
    ok "Pixi already installed"
else
    brew install pixi || die "Pixi install failed"
fi

section "RoboStack"
mkdir -p "$ROBOSTACK_DIR"
if [ -f "$ROBOSTACK_DIR/pixi.toml" ]; then
    cmp -s "$REPO_DIR/robostack/pixi.toml" "$ROBOSTACK_DIR/pixi.toml" ||
        warn "Keeping your $ROBOSTACK_DIR/pixi.toml, which differs from the repo copy"
else
    cp "$REPO_DIR/robostack/pixi.toml" "$ROBOSTACK_DIR/pixi.toml"
    ok "Copied pixi.toml to $ROBOSTACK_DIR"
fi

envs="$DEFAULT_ENVS"
if [ -t 0 ]; then
    read -r -p "Environments to install: noetic humble jazzy kilted [$DEFAULT_ENVS]: " reply
    envs="${reply:-$DEFAULT_ENVS}"
fi

status=0
for env in $envs; do
    section "Installing $env (this takes a while)"
    if pixi install --manifest-path "$ROBOSTACK_DIR/pixi.toml" -e "$env"; then
        ok "$env installed"
    else
        warn "$env failed"
        status=1
    fi
done
echo "Activate with the rosex2 (humble) or rosex (noetic) aliases."
exit $status
