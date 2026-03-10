# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
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
zinit ice depth"1"
zinit light romkatv/powerlevel10k

### 3. Exports & PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# pnpm
export PNPM_HOME="/home/nenson/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Local Bin
. "$HOME/.local/bin/env" 2>/dev/null || true

### 4. Essential Tool Inits (must run before plugins)
# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# fzf binary setup — sets FZF_DEFAULT_OPTS, keybinds, etc.
# Adjust path if fzf is elsewhere (e.g. /usr/bin/fzf or ~/.fzf)
if command -v fzf &>/dev/null; then
  # Source fzf shell integration (keybindings + completion)
  if [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
    source /usr/share/fzf/shell/key-bindings.zsh        # Ctrl+R, Ctrl+T, Alt+C
  elif [[ -f ~/.fzf/shell/key-bindings.zsh ]]; then
    source ~/.fzf/shell/key-bindings.zsh
  fi
fi

# fzf global options — used by fzf-tab and native fzf
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#89b4fa
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#89dceb
  --color=info:#cba6f7,prompt:#89b4fa,pointer:#f5c2e7
  --color=marker:#a6e3a1,spinner:#f5c2e7,header:#89b4fa
"
# fd as the default find backend (install: apt install fd-find / brew install fd)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2>/dev/null || find . -type d'

### 5. Eza Aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons --group-directories-first'

### 6. OMZ Snippets (only ones that actually work standalone)
zinit ice wait"0" lucid; zinit snippet OMZP::sudo           # double-Esc to prepend sudo
zinit ice wait"0" lucid; zinit snippet OMZP::command-not-found  # suggest package on unknown cmd
# Removed: OMZP::fzf — replaced by fzf-tab below (better)

### 7. Completions + Highlighting + Suggestions (Turbo trio)

# Step 1 — extra completions (blockf prevents the old-style compdef override)
zinit ice wait"0" lucid blockf
zinit light zsh-users/zsh-completions

# Step 2 — fzf-tab: replaces the default ** tab menu with a live fzf picker
#   Works for: commands, flags (after -- ), paths, git branches, kill <pid>, etc.
zinit ice wait"0" lucid
zinit light Aloxaf/fzf-tab

# Step 3 — syntax highlighting (atinit runs compinit once, right before this loads)
zinit ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Step 4 — fish-like inline suggestions
zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

### 8. fzf-tab configuration (tune after it loads)
# Show file previews in path completions
zstyle ':fzf-tab:complete:*' fzf-preview \
  'if [[ -d $realpath ]]; then eza --tree --icons --color=always $realpath | head -40; elif [[ -f $realpath ]]; then bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || cat $realpath; fi'

# Show man page preview when completing commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
  'man $word 2>/dev/null | head -40 || echo "$word: no man page"'

# Git branch/log previews
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  'git diff $word | delta 2>/dev/null || git diff $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
  'git log --oneline --graph --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'git log --oneline --graph --color=always $word'

# Kill: show process info
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-header -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# cd preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
  'eza --tree --icons --color=always $realpath | head -40'

# Continuous completion (Tab again without closing fzf)
zstyle ':fzf-tab:*' continuous-trigger 'tab'

# Use fzf-tab for everything
zstyle ':fzf-tab:*' switch-group '<' '>'    # switch between groups with < >
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=rounded

### 9. Zsh Completion Behaviour
zstyle ':completion:*' menu no              # disable old menu — fzf-tab takes over
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'       # group labels for fzf-tab
zstyle ':completion:*' group-name ''                    # enable grouping

### 10. History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_VERIFY               # show expanded history before running

### 11. Misc options
setopt AUTO_CD                   # type a dir name to cd into it
setopt INTERACTIVE_COMMENTS      # allow # comments in shell

### 12. Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### 13. Tool completions
# bun
[ -s "/home/nenson/.bun/_bun" ] && source "/home/nenson/.bun/_bun"
