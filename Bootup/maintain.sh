#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
SEPARATOR="${BLUE}------------------------------------------------------------${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Running: 🍺 Homebrew Update${NC}"
echo -e "$SEPARATOR"
brew update
echo -e "${GREEN}Homebrew update completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Running: 🍺 Homebrew Upgrade${NC}"
echo -e "$SEPARATOR"
brew upgrade
echo -e "${GREEN}Homebrew upgrade completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Running:🐍 conda update${NC}"
echo -e "$SEPARATOR"
conda update -n base -c defaults conda -y
echo -e "${GREEN}Base Conda update completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Running:🐍 conda update ${NC}"
echo -e "$SEPARATOR"
conda update --all -y
echo -e "${GREEN}All Conda packages update completed${NC}"

# #!/bin/bash

# GREEN='\033[0;32m'
# BLUE='\033[0;34m'
# NC='\033[0m' # No Color
# SEPARATOR="${BLUE}------------------------------------------------------------${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Running: Homebrew Clean${NC}"
echo -e "$SEPARATOR"
# brew cleanup -s
brew cleanup
echo -e "${GREEN}Brew Cleanup completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Autoremoving Brew${NC}"
echo -e "$SEPARATOR"
brew autoremove
echo -e "${GREEN}Brew Autoremove completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Running: conda clean --all -y${NC}"
echo -e "$SEPARATOR"
conda clean --all -y
echo -e "${GREEN}Conda Cleanup completed${NC}"
