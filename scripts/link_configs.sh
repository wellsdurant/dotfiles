#!/usr/bin/env bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the dotfiles root directory (parent of scripts/)
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Function to link configuration files
link_configs() {
    echo "Linking configuration files..."

    # Create backup directory with current date
    BACKUP_DIR="$DOTFILES_ROOT/backup_$(date +%Y%m%d_%H%M%S)"

    # Link all files in home/ to ~/
    if [ -d "$DOTFILES_ROOT/home" ]; then
        for home_file in "$DOTFILES_ROOT/home"/*; do
            if [ -f "$home_file" ]; then
                file_name=$(basename "$home_file")
                target="$HOME/.$file_name"

                # Backup existing file if it's not already a symlink
                if [ -f "$target" ] && [ ! -L "$target" ]; then
                    mkdir -p "$BACKUP_DIR"
                    cp "$target" "$BACKUP_DIR/$file_name"
                    echo "  Backed up existing ~/.$file_name to $BACKUP_DIR/$file_name"
                fi

                # Create symlink
                if ln -sfn "$home_file" "$target"; then
                    echo "  Linked home/$file_name -> ~/.$file_name"
                else
                    echo "  ERROR: Failed to link $file_name"
                fi
            fi
        done
    fi

    # Link all directories in config/ to ~/.config/
    echo ""
    if [ -d "$DOTFILES_ROOT/config" ]; then
        mkdir -p "$HOME/.config"
        for config_dir in "$DOTFILES_ROOT/config"/*; do
            if [ -d "$config_dir" ]; then
                dir_name=$(basename "$config_dir")
                target="$HOME/.config/$dir_name"

                # Backup existing directory if it's not already a symlink
                if [ -d "$target" ] && [ ! -L "$target" ]; then
                    mkdir -p "$BACKUP_DIR"
                    if cp -r "$target" "$BACKUP_DIR/$dir_name"; then
                        echo "  Backed up existing .config/$dir_name to $BACKUP_DIR/$dir_name"
                        rm -rf "$target"
                    else
                        echo "  ERROR: Failed to backup $dir_name, skipping..."
                        continue
                    fi
                fi

                # Create symlink
                if ln -sfn "$config_dir" "$target"; then
                    echo "  Linked config/$dir_name -> ~/.config/$dir_name"
                else
                    echo "  ERROR: Failed to link $dir_name"
                fi
            fi
        done
    fi
}
