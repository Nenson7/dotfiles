#!/bin/bash
DOTFILES=~/dotfiles
TARGET=~

cd "$DOTFILES" || exit

find . -type f ! -name "install.sh" ! -name "setup.sh" ! -name "README.md" ! -path "./.git/*" | \
	while read -r file; do

	src="$DOTFILES/${file#./}"
	dest="$TARGET/$file"

	mkdir -p "$(dirname "$dest")"

	ln -sf "$src" "$dest"
	echo "Linked $dest -> $src"
done

