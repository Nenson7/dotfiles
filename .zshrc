# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### 1. Zinit Installer Chunk
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### 2. Theme: Powerlevel10k
# Load this first for immediate prompt rendering
zinit ice depth"1"
zinit light romkatv/powerlevel10k

### 3. Essential Tools (zoxide, eza, fzf)
# Zoxide (Smart cd)
eval "$(zoxide init zsh)"

# Eza (Modern ls) - Set common aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Local Bin
. "$HOME/.local/bin/env" 2>/dev/null || true
# fzf integration (History and file search)
zinit ice wait"0" lucid
zinit snippet OMZP::fzf

### 4. Apt & System Helpers
zinit ice wait"0" lucid
zinit snippet OMZP::sudo
zinit ice wait"0" lucid
zinit snippet OMZP::command-not-found

### 5. Highlighting & Autocompletes (The "Turbo" Trio)
# Load completions first
zinit ice wait"0" lucid blockf
zinit light zsh-users/zsh-completions

# Syntax highlighting (Loaded next to avoid conflicts)
zinit ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Suggestions (Fish-like ghost text)
zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

### 6. History Settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS  # Don't record same command twice
setopt SHARE_HISTORY         # Share history between terminal tabs

# To customize Powerlevel10k, run `p10k configure`
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
