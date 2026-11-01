#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

command -v brew >/dev/null || die "Homebrew not found, run './setup.sh essentials' first"

section "Docker Desktop and XQuartz"
# XQuartz is the X server that Docker/Docker_Run.sh displays GUI apps on
brew install --cask docker-desktop xquartz || die "Install failed"
ok "Installed"

section "First run"
open -a Docker || warn "Could not open Docker Desktop"
echo "Accept the Docker Desktop prompts, then in XQuartz turn on"
echo "Settings > Security > 'Allow connections from network clients'."

if confirm "Build the image from Docker/Dockerfile now? Needs Docker running"; then
    docker build -t system-taiyaar "$REPO_DIR/Docker" || die "Docker build failed"
    ok "Built system-taiyaar"
fi
echo "Start a container with: bash Docker/Docker_Run.sh"
