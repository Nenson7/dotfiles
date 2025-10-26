#!/bin/bash
DOTFILES=~/dotfiles
TARGET=~

cd "$DOTFILES" || exit 1

echo -e "\033[33m[!]\033[0m Scanning for existing hardcopies..."

find . \
  ! -path "./setup/*" \
  ! -path "./.git/*" \
  ! -name "README.md" \
  -type f | while read -r file; do

    src="$DOTFILES/${file#./}"
    dest="$TARGET/$file"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "\033[31m[x]\033[0m Removing $dest (regular file)"
        rm -rf "$dest"
    fi
done

echo -e "\033[32m[>]\033[0m Creating symlinks..."

find . \
  ! -path "./setup/*" \
  ! -path "./.git/*" \
  ! -name "README.md" \
  -type f | while read -r file; do

    src="$DOTFILES/${file#./}"
    dest="$TARGET/$file"

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo -e "\033[32m[+]\033[0m Linked $dest -> $src"
done

echo -e "\033[32m[✔]\033[0m All symlinks created successfully."
