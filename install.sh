#!/bin/bash

set -e

REPO_URL="https://github.com/Nenson7/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

echo "🚀 Setting up dotfiles"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "📥 Cloning dotfiles"
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "🔄 Updating dotfiles"
    git -C "$DOTFILES_DIR" pull
fi

declare -A FILES=(
    [".zshrc"]="$HOME/.zshrc"
    ["nvim/init.lua"]="$HOME/.config/nvim/init.lua"
    [".zshenv"]="$HOME/.zshenv"
    [".wezterm"]="$HOME/.wezterm"
)

for src in "${!FILES[@]}"; do
    target="${FILES[$src]}"
    src_path="$DOTFILES_DIR/$src"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi

    ln -s "$src_path" "$target"
    echo "✅ Linked $target → $src_path"
done

echo "🎯 All dotfiles linked!"

