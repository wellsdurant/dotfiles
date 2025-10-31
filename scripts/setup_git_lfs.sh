#!/usr/bin/env bash

set -euo pipefail

# Function to setup Git LFS (Large File Storage)
setup_git_lfs() {
    echo "Setting up Git LFS..."

    # Check if git-lfs is installed
    if ! command -v git-lfs &>/dev/null; then
        echo "  ❌ git-lfs is not installed, skipping setup..."
        return 1
    fi

    # Check if git-lfs is already initialized
    if git lfs env &>/dev/null 2>&1; then
        if git config --global --get filter.lfs.process &>/dev/null; then
            echo "  ✓ Git LFS is already initialized"
            return 0
        fi
    fi

    # Initialize git-lfs
    echo "  Initializing Git LFS..."
    if git lfs install; then
        echo "  ✓ Git LFS initialized successfully"
        echo ""
        echo "  Git LFS is now configured for this user"
        echo "  You can now use 'git lfs track' to track large files"
    else
        echo "  ❌ Failed to initialize Git LFS"
        return 1
    fi

    echo ""
    return 0
}

# Execute the function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_git_lfs
fi
