# Install zinit if not installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}Installing %F{220}Zinit...%f"
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || print -P "%F{160}Clone failed.%f"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Core plugins
zinit wait lucid for \
    Aloxaf/fzf-tab \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-history-substring-search \
