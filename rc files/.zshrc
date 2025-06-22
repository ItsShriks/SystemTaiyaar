
eval "$(/opt/homebrew/bin/brew shellenv)"
parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
NEWLINE=$'\n'
setopt PROMPT_SUBST
export PROMPT='${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}%% '
clear
center_text() {
    local term_width=$(tput cols)  # Get terminal width
    local text="$1"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    printf "%*s%s\n" "$padding" "" "$text"
}
IP_ADDRESS=$(ipconfig getifaddr en0)
ET_ADDRESS=$(ipconfig getifaddr en8)
BATTERY_STATUS=$(pmset -g batt | grep -o "AC Power\|Battery Power")
BATTERY_PERCENT=$(pmset -g batt | grep -o "[0-9]*%" | tr -d '%')

if [ -z "$BATTERY_PERCENT" ]; then
    BATTERY_PERCENT="N/A"
fi

if [[ "$BATTERY_STATUS" == "AC Power" ]]; then
    CHARGING_ICON="🔌"
else
    CHARGING_ICON="🔋"
fi
DATE=$(date "+%A, %d %B %Y %H:%M")

[ -n ]&& center_text "$DATE"
[ -n "$IP_ADDRESS" ] && center_text "🛜 IP: $IP_ADDRESS"
[ -n "$ET_ADDRESS" ] && center_text "🌐 Ethernet: $ET_ADDRESS"
[ -n "$BATTERY_PERCENT" ] && center_text "$CHARGING_ICON Battery: $BATTERY_PERCENT%"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/shrikar/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/shrikar/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/shrikar/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/shrikar/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
source ~/.zsh_aliases
