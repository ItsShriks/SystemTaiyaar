#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
SEPARATOR="${BLUE}------------------------------------------------------------${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Running: Homebrew Clean${NC}"
echo -e "$SEPARATOR"
# brew cleanup -s
brew cleanup
echo -e "${GREEN}Brew Cleanup completed${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Autoremoving Brew${NC}"
echo -e "$SEPARATOR"
brew autoremove
echo -e "${GREEN}Brew Autoremove completed${NC}"

echo -e "\n$SEPARATOR"
echo -e ">>> Running: conda clean --all -y${NC}"
echo -e "$SEPARATOR"
conda clean --all -y
echo -e "${GREEN}Conda Cleanup completed${NC}"
