#!/bin/bash
DOTFILES=~/dotfiles
TARGET=~

cd "$DOTFILES" || exit

find . ! -path "./setup/*" ! -path "./.git/*" | \
	while read -r file; do

	src="$DOTFILES/${file#./}"
	dest="$TARGET/$file"

	mkdir -p "$(dirname "$dest")"

	ln -sf "$src" "$dest"
	echo "Linked $dest -> $src"
done

