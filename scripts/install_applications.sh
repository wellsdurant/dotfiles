#!/usr/bin/env bash

# Function to install MacPorts packages
install_port_packages() {
    echo "  Installing MacPorts packages..."

    # Check if port is installed using absolute path
    if [ ! -x /opt/local/bin/port ]; then
        echo "    MacPorts is not installed, skipping MacPorts packages..."
        return
    fi

    # Define MacPorts packages to install
    local port_packages=(
        "lua51"
    )

    # Install each MacPorts package
    for package in "${port_packages[@]}"; do
        if /opt/local/bin/port installed "$package" 2>/dev/null | grep -qw "$package"; then
            echo "    $package already installed, skipping..."
        else
            echo "    Installing $package..."
            sudo /opt/local/bin/port install "$package"
        fi
    done
}

# Function to install Mac App Store applications using mas
install_mas_applications() {
    echo "  Installing Mac App Store applications..."

    # Check if mas is installed
    if ! command -v mas &>/dev/null; then
        echo "  mas is not installed, skipping Mac App Store applications..."
        return
    fi

    # Define Mac App Store applications to install
    # Format: "app_id:app_name"
    local mas_apps=(
        "302584613:Kindle"
        "539883307:LINE"
    )

    # Install each Mac App Store application
    for app_entry in "${mas_apps[@]}"; do
        local app_id="${app_entry%%:*}"
        local app_name="${app_entry##*:}"

        if mas list | grep -q "^$app_id"; then
            echo "    $app_name already installed, skipping..."
        else
            echo "    Installing $app_name..."
            mas install "$app_id"
        fi
    done
}

# Function to install applications via Homebrew
install_applications() {
    echo "Installing applications..."

    # Update package managers to latest versions
    echo "  Updating package managers..."

    # Update Homebrew
    if command -v brew &>/dev/null; then
        echo "    Updating Homebrew..."
        brew update
    fi

    # Update MacPorts
    if [ -x /opt/local/bin/port ]; then
        echo "    Updating MacPorts..."
        sudo /opt/local/bin/port selfupdate
    fi

    echo ""

    # Define cask applications to install
    local cask_apps=(
        # Fonts
        "font-jetbrains-mono-nerd-font"
        "sf-symbols"

        "karabiner-elements"
        "homerow"
        "espanso"
        "betterdisplay"
        "macs-fan-control"
        "raycast"
        "kitty"
        "claude"
        "brave-browser"
        "obsidian"
        "zotero"
        "pdf-expert"
        "visual-studio-code"
    )

    # Define formula applications to install
    local formula_apps=(
        "yabai"
        "skhd"
        "sketchybar"

        "fish"

        # The command-line interface for Mac App Store
        "mas"

        # Command-line tools:
        "tlrc"
        "zoxide"
        "tmux"
        "sesh"
        "fzf"
        "fd"
        "neovim"
        "uv"
    )

    # Install each cask application
    echo "  Installing Homebrew cask applications..."
    for app in "${cask_apps[@]}"; do
        if brew list --cask "$app" &>/dev/null; then
            echo "    $app already installed, skipping..."
        else
            echo "    Installing $app..."
            brew install --cask "$app"
        fi
    done

    # Install each formula application
    echo ""
    echo "  Installing Homebrew formula applications..."
    for app in "${formula_apps[@]}"; do
        if brew list "$app" &>/dev/null; then
            echo "    $app already installed, skipping..."
        else
            echo "    Installing $app..."
            brew install "$app"
        fi
    done

    # Install MacPorts packages
    echo ""
    install_port_packages

    # Install Mac App Store applications
    echo ""
    install_mas_applications
}

