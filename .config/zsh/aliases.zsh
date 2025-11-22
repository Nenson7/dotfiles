alias n='nvim'
alias ls='ls --color=always -lh'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

export EDITOR=nvim
export VISUAL=nvim
export PATH="$PATH:/home/_nenson/go/bin"

build() {
    if [[ -f "./build.sh" ]]; then
        echo "INFO: running build.sh"
        bash ./build.sh
    elif [[ -f "./Makefile" ]]; then
        echo "Running make"
        make
    else
        echo "no build config found"
    fi
}

# fast fd+fzf directory jump (Ctrl+G)
fzf_fd_cd() {
  local dir
  dir=$(fd --type d --follow --exclude .git . 2>/dev/null | fzf --height 40% --reverse ) || return
  cd -- "$dir" && zle reset-prompt 2>/dev/null
}
zle -N fzf_fd_cd
bindkey '^G' fzf_fd_cd
