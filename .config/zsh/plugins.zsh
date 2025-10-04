# Install zinit if not installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}Installing %F{220}Zinit...%f"
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || print -P "%F{160}Clone failed.%f"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Core plugins
zinit wait lucid for \
    Aloxaf/fzf-tab \
    hlissner/zsh-autopair \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-history-substring-search \
    wfxr/forgit \
    rupa/z
