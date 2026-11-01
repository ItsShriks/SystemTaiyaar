#!/bin/bash
set -uo pipefail
source "$(dirname "$0")/lib.sh"

ROS_DISTRO_NAME="humble"
REQUIRED_CODENAME="jammy" # Humble's apt packages are built for Ubuntu 22.04

CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}")"
[ "$CODENAME" = "$REQUIRED_CODENAME" ] ||
    die "ROS2 Humble needs Ubuntu 22.04 ($REQUIRED_CODENAME), this is '$CODENAME'."

if dpkg -s "ros-$ROS_DISTRO_NAME-desktop" >/dev/null 2>&1; then
    ok "ROS2 Humble already installed"
    exit 0
fi

section "ROS2 apt repository"
sudo apt-get update || die "apt update failed"
sudo apt-get install -y software-properties-common curl || die "apt install failed"
sudo add-apt-repository -y universe || die "Could not enable universe"

if ! dpkg -s ros2-apt-source >/dev/null 2>&1; then
    version="$(curl -fsSL https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F '"tag_name"' | awk -F'"' '{print $4}')"
    [ -n "$version" ] || die "Could not find the latest ros-apt-source release"
    deb="$(mktemp -d)/ros2-apt-source.deb"
    curl -fsSL -o "$deb" "https://github.com/ros-infrastructure/ros-apt-source/releases/download/$version/ros2-apt-source_$version.${CODENAME}_all.deb" || die "Could not download ros2-apt-source"
    sudo dpkg -i "$deb" || die "Could not install ros2-apt-source"
fi

section "ROS2 Humble (this takes a while)"
# ROS docs ask for an upgrade first: fresh 22.04 images can break on old systemd and udev
sudo apt-get update && sudo apt-get upgrade -y || die "apt upgrade failed"
sudo apt-get install -y "ros-$ROS_DISTRO_NAME-desktop" ros-dev-tools || die "ROS install failed"
ok "ROS2 Humble installed. Open a new terminal, ~/.bashrc sources it."
