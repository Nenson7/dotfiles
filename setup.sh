#!/usr/bin/env bash

set -e

echo "INFO: Updating System Packages"
sudo apt update && sudo apt upgrade -y

echo "INFO: Installing essentials"
sudo apt install -y git build-essential vim curl wget\
    gnome-tweaks tlp tlp-rdw python3 python3-pip ripgrep fd-find zsh btop fzf \
    ubuntu-restricted-extras vlc

echo "INFO: Copying Config"
if [ -d "$HOME/dotfiles/.git" ]; then
    cd "$HOME/dotfiles"
    git fetch origin
    git reset --hard origin/main
else
    git clone https://github.com/Nenson7/dotfiles "$HOME/dotfiles"
fi
cd ~/dotfiles && ./install.sh
cd ~

echo "INFO: Setting up zsh"
chsh -s $(which zsh)
exec zsh

echo "INFO: Installing brave"
curl -fsS https://dl.brave.com/install.sh | sh

echo "INFO: Installing nodejs LTS through nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

echo "INFO: Installing neovim"
wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
