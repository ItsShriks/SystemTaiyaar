cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III
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

alias rosex="conda deactivate && source ~/miniconda3/bin/activate ros2"
alias cdeactivate="conda deactivate && cd"
alias crnd="conda deactivate && cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ III/R\&D/ && conda activate rnd && clear"
alias git-hack='~/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ II/git-commit-date-changer-master/git-commit-date-changer'
alias sdp="cd /Users/shrikar/Library/Mobile\ Documents/com~apple~CloudDocs/Sem\ II/ && conda deactivate && clear"
