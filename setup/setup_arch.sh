#!/usr/bin/env bash
set -e

echo "==> Updating system packages"
sudo pacman -Syu --noconfirm

echo "==> Installing essential packages"
sudo pacman -S --noconfirm \
    git base-devel vim curl wget \
    python python-pip ripgrep fd zsh btop fzf \
    vlc tlp kitty neovim

cd ~/dotfiles && ./install.sh
cd ~

echo "==> Setting up zsh as default shell"
chsh -s "$(which zsh)"
exec zsh

echo "==> Installing Brave browser"
if ! command -v yay >/dev/null 2>&1; then
    echo "==> Installing yay (AUR helper)"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

echo "Installing chromium"
sudo pacman -S chromium

echo "==> Installing Node.js LTS via nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source nvm to current shell so you can immediately use it
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

echo "==> Setup complete!"
