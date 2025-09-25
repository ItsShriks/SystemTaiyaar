#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
SEPARATOR="${BLUE}------------------------------------------------------------${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Running: Homebrew Update${NC}"
echo -e "$SEPARATOR"
brew update
echo -e "${GREEN}Homebrew update completed${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Running: Homebrew Upgrade${NC}"
echo -e "$SEPARATOR"
brew upgrade
echo -e "${GREEN}Homebrew upgrade completed${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Running: conda update -n base -c defaults conda${NC}"
echo -e "$SEPARATOR"
conda update -n base -c defaults conda -y
echo -e "${GREEN}Base Conda update completed${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Running: conda update --all${NC}"
echo -e "$SEPARATOR"
conda update --all -y
echo -e "${GREEN}All Conda packages update completed${NC}"
