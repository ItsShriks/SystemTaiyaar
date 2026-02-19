# ================================
# 🦾 ROS Environment Aliases
# ================================

# Activate ROS environment
alias rosex="pixi shell -e noetic --manifest-path ~/robostack && export ROS_MASTER_URI=http://localhost:11311 && export ROS_IP=$(ipconfig getifaddr en0)"
# Activate ROS2 environment
alias rosex2="pixi shell -e humble --manifest-path ~/robostack && export ROS_DOMAIN_ID=69"

# ================================
# 📚 Academic Project Directories
# ================================

# Semester V

alias sem4="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ IV"
alias sem5="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ V"

alias sem4SUBJECT="conda deactivate && source ~/anaconda3/bin/activate <SUBJECT> && cd ~/path/to/SUBJECT/ && clear"

# ================================
# 🔧 Utility Aliases
# ================================

alias clc="clear && show_banner"
alias of="open -a Finder ."
alias python="python3"
alias git-back="~/git-commit-date-changer"
# ================================
# 🧼 Environment Cleanup
# ================================

# Unset potential library path conflicts
unset DYLD_LIBRARY_PATH
unset LD_LIBRARY_PATH
