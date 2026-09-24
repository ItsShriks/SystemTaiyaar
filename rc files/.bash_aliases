# ================================
# 🦾 ROS Environment Aliases
# ================================

# Source ROS2 environment
alias source_ros2="source /opt/ros/humble/setup.bash && echo 'ROS2 Humble sourced'"
# Set ROS Domain ID (Usage: set_domain 69)
set_domain() {
    export ROS_DOMAIN_ID=$1
    echo "ROS_DOMAIN_ID set to $ROS_DOMAIN_ID"
}
# Unset ROS Domain ID
alias unset_domain="unset ROS_DOMAIN_ID && echo 'ROS_DOMAIN_ID unset'"
# ROS2 Localhost only
alias local_ros="export ROS_LOCALHOST_ONLY=1 && echo 'ROS_LOCALHOST_ONLY=1'"
alias nolocal_ros="export ROS_LOCALHOST_ONLY=0 && echo 'ROS_LOCALHOST_ONLY=0'"

# ================================
# 📚 Academic Project Directories
# ================================

# alias sem4SUBJECT="conda deactivate && source ~/anaconda3/bin/activate <SUBJECT> && cd ~/path/to/SUBJECT/ && clear"


# ================================
# ⚡ Navigation & Directory Shortcuts
# ================================

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lah --color=auto"
alias of="xdg-open ."


# ================================
# 🔧 Utility & System Aliases
# ================================

# Config & Environment
alias reload="source ~/.bashrc && echo 'Bash config reloaded!'"
alias clc="clear && show_banner"
alias python="python3"

# Ubuntu System & Network
alias myip="hostname -I | awk '{print \$1}'"
alias pubip="curl -s https://icanhazip.com"
alias flushdns="resolvectl flush-caches"
alias afk="systemctl suspend"

# Local Server & Clipboard
alias serve="python3 -m http.server 8000"
alias clip="xclip -selection clipboard <"              # Usage: clip file.txt (requires xclip)
alias paste="xclip -selection clipboard -o"            # Outputs clipboard text to stdout (requires xclip)


# ================================
# 🐙 Git Superpowers
# ================================

alias gp="git push"
alias gs="git status"
alias gundo="git reset --soft HEAD~1"
alias glog="git log --graph --oneline --decorate --all"
alias gpull="git pull --recurse-submodules"


# ================================
# 🔧 Functions
# ================================

# Smart Git Commit (No quotes required!)
# Usage: gcm updated sub-node parameters
gcm() {
  git add . && git commit -m "$*"
}

# Web Search
# Usage: google ros2 humble launch files
google() {
  xdg-open "https://www.google.com/search?q=$*"
}

# Create a directory and enter it immediately
# Usage: mkcd my_new_folder
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Universal Extractor
# Usage: extract archive.tar.gz
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xvf "$1"     ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Fast Process Termination
# Usage: fnamekill python
fnamekill() {
  ps aux | grep -i "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
}

# Change the date/time of the LAST commit
# Usage: git-back "2026-08-01 14:00:00"
git-back() {
  if [ -z "$1" ]; then
    echo "Usage: git-back \"YYYY-MM-DD HH:MM:SS\""
    return 1
  fi
  GIT_COMMITTER_DATE="$1" git commit --amend --no-edit --date "$1"
}


# ================================
# 🧼 Environment Cleanup
# ================================

# Unset potential library path conflicts
unset DYLD_LIBRARY_PATH
unset LD_LIBRARY_PATH
