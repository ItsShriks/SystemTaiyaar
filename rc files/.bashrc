# Show git branch name
force_color_prompt=yes
color_prompt=yes
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
 PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
 PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt
# Function to center text
center_text() {
    local term_width=$(tput cols)  # Get terminal width
    local text="$1"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    printf "%*s%s\n" "$padding" "" "$text"
}

# Get IP addresses
# Gets the IP of the currently UP interface (wlp3s0 in your case)
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Using enp4s0f1 (your Ethernet interface)
ET_ADDRESS=$(ip -4 addr show enp4s0f1 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)

# Get Battery Percentage and Charging Status (For Laptops)
if command -v upower &>/dev/null; then
    # Using standard grep and awk to extract percentage
    BATTERY_PERCENT=$(upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}' | tr -d '%')
    # Using standard grep and awk to extract state
    BATTERY_STATUS=$(upower -i $(upower -e | grep 'BAT') | grep state | awk '{print $2}')

    # Set default message if battery info is unavailable
    if [ -z "$BATTERY_PERCENT" ]; then
        BATTERY_PERCENT="N/A"
    fi
else
    BATTERY_PERCENT="N/A"
fi

# Get ROS environment variables
ROS_IP=$(echo "$ROS_IP")
ROS_MASTER_URI=$(echo "$ROS_MASTER_URI")

# --- Display Information ---

# Get current Date and Time
CURRENT_DATE_TIME=$(date +"%A, %b %d, %Y | %H:%M:%S")

# Display Date and Time first
[ -n "$CURRENT_DATE_TIME" ] && center_text "📅 $CURRENT_DATE_TIME"

# Display IP addresses
[ -n "$IP_ADDRESS" ] && center_text "📶 Wi-Fi (wlp3s0): $IP_ADDRESS"
[ -n "$ET_ADDRESS" ] && center_text "🌐 Ethernet (enp4s0f1): $ET_ADDRESS"

# NEW LOGIC: Only display battery if it is discharging or if the status is N/A
if [ "$BATTERY_STATUS" == "discharging" ] || [ "$BATTERY_PERCENT" == "N/A" ]; then
    center_text "🔋 Battery: $BATTERY_PERCENT%"
fi

# Display ROS variables
[ -n "$ROS_IP" ] && center_text "ROS_IP: $ROS_IP"
[ -n "$ROS_MASTER_URI" ] && center_text "ROS_MASTER_URI: $ROS_MASTER_URI"
