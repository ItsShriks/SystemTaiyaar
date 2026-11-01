#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

section "Docker apt repository"
sudo apt-get update || die "apt update failed"
sudo apt-get install -y ca-certificates curl || die "apt install failed"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || die "Could not download the Docker key"
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<SOURCES
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
SOURCES

section "Docker Engine and Compose"
sudo apt-get update || die "apt update failed"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || die "Docker install failed"
ok "Docker installed"

section "Docker service and group"
if [ -d /run/systemd/system ]; then
    sudo systemctl enable --now docker || die "Could not start Docker"
    sudo docker run --rm hello-world || warn "hello-world failed"
else
    warn "systemd is not running, so start the Docker service yourself"
fi
sudo usermod -aG docker "$(id -un)" || warn "Could not add you to the docker group"
warn "Log out and back in to use docker without sudo."

if confirm "Build the image from Docker/Dockerfile now?"; then
    sudo docker build -t system-taiyaar "$REPO_DIR/Docker" || die "Docker build failed"
    ok "Built system-taiyaar"
fi
echo "Start a container with: bash Docker/Docker_Run.sh"
