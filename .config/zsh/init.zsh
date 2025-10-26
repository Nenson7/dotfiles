# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Shell behavior
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

autoload -Uz compinit
compinit -C

# PATH
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
