#!/usr/bin/env bash

# Function to install Fisher plugin manager for Fish shell
install_fisher() {
    echo "Checking Fisher plugin manager for Fish shell..."

    # Check if Fish shell is installed
    if ! command -v fish &>/dev/null; then
        echo "  Fish shell is not installed, skipping Fisher installation..."
        return 1
    fi

    # Check if Fisher is already installed
    if fish -c "type -q fisher" &>/dev/null; then
        echo "  Fisher is already installed, skipping..."
        return 0
    fi

    echo "  Installing Fisher plugin manager..."
    local output
    output=$(fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>&1)
    local exit_code=$?

    if [ $exit_code -eq 0 ] && ! echo "$output" | grep -qi "error\|failed"; then
        echo "  ✓ Fisher installed successfully"
    else
        echo "  ✗ Failed to install Fisher"
        if [ -n "$output" ]; then
            echo "  Error details: $output"
        fi
        echo "  You can install it manually by running:"
        echo "    fish -c \"curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher\""
    fi
    echo ""
}
