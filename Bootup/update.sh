#!/bin/bash

echo -e "\n>>> Running: Homebrew Update"
brew update
echo "Homebrew update completed"

echo -e "\n>>> Running: Homebrew Upgrade"
brew upgrade
echo "Homebrew upgrade completed"

echo -e "\n>>> Running: conda update -n base -c defaults conda"
conda update -n base -c defaults conda -y
echo "Base Conda update completed"

echo -e "\n>>> Running: conda update --all"
conda update --all -y
echo "All Conda packages update completed"
