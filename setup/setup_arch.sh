#!/usr/bin/env bash
set -e

echo "==> Updating system packages"
sudo pacman -Syu --noconfirm

echo "==> Installing essential packages"
sudo pacman -S --noconfirm \
    git base-devel vim curl wget \
    python python-pip ripgrep fd zsh btop fzf \
    vlc tlp wezterm

# # Optional codecs (equivalent to ubuntu-restricted-extras)
# sudo pacman -S --noconfirm gst-libav gst-plugins-ugly gst-plugins-good gst-plugins-bad

# echo "==> Copying dotfiles"
# if [ -d "$HOME/dotfiles/.git" ]; then
#     cd "$HOME/dotfiles"
#     git fetch origin
#     git reset --hard origin/main
# else
#     git clone https://github.com/Nenson7/dotfiles "$HOME/dotfiles"
# fi
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

yay -S --noconfirm brave-bin

echo "==> Installing Node.js LTS via nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source nvm to current shell so you can immediately use it
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

echo "==> Installing Neovim (latest prebuilt binary)"
wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz -O /tmp/nvim.tar.gz
sudo tar xzvf /tmp/nvim.tar.gz -C /usr/local --strip-components=1

echo "==> Setup complete!"
