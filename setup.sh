#!/bin/bash

# Define variables
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="$HOME/.bash-rahul-backups/$TIMESTAMP"
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASHRC_SRC="$DOTFILES_DIR/.bashrc"
STARSHIP_SRC="$DOTFILES_DIR/starship.toml"
BASHRC_DEST="$HOME/.bashrc"
STARSHIP_DEST="$HOME/.config/starship.toml"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Bash-Rahul Setup...${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${YELLOW}Backup directory created: $BACKUP_DIR${NC}"

# Backup and Link .bashrc
if [ -f "$BASHRC_DEST" ]; then
    echo -e "${YELLOW}Backing up existing .bashrc...${NC}"
    mv "$BASHRC_DEST" "$BACKUP_DIR/.bashrc"
fi
echo -e "${GREEN}Linking .bashrc...${NC}"
ln -s "$BASHRC_SRC" "$BASHRC_DEST"

# Backup and Link starship.toml
mkdir -p "$HOME/.config"
if [ -f "$STARSHIP_DEST" ]; then
    echo -e "${YELLOW}Backing up existing starship.toml...${NC}"
    mv "$STARSHIP_DEST" "$BACKUP_DIR/starship.toml"
fi
echo -e "${GREEN}Linking starship.toml...${NC}"
ln -s "$STARSHIP_SRC" "$STARSHIP_DEST"

# Check Dependencies
echo -e "${GREEN}Checking dependencies...${NC}"
DEPS=("starship" "fastfetch" "zoxide" "fzf" "trash" "nvim" "bat" "batcat" "lsb_release")

for cmd in "${DEPS[@]}"; do
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}[OK] $cmd is installed${NC}"
    else
        echo -e "${RED}[MISSING] $cmd is not installed. Please install it for full functionality.${NC}"
    fi
done

echo -e "${GREEN}Setup complete!${NC}"
echo -e "${YELLOW}Please restart your terminal or run: source ~/.bashrc${NC}"
