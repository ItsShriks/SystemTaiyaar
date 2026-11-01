#!/bin/bash

source "$(dirname "$0")/lib.sh"

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
    
    # Keep the old key, since anything still using it would otherwise lose access
    if [ -f "$KEY_PATH" ]; then
        OLD_SUFFIX="old-$(date +%Y%m%d-%H%M%S)"
        mv "$KEY_PATH" "$KEY_PATH.$OLD_SUFFIX"
        [ -f "$PUB_KEY_PATH" ] && mv "$PUB_KEY_PATH" "$KEY_PATH.$OLD_SUFFIX.pub"
        warn "Moved the old key to $KEY_PATH.$OLD_SUFFIX"
    fi

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
echo -e "${GREEN}🎉 SSH key is ready!${NC}"
echo -e "$SEPARATOR"
echo -e "Your public key is shown below:\n"
cat "$PUB_KEY_PATH"

echo

# pbcopy on macOS, wl-copy on Wayland, xclip on X11
if command -v pbcopy >/dev/null; then
    COPY_CMD="pbcopy"
elif [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null; then
    COPY_CMD="wl-copy"
elif [ -n "${DISPLAY:-}" ] && command -v xclip >/dev/null; then
    COPY_CMD="xclip -selection clipboard"
else
    COPY_CMD=""
fi

if [ -n "$COPY_CMD" ] && $COPY_CMD < "$PUB_KEY_PATH" >/dev/null 2>&1; then
    ok "📋 Public key copied to your clipboard."
else
    warn "Could not copy to the clipboard, so copy the key above by hand."
fi

echo -e "\nAdd it to your accounts:"
echo -e "  GitHub: ${BLUE}https://github.com/settings/keys${NC}"
echo -e "  GitLab: ${BLUE}https://gitlab.com/-/user_settings/ssh_keys${NC} (or the same page on your own GitLab)"
echo -e "\nThen test it with: ssh -T git@github.com"
