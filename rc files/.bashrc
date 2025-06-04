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
source /opt/ros/noetic/setup.bash

# Function to center text
center_text() {
    local term_width=$(tput cols)  # Get terminal width
    local text="$1"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    printf "%*s%s\n" "$padding" "" "$text"
}

# Get IP addresses
IP_ADDRESS=$(hostname -I | awk '{print $1}')  # Get first IP (WLAN or Ethernet)
ET_ADDRESS=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')  # Ethernet

# Get Battery Percentage and Charging Status (For Laptops)
if command -v upower &>/dev/null; then
    BATTERY_PERCENT=$(upower -i $(upower -e | grep 'BAT') | grep -oP '(?<=percentage:\s*)[0-9]+')
    BATTERY_STATUS=$(upower -i $(upower -e | grep 'BAT') | grep -oP '(?<=state:\s*)\w+')

    # Set default message if battery info is unavailable
    if [ -z "$BATTERY_PERCENT" ]; then
        BATTERY_PERCENT="N/A"
    fi

    # Determine charging icon
    if [[ "$BATTERY_STATUS" == "charging" ]]; then
        CHARGING_ICON="🔋"
    else
        CHARGING_ICON="🪫"
    fi
else
    BATTERY_PERCENT="N/A"
    CHARGING_ICON="⚡"
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
