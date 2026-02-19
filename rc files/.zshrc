########################################
# 🍺 Homebrew Shell Environment Setup  #
########################################
# eval "$(/opt/homebrew/bin/brew shellenv)"

########################################
# 🟢 Git Branch Parser Function        #
########################################
parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

########################################
# 📁 Path Shortener Function           #
# Shows: ~/First/…/Last directory      #
########################################
shorten_path() {
    local fullpath="${PWD/#$HOME/~}"
    local base=$(basename "$fullpath")
    local first=$(echo "$fullpath" | cut -d/ -f2)

    if [[ "$fullpath" == "~" || "$base" == "$first" ]]; then
        echo "$fullpath"
    else
        echo "~/$first/…/$base"
    fi
}

########################################
# 🎨 Prompt Colors and Substitution    #
########################################
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'

setopt PROMPT_SUBST

########################################
# 💬 Shell Prompt Definition           #
########################################
export PROMPT='${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}%% '

########################################
# 🧹 Clear screen on shell startup     #
########################################
clear

########################################
# 🚩 Banner Function                   #
########################################
show_banner() {
    ########################################
    # 🖥️  System Info Centered Output     #
    ########################################
    center_text() {
        local term_width=$(tput cols)
        local text="$1"
        local text_length=${#text}
        local padding=$(( (term_width - text_length) / 2 ))
        printf "%*s%s\n" "$padding" "" "$text"
    }

    ########################################
    # 🌐 Network info
    ########################################
    IP_ADDRESS=$(ipconfig getifaddr en0 2>/dev/null)
    ET_ADDRESS=$(ipconfig getifaddr en8 2>/dev/null)

    ########################################
    # 🔋 Battery info
    ########################################
    BATTERY_STATUS=$(pmset -g batt | grep -o "AC Power\|Battery Power")
    BATTERY_PERCENT=$(pmset -g batt | grep -o "[0-9]*%" | tr -d '%')

    [ -z "$BATTERY_PERCENT" ] && BATTERY_PERCENT="N/A"
    CHARGING_ICON="🔋"
    [[ "$BATTERY_STATUS" == "AC Power" ]] && CHARGING_ICON="🔌"

    ########################################
    # 📅 Date
    ########################################
    DATE=$(date "+%A, %d %B %Y %H:%M")

    ########################################
    # 🤖 ROS Environment (if set)
    ########################################
    # You can manually set these if needed:
    # export ROS_IP=192.168.1.10
    # export ROS_MASTER_URI=http://192.168.1.10:11311
    # export ROS_DOMAIN_ID=0

    ########################################
    # 🖥️ Display System Info
    ########################################
    [ -n "$DATE" ] && center_text "$DATE"

    [ -n "$IP_ADDRESS" ] && center_text "🛜 IP: $IP_ADDRESS"

    # ROS info directly below IP (if exists)
    [ -n "$ROS_IP" ] && center_text "🤖 ROS_IP: $ROS_IP"
    [ -n "$ROS_MASTER_URI" ] && center_text "🧭 ROS_MASTER_URI: $ROS_MASTER_URI"
    [ -n "$ROS_DOMAIN_ID" ] && center_text "🌐 ROS_DOMAIN_ID: $ROS_DOMAIN_ID"

    [ -n "$ET_ADDRESS" ] && center_text "🌐 Ethernet: $ET_ADDRESS"
    [ -n "$BATTERY_PERCENT" ] && center_text "$CHARGING_ICON Battery: $BATTERY_PERCENT%"
}

# Run banner on startup
show_banner

########################################
# 📂 Custom Aliases
########################################
# Source .zsh_aliases from the same directory as this .zshrc
[ -f "${0:A:h}/.zsh_aliases" ] && source "${0:A:h}/.zsh_aliases"

########################################
# 📦 Library & User Paths
########################################
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH
export PKG_CONFIG_PATH=/opt/homebrew/lib/pkgconfig

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

########################################
# 🐍 Conda Setup (MUST BE LAST)
########################################
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/shrikar/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/shrikar/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/shrikar/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/shrikar/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

########################################
# 📦 Pixi
########################################
export PATH="/Users/shrikar/.pixi/bin:$PATH"
