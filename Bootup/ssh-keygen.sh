#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
SEPARATOR="${BLUE}------------------------------------------------------------${NC}"

echo -e "\n$SEPARATOR"
echo -e "🔑 SSH Key Generator & Setup System"
echo -e "$SEPARATOR"

# Check if ssh-keygen is available
if ! command -v ssh-keygen &> /dev/null; then
    echo -e "${RED}Error: ssh-keygen is not installed or not in PATH.${NC}"
    exit 1
fi

OS="$(uname -s)"
KEY_DIR="$HOME/.ssh"
KEY_PATH="$KEY_DIR/id_ed25519"
PUB_KEY_PATH="${KEY_PATH}.pub"

# Ensure .ssh directory exists
mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

GENERATE_KEY=true

if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}An SSH key already exists at: $KEY_PATH${NC}"
    read -p "Do you want to overwrite it? (y/N): " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        GENERATE_KEY=false
        echo -e "${GREEN}Using existing SSH key.${NC}"
    fi
fi

if [ "$GENERATE_KEY" = true ]; then
    # Determine default email comment
    GIT_EMAIL=$(git config --global user.email 2>/dev/null)
    DEFAULT_EMAIL="${GIT_EMAIL:-$(whoami)@$(hostname)}"
    
    echo -e "Enter email/comment for the SSH key."
    read -p "[$DEFAULT_EMAIL]: " EMAIL
    EMAIL="${EMAIL:-$DEFAULT_EMAIL}"
    
    echo -e "\nGenerating new Ed25519 SSH key..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to generate SSH key.${NC}"
        exit 1
    fi
    echo -e "${GREEN}SSH key generated successfully at $KEY_PATH${NC}"
fi

# Configure SSH config file
CONFIG_FILE="$KEY_DIR/config"
touch "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# Setup OS-specific configuration
if ! grep -q "IdentityFile.*id_ed25519" "$CONFIG_FILE"; then
    echo -e "\nConfiguring ~/.ssh/config for automatic key loading..."
    if [ "$OS" = "Darwin" ]; then
        cat >> "$CONFIG_FILE" <<EOL

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOL
    else
        cat >> "$CONFIG_FILE" <<EOL

Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOL
    fi
    echo -e "${GREEN}Updated $CONFIG_FILE${NC}"
else
    echo -e "${GREEN}SSH config already contains configuration for id_ed25519.${NC}"
fi

# Start SSH agent and add key
echo -e "\nStarting SSH agent and adding key..."
eval "$(ssh-agent -s)"

if [ "$OS" = "Darwin" ]; then
    # On macOS Monterey and later, --apple-use-keychain is standard
    # Check if --apple-use-keychain is supported, otherwise fallback to -K (deprecated but legacy fallback) or standard add
    if ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null; then
        echo -e "${GREEN}Added key to macOS Keychain.${NC}"
    else
        if ssh-add -K "$KEY_PATH" 2>/dev/null; then
            echo -e "${GREEN}Added key to macOS Keychain (using legacy -K).${NC}"
        else
            ssh-add "$KEY_PATH"
            echo -e "${GREEN}Added key to SSH Agent.${NC}"
        fi
    fi
else
    ssh-add "$KEY_PATH"
    echo -e "${GREEN}Added key to SSH Agent.${NC}"
fi

echo -e "$SEPARATOR"
echo -e "${GREEN}🎉 SSH key setup successfully completed!${NC}"
echo -e "$SEPARATOR"
echo -e "Your public key is shown below:\n"
cat "$PUB_KEY_PATH"
echo -e "\n$SEPARATOR"
echo -e "📋 To add this key to your GitHub account:"
echo -e "1. Copy the public key above."
echo -e "2. Go to: ${BLUE}https://github.com/settings/keys${NC}"
echo -e "3. Click 'New SSH key', paste it, and save."
echo -e "$SEPARATOR\n"
