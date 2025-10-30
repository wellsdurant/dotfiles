#!/usr/bin/env bash

# Function to install Homebrew
install_homebrew() {
    echo "Installing Homebrew..."

    # Install Homebrew if not already installed
    if command -v brew &>/dev/null; then
        echo "  Homebrew already installed, skipping installation..."
    else
        echo "  Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Load Homebrew in current session
        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -f "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    echo ""
}
