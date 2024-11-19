#!/bin/sh

# Check Ubuntu version
ubuntu_version=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2)

# Backup and change package repository
if [ "$ubuntu_version" = "22.04" ]; then
    # Process for version 22.04
    sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
elif [ "$ubuntu_version" = "24.04" ]; then
    # Process for version 24.04
    sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list.d/ubuntu.sources
else
    echo "Unsupported Ubuntu version."
    exit 1
fi

# Update and upgrade: Update package list, upgrade packages, and remove unnecessary packages
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Install zsh
if ! command -v zsh >/dev/null 2>&1; then
    sudo apt install -y zsh
else
    echo "zsh is already installed."
fi

# Install Oh My Zsh
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Get Git username input
echo "Enter Git username:"
read git_username
if [ -n "$git_username" ]; then
    git config --global user.name "$git_username"
else
    echo "Git username not entered. Skipping configuration."
fi

# Get Git email input
echo "Enter Git email"
read git_email
if [ -n "$git_email" ]; then
    git config --global user.email "$git_email"
else
    echo "Git email not entered. Skipping configuration."
fi

# Set Git default editor
git config --global core.editor vim

# Set Git initial branch
git config --global init.defaultBranch main

# # Install Korean language package
# if ! dpkg -l | grep -q language-pack-ko; then
#     sudo apt install -y language-pack-ko
# else
#     echo "Korean language package is already installed."
# fi

# # Install and configure Korean locale
# sudo locale-gen ko_KR.UTF-8 && sudo update-locale LANG=ko_KR.UTF-8 LC_ALL=ko_KR.UTF-8

# zsh custom settings
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSHRC_FILE="$HOME/.zshrc"
# # Install Powerlevel10k theme
# POWERLEVEL10K_DIR="${ZSH_CUSTOM}/themes/powerlevel10k"
# if [ ! -d "$POWERLEVEL10K_DIR" ]; then
#     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_DIR"
# else
#     echo "Powerlevel10k theme is already installed."
# fi

# # Configure Powerlevel10k theme
# sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC_FILE"

# Change zsh theme to zhann
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="zhann"/' "$ZSHRC_FILE"

# Install zsh-syntax-highlighting plugin
ZSH_SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
else
    echo "zsh-syntax-highlighting plugin is already installed."
fi

# Install zsh-autosuggestions plugin
ZSH_AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGESTIONS_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_DIR"
else
    echo "zsh-autosuggestions plugin is already installed."
fi

# Add plugins to .zshrc file
if ! grep -q "plugins=(" "$ZSHRC_FILE"; then
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' >> "$ZSHRC_FILE"
else
    sed -i '/^plugins=/ s/)$/ zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC_FILE"
fi

# Ensure Oh My Zsh is properly sourced in .zshrc
if ! grep -q "source \$ZSH/oh-my-zsh.sh" "$ZSHRC_FILE"; then
    echo 'source $ZSH/oh-my-zsh.sh' >> "$ZSHRC_FILE"
fi

# Switch to zsh
exec zsh