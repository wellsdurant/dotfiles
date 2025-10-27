#!/usr/bin/env bash

# Function to verify the OS is macOS
verify_macos() {
    local os_type=$(uname -s)
    if [ "$os_type" != "Darwin" ]; then
        echo "Error: This script is designed for macOS only."
        echo "Current OS: $os_type"
        echo "Exiting..."
        exit 1
    fi
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the setup scripts with error handling
REQUIRED_SCRIPTS=(
    "configure_macos_builtin_settings.sh"
    "install_homebrew.sh"
    "install_macports.sh"
    "install_applications.sh"
    "link_configs.sh"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        source "$SCRIPT_DIR/$script"
    else
        echo "Error: Required script '$script' not found in $SCRIPT_DIR"
        exit 1
    fi
done

# Main function
main() {
    # Verify we're running on macOS
    verify_macos

    echo "Starting macOS configuration..."
    echo ""

    # Configure macOS built-in settings
    configure_macos_builtin_settings
    echo ""

    # Install Homebrew
    install_homebrew
    echo ""

    # Install MacPorts
    install_macports
    echo ""

    # Install applications
    install_applications
    echo ""

    # Link configurations
    link_configs
    echo ""

    echo "Configuration complete!"
}

# Execute main
main
