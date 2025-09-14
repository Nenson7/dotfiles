# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by G (custom Zsh config)

### Zinit Install (don't touch this)
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}Zinit%F{220}…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### Speed & Annexes
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

### Core Plugins (Turbo-loaded)
zinit wait lucid for \
    Aloxaf/fzf-tab \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-history-substring-search \
    hlissner/zsh-autopair \
    MichaelAquilina/zsh-you-should-use \
    agkozak/zsh-z  # fast directory jumping

### Prompt (clean + fast)
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### fzf Integration (if installed)
if command -v fzf >/dev/null 2>&1; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

### Options & QOL
setopt HIST_IGNORE_ALL_DUPS     # no dupes
setopt HIST_IGNORE_SPACE        # don’t save cmds starting w/ space
setopt HIST_VERIFY              # don’t execute right away on history expansion
setopt SHARE_HISTORY            # share history between sessions
setopt AUTO_CD                  # just type dir name to cd
setopt INTERACTIVE_COMMENTS     # allow comments in interactive shell
bindkey -v                      # vim mode

### History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

### Keybindings
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab for fzf-tab

### Aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

### End
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
