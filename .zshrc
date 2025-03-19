
eval "$(/opt/homebrew/bin/brew shellenv)"
parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
# About the prefixed `$`: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html#:~:text=Words%20in%20the%20form%20%22%24',by%20the%20ANSI%2DC%20standard.
NEWLINE=$'\n'
# Set zsh option for prompt substitution
setopt PROMPT_SUBST
export PROMPT='${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}%% '
clear


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias rosex="conda deactivate && source ~/miniconda3/bin/activate ros"
alias rosex2="conda deactivate && source ~/miniconda3/bin/activate ros2"
alias cdeactivate="conda deactivate && cd"
alias sem3rnd="conda deactivate && source ~/opt/anaconda3/bin/activate rnd && cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III/R\&D/ && clear"
alias sem3rl= "conda deactivate && source ~/opt/anaconda3/bin/activate rl && cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III/Robot\ Learning/ && clear"
alias sem3ml= "conda deactivate && source ~/opt/anaconda3/bin/activate ml && cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III/Machine\ Learning/ && clear"
alias sem3rm= "conda deactivate && source ~/opt/anaconda3/bin/activate rm && cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III/Robot\ Manipulation/ && clear"
alias sem3mrc="conda deactivate && source ~/opt/anaconda3/bin/activate mrc && cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III/MRC/ && clear"

alias sem3="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III"
# Function to center text
center_text() {
    local term_width=$(tput cols)  # Get terminal width
    local text="$1"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    printf "%*s%s\n" "$padding" "" "$text"
}

# Get IP addresses
IP_ADDRESS=$(ipconfig getifaddr en0)
ET_ADDRESS=$(ipconfig getifaddr en8)

# Get Battery Percentage and Charging Status
BATTERY_STATUS=$(pmset -g batt | grep -o "AC Power\|Battery Power")
BATTERY_PERCENT=$(pmset -g batt | grep -o "[0-9]*%" | tr -d '%')

# Set a default message if battery info is unavailable
if [ -z "$BATTERY_PERCENT" ]; then
    BATTERY_PERCENT="N/A"
fi

# Determine charging icon
if [[ "$BATTERY_STATUS" == "AC Power" ]]; then
    CHARGING_ICON="🔋"
else
    CHARGING_ICON="🪫"
fi

# Get ROS environment variables
ROS_IP=$(echo "$ROS_IP")
ROS_MASTER_URI=$(echo "$ROS_MASTER_URI")

# Display information only if values are not empty
[ -n "$IP_ADDRESS" ] && center_text "🛜 IP: $IP_ADDRESS"
[ -n "$ET_ADDRESS" ] && center_text "🌐 Ethernet: $ET_ADDRESS"
[ -n "$BATTERY_PERCENT" ] && center_text "$CHARGING_ICON Battery: $BATTERY_PERCENT%"
[ -n "$ROS_IP" ] && center_text "ROS_IP: $ROS_IP"
[ -n "$ROS_MASTER_URI" ] && center_text "ROS_MASTER_URI: $ROS_MASTER_URI"
export PATH="/Applications/Zed.app/Contents/MacOS:$PATH"
