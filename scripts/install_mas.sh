#!/usr/bin/env bash

# Function to install mas (Mac App Store CLI)
install_mas() {
    echo "Installing mas (Mac App Store CLI)..."

    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        echo "  ❌ Homebrew is not installed, skipping mas installation..."
        echo ""
        return 1
    fi

    # Check if mas is already installed
    if command -v mas &>/dev/null; then
        echo "  ✓ mas is already installed, skipping..."
        echo ""
        return 0
    fi

    echo "  Installing mas..."
    if brew install mas; then
        echo "  ✓ mas installed successfully"
        echo ""
        return 0
    else
        echo "  ❌ Failed to install mas"
        echo ""
        return 1
    fi
}

# Execute the function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    install_mas
fi
