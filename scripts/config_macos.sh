#!/usr/bin/env bash

set -euo pipefail

# Function to verify the OS is macOS
verify_macos() {
    local os_type
    os_type=$(uname -s)
    if [[ "$os_type" != "Darwin" ]]; then
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
    "install_xcode_clt.sh"
    "install_homebrew.sh"
    "install_macports.sh"
    "setup_macports_sudoers.sh"
    "install_mas.sh"
    "install_applications.sh"
    "link_configs.sh"
    "setup_yabai.sh"
    "install_fisher.sh"
    "install_fish_plugins_using_fisher.sh"
    "configure_obsidian.sh"
    "setup_git_lfs.sh"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [[ -f "$SCRIPT_DIR/$script" ]]; then
        if ! source "$SCRIPT_DIR/$script"; then
            echo "Error: Failed to source '$script'"
            exit 1
        fi
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

    # Install Xcode Command Line Tools
    install_xcode_clt

    # Install Homebrew
    install_homebrew

    # Install MacPorts
    install_macports

    # Setup passwordless sudo for MacPorts
    if ! setup_macports_sudoers; then
        echo "⚠️  MacPorts sudoers setup failed, but continuing..."
        echo ""
    fi

    # Install mas (Mac App Store CLI)
    install_mas

    # Install applications (Homebrew, MacPorts, mas)
    install_applications

    # Link configurations
    link_configs

    # Setup yabai (checks SIP and configures sudoers)
    if ! setup_yabai; then
        echo "⚠️  yabai setup failed, but continuing..."
        echo ""
    fi

    # Check if Fish shell was successfully installed before setting up Fisher
    if command -v fish &>/dev/null; then
        # Install Fisher plugin manager
        install_fisher

        # Install fish plugins using Fisher
        install_fish_plugins_using_fisher
    else
        echo "⚠️  Fish shell is not installed, skipping Fisher setup..."
        echo "  Install Fish shell manually and run 'make config' again to set up Fisher"
        echo ""
    fi

    # Configure Obsidian
    configure_obsidian

    # Setup Git LFS
    if ! setup_git_lfs; then
        echo "⚠️  Git LFS setup failed, but continuing..."
        echo ""
    fi

    echo "Configuration complete!"
}

# Execute main
main
