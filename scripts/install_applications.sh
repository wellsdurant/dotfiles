#!/usr/bin/env bash

set -euo pipefail

# Homebrew applications list
# Format: "app_name|type" where type is "cask" or "formula"
HOMEBREW_APPS=(
    # System Enhancers
    ## Fan control
    "macs-fan-control|cask"

    ## Display control
    "betterdisplay|cask"

    ## Menu bar
    "sketchybar|formula"

    # Window Management
    "koekeishiya/formulae/yabai|formula"
    "koekeishiya/formulae/skhd|formula"

    # Fonts
    "font-jetbrains-mono-nerd-font|cask"
    "sf-symbols|cask"

    # Productivity Tools
    "karabiner-elements|cask"
    "homerow|cask"
    "espanso|cask"
    "raycast|cask"

    # Terminal & Shell
    "kitty|cask"
    "fish|formula"
    "tmux|formula"

    # Development Tools
    "visual-studio-code|cask"
    "neovim|formula"
    "uv|formula"

    # Command-line Tools
    "tlrc|formula"
    "zoxide|formula"
    "sesh|formula"
    "fzf|formula"
    "fd|formula"

    # Applications
    "claude|cask"
    "brave-browser|cask"
    "obsidian|cask"
    "zotero|cask"
    "pdf-expert|cask"
)

# Function to install Homebrew applications
install_homebrew_applications() {
    echo "Installing Homebrew applications..."

    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        echo "  ❌ Homebrew is not installed, skipping Homebrew applications..."
        return 1
    fi

    # Update Homebrew
    echo "  Updating Homebrew..."
    brew update
    echo ""

    # Buffer installed packages to avoid repeated brew list calls
    echo "  Checking installed packages..."
    local installed_casks
    local installed_formulas
    installed_casks=$(brew list --cask 2>/dev/null)
    installed_formulas=$(brew list --formula 2>/dev/null)

    # Counters for statistics
    local total="${#HOMEBREW_APPS[@]}"
    local installed=0
    local skipped=0
    local failed=0

    # Install each application
    echo "  Installing applications (${total} total)..."
    echo ""

    for app_entry in "${HOMEBREW_APPS[@]}"; do
        # Skip empty lines and comments
        [[ -z "$app_entry" || "$app_entry" =~ ^[[:space:]]*# ]] && continue

        # Parse install_command and app_type using delimiter
        local install_command="${app_entry%%|*}"
        local app_type="${app_entry##*|}"

        # Extract app name from install command
        # For "koekeishiya/formulae/skhd" -> "skhd"
        # For "git" -> "git"
        local app_name="${install_command##*/}"

        # Check if already installed using buffered list
        local is_installed=false
        if [[ "$app_type" == "cask" ]]; then
            if echo "$installed_casks" | grep -qw "$app_name"; then
                is_installed=true
            fi
        else
            if echo "$installed_formulas" | grep -qw "$app_name"; then
                is_installed=true
            fi
        fi

        if [[ "$is_installed" == true ]]; then
            ((skipped++))
            echo "    ✓ $app_name ($app_type) already installed"
        else
            echo "    ⬇ Installing $app_name ($app_type)..."
            if [[ "$app_type" == "cask" ]]; then
                if brew install --cask "$install_command"; then
                    ((installed++))
                    echo "    ✓ $app_name installed successfully"
                else
                    ((failed++))
                    echo "    ❌ Failed to install $app_name"
                fi
            else
                if brew install "$install_command"; then
                    ((installed++))
                    echo "    ✓ $app_name installed successfully"
                else
                    ((failed++))
                    echo "    ❌ Failed to install $app_name"
                fi
            fi
        fi
    done

    echo ""
    echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Installation Summary:"
    echo "    Total apps:      $total"
    echo "    Newly installed: $installed"
    echo "    Already present: $skipped"
    echo "    Failed:          $failed"
    echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [[ $failed -gt 0 ]]; then
        echo "  ⚠️  Some applications failed to install"
        return 1
    fi

    echo "  ✓ Homebrew applications installation complete"
    return 0
}

# Function to install MacPorts packages
install_macports_packages() {
    echo "Installing MacPorts packages..."

    # Check if port is installed using absolute path
    if [ ! -x /opt/local/bin/port ]; then
        echo "  ❌ MacPorts is not installed, skipping MacPorts packages..."
        return 1
    fi

    # Update MacPorts
    echo "  Updating MacPorts..."
    sudo /opt/local/bin/port selfupdate
    echo ""

    # Define MacPorts packages to install
    local port_packages=(
        "lua51"
    )

    # Install each MacPorts package
    echo "  Installing MacPorts packages..."
    for package in "${port_packages[@]}"; do
        if /opt/local/bin/port installed "$package" 2>/dev/null | grep -qw "$package"; then
            echo "    $package already installed, skipping..."
        else
            echo "    Installing $package..."
            sudo /opt/local/bin/port install "$package"
        fi
    done

    echo ""
    echo "  ✓ MacPorts packages installation complete"
}

# Function to install Mac App Store applications using mas
install_mas_applications() {
    echo "Installing Mac App Store applications..."

    # Check if mas is installed
    if ! command -v mas &>/dev/null; then
        echo "  ❌ mas is not installed, skipping Mac App Store applications..."
        return 1
    fi

    # Define Mac App Store applications to install
    # Format: "app_id:app_name"
    local mas_apps=(
        "302584613:Kindle"
        "539883307:LINE"
    )

    # Install each Mac App Store application
    echo "  Installing Mac App Store applications..."
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

    echo ""
    echo "  ✓ Mac App Store applications installation complete"
}

# Wrapper function to install all applications
install_applications() {
    # Install Homebrew applications
    if ! install_homebrew_applications; then
        echo "⚠️  Homebrew applications installation had issues, but continuing..."
    fi
    echo ""

    # Install MacPorts packages
    if ! install_macports_packages; then
        echo "⚠️  MacPorts packages installation had issues, but continuing..."
    fi
    echo ""

    # Install Mac App Store applications
    if ! install_mas_applications; then
        echo "⚠️  Mac App Store applications installation had issues, but continuing..."
    fi

    echo ""
    return 0
}

