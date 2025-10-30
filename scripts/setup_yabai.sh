#!/usr/bin/env bash

set -euo pipefail

# Source the SIP check functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$SCRIPT_DIR/check_sip_for_yabai.sh" ]]; then
    echo "Error: check_sip_for_yabai.sh not found in $SCRIPT_DIR"
    exit 1
fi

source "$SCRIPT_DIR/check_sip_for_yabai.sh"

# Main setup function
setup_yabai() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Yabai Setup"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # First, check SIP status
    if ! check_sip_for_yabai; then
        echo ""
        echo "❌ SIP is not properly configured for yabai"
        echo "Please configure SIP first before continuing"
        return 1
    fi

    echo ""
    # If SIP check passes, setup sudoers
    setup_yabai_sudoers
}

# Function to setup passwordless sudo for yabai scripting addition
setup_yabai_sudoers() {
    echo "Setting up passwordless sudo for yabai scripting addition..."

    # Check if yabai is installed
    if ! command -v yabai &>/dev/null; then
        echo "  ❌ yabai is not installed, skipping sudoers setup..."
        return 1
    fi

    local yabai_path
    yabai_path="$(which yabai)"
    local sudoers_file="/etc/sudoers.d/yabai"
    local current_user="$USER"

    # Calculate SHA-256 hash of yabai binary
    local yabai_hash
    yabai_hash=$(shasum -a 256 "$yabai_path" | awk '{print $1}')

    if [[ -z "$yabai_hash" ]]; then
        echo "  ❌ Failed to calculate yabai hash, aborting..."
        return 1
    fi

    # Check if sudoers file already exists
    if [[ -f "$sudoers_file" ]]; then
        # Check if hash matches current yabai
        if sudo grep -q "sha256:$yabai_hash" "$sudoers_file" 2>/dev/null; then
            echo "  ✓ yabai sudoers file is already up to date"
            return 0
        else
            echo "  ⚠️  Existing sudoers file has outdated hash (yabai was updated)"
            echo "  Updating sudoers file with new hash..."
        fi
    fi

    echo "  yabai path: $yabai_path"
    echo "  yabai hash: $yabai_hash"

    # Create temporary sudoers content
    local temp_file
    temp_file=$(mktemp)

    # Setup cleanup trap
    trap 'rm -f "$temp_file"' EXIT ERR

    cat > "$temp_file" << EOF
# Allow $current_user to load yabai scripting addition without password
# Created by dotfiles setup script on $(date)
#
# IMPORTANT: This hash is specific to the yabai binary at:
#   $yabai_path
# If yabai is updated, this file must be regenerated with the new hash.
# Run: bash scripts/setup_yabai.sh

$current_user ALL=(root) NOPASSWD: sha256:$yabai_hash $yabai_path --load-sa
EOF

    # Validate sudoers syntax
    echo "  Validating sudoers syntax..."
    if ! sudo visudo -c -f "$temp_file" &>/dev/null; then
        echo "  ❌ Generated sudoers file has syntax errors, aborting..."
        return 1
    fi

    # Copy to sudoers.d with proper permissions
    echo "  Creating sudoers file (requires sudo password)..."
    if sudo install -o root -g wheel -m 0440 "$temp_file" "$sudoers_file"; then
        echo "  ✓ Sudoers file created successfully at $sudoers_file"
        echo "  ✓ yabai scripting addition can now be loaded without password"
        echo ""
        echo "  You can now run without password:"
        echo "    sudo yabai --load-sa"
        echo ""
        echo "  ⚠️  IMPORTANT: If you update yabai, you must regenerate this file by running:"
        echo "    bash scripts/setup_yabai.sh"
    else
        echo "  ❌ Failed to create sudoers file"
        return 1
    fi

    echo ""
    return 0
}

# Execute the function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_yabai
fi
