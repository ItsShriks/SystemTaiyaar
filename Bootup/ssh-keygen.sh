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

KEY_TITLE="$(hostname)"

manual_steps() {
    warn "Add the public key above by hand: $1"
}

verify_host() {
    local out
    out=$(ssh -T -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new "git@$1" 2>&1)
    case "$out" in
        *successfully*|*Welcome*) ok "SSH to $1 works: $out" ;;
        *) warn "SSH to $1 not working yet: $out" ;;
    esac
}

link_github() {
    section "Link to GitHub"
    if ! command -v gh >/dev/null; then
        manual_steps "https://github.com/settings/keys"
        return
    fi
    gh auth status --hostname github.com >/dev/null 2>&1 ||
        gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key
    if ! gh ssh-key add "$PUB_KEY_PATH" --title "$KEY_TITLE"; then
        # An older login may not have the scope needed to add keys
        gh auth refresh --hostname github.com --scopes admin:public_key &&
            gh ssh-key add "$PUB_KEY_PATH" --title "$KEY_TITLE" ||
            manual_steps "https://github.com/settings/keys"
    fi
    verify_host github.com
}

link_gitlab() {
    local host
    section "Link to GitLab"
    read -r -p "GitLab host [gitlab.com]: " host
    host="${host:-gitlab.com}"
    if ! command -v glab >/dev/null; then
        manual_steps "https://$host/-/user_settings/ssh_keys"
        return
    fi
    glab auth status --hostname "$host" >/dev/null 2>&1 || glab auth login --hostname "$host"
    # Fails when the key is already on the account, so verify_host has the final word
    GITLAB_HOST="$host" glab ssh-key add "$PUB_KEY_PATH" --title "$KEY_TITLE" ||
        manual_steps "https://$host/-/user_settings/ssh_keys"
    verify_host "$host"
}

if [ -t 0 ]; then
    echo
    if confirm "Link this key to GitHub?" y; then link_github; fi
    if confirm "Link this key to GitLab?" y; then link_gitlab; fi
else
    manual_steps "https://github.com/settings/keys or https://gitlab.com/-/user_settings/ssh_keys"
fi
