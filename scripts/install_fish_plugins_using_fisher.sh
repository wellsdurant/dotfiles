#!/usr/bin/env bash

# Function to install Fish plugins using Fisher
install_fish_plugins_using_fisher() {
    echo "Installing Fish plugins using Fisher..."

    # Check if Fish shell is installed
    if ! command -v fish &>/dev/null; then
        echo "  Fish shell is not installed, skipping plugin installation..."
        return 1
    fi

    # Check if Fisher is installed
    if ! fish -c "type -q fisher" &>/dev/null; then
        echo "  Fisher is not installed, skipping plugin installation..."
        echo "  Please install Fisher first by running: make config"
        return 1
    fi

    # Install plugins from fish_plugins file
    echo "  Running fisher update to install plugins..."
    local output
    output=$(fish -c "fisher update" 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ] && ! echo "$output" | grep -qi "error\|failed"; then
        echo "  ✓ Fish plugins installed successfully"
    else
        echo "  ✗ Failed to install Fish plugins"
        if [ -n "$output" ]; then
            echo "  Error details: $output"
        fi
        echo "  You can install them manually by running:"
        echo "    fish -c \"fisher update\""
    fi
    echo ""
}
