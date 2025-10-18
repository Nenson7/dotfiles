alias n='nvim'
alias ls='ls --color=auto -lh'
alias la='ls -la'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

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
