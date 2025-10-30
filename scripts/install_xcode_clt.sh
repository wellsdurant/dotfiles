#!/usr/bin/env bash

# Function to install Xcode Command Line Tools
install_xcode_clt() {
    echo "Installing Xcode Command Line Tools..."

    # Check if Xcode Command Line Tools are already installed
    if xcode-select -p &>/dev/null; then
        echo "  ✓ Xcode Command Line Tools are already installed"
        local xcode_path=$(xcode-select -p)
        echo "    Path: $xcode_path"
        echo ""
        return 0
    fi

    echo "  Installing Xcode Command Line Tools..."
    echo "  A dialog will appear - please click 'Install' to continue."
    echo ""

    # Trigger the installation dialog
    xcode-select --install

    # Wait for installation to complete
    echo ""
    echo "  ⏳ Waiting for Xcode Command Line Tools installation to complete..."
    echo "  (This may take several minutes)"
    echo ""

    # Poll until installation is complete
    local max_attempts=240  # 10 minutes timeout (120 * 5 seconds)
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        if xcode-select -p &>/dev/null; then
            echo "  ✓ Xcode Command Line Tools installed successfully"
            local xcode_path=$(xcode-select -p)
            echo "    Path: $xcode_path"
            echo ""
            return 0
        fi

        sleep 5
        attempt=$((attempt + 1))
    done

    # Timeout reached
    echo "  ❌ Installation timeout reached"
    echo "  Please ensure Xcode Command Line Tools installation completed successfully"
    echo "  You can verify by running: xcode-select -p"
    echo ""
    return 1
}

# Execute the function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    install_xcode_clt
fi
