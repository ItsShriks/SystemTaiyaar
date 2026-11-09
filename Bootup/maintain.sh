#!/bin/bash

# --- PASSWORD CACHING ---
# Ask for the administrator password upfront so you don't have to type it later
echo "Please enter your sudo password to authorize the maintenance script:"
sudo -v

# Keep-alive: Updates the sudo timestamp in the background every 60 seconds
# until the script finishes, ensuring it never timeouts.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
# ------------------------

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
# Added '--noconfirm' to automatically skip the [y/n] prompt
brew upgrade -g
echo -e "${GREEN}Homebrew upgrade completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> 🐍 conda base update${NC}"
echo -e "$SEPARATOR"
conda update -n base -c defaults conda -y
echo -e "${GREEN}Base Conda update completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> 🐍 conda update ${NC}"
echo -e "$SEPARATOR"
conda update --all -y
echo -e "${GREEN}All Conda packages update completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> 🍺 Homebrew Clean${NC}"
echo -e "$SEPARATOR"
brew cleanup
echo -e "${GREEN}Brew Cleanup completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> 🍺 Autoremoving Brew${NC}"
echo -e "$SEPARATOR"
brew autoremove
echo -e "${GREEN}Brew Autoremove completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> 🐍 conda Clean ${NC}"
echo -e "$SEPARATOR"
conda clean --all -y
echo -e "${GREEN}Conda Cleanup completed${NC}"

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> Moving Downloads to ☁️ Downloads${NC}"
echo -e "$SEPARATOR"
DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Downloads"

if compgen -G "$HOME/Downloads/*" > /dev/null; then
    mv "$HOME"/Downloads/* "$DEST"
    echo -e "${GREEN}Downloads moved to ☁️ successfully${NC}"
else
    echo -e "${BLUE}Downloads folder is empty — skipping${NC}"
fi

# Runs last because it waits for your input, so nothing above is held up or skipped by Ctrl+C
MAC_CLEANER_VERSION="1.3.5" # Pinned because it deletes files; bump after checking a new release

echo -e "\n$SEPARATOR"
echo -e "${BLUE}>>> 🧹 mac-cleaner-cli${NC}"
echo -e "$SEPARATOR"
if ! command -v npx > /dev/null; then
    echo -e "${BLUE}npx not found — skipping${NC}"
elif [ ! -t 0 ]; then
    echo -e "${BLUE}mac-cleaner-cli needs a terminal to ask what to delete — skipping${NC}"
else
    npx --yes "mac-cleaner-cli@$MAC_CLEANER_VERSION"
    echo -e "${GREEN}mac-cleaner-cli completed${NC}"
fi
