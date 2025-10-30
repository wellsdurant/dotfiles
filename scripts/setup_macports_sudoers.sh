#!/usr/bin/env bash

# Function to setup passwordless sudo for MacPorts commands
setup_macports_sudoers() {
    echo "Setting up passwordless sudo for MacPorts..."

    # Check if MacPorts is installed
    if [ ! -x /opt/local/bin/port ]; then
        echo "  ❌ MacPorts is not installed, skipping sudoers setup..."
        return 1
    fi

    local port_path="/opt/local/bin/port"
    local sudoers_file="/etc/sudoers.d/macports"
    local current_user="$USER"

    # Check if sudoers file already exists
    if [ -f "$sudoers_file" ]; then
        echo "  ✓ MacPorts sudoers file already exists, skipping..."
        echo ""
        return 0
    fi

    # Create temporary sudoers content
    local temp_file=$(mktemp)
    cat > "$temp_file" << EOF
# Allow $current_user to run MacPorts commands without password
# Created by dotfiles setup script on $(date)

# MacPorts package management commands
$current_user ALL=(root) NOPASSWD: $port_path install *
$current_user ALL=(root) NOPASSWD: $port_path uninstall *
$current_user ALL=(root) NOPASSWD: $port_path upgrade *
$current_user ALL=(root) NOPASSWD: $port_path selfupdate
$current_user ALL=(root) NOPASSWD: $port_path sync
$current_user ALL=(root) NOPASSWD: $port_path clean *
$current_user ALL=(root) NOPASSWD: $port_path reclaim
$current_user ALL=(root) NOPASSWD: $port_path load *
$current_user ALL=(root) NOPASSWD: $port_path unload *
EOF

    # Validate sudoers syntax
    if ! sudo visudo -c -f "$temp_file" &>/dev/null; then
        echo "  ❌ Generated sudoers file has syntax errors, aborting..."
        rm -f "$temp_file"
        return 1
    fi

    # Copy to sudoers.d with proper permissions
    echo "  Creating sudoers file (requires sudo password)..."
    if sudo install -o root -g wheel -m 0440 "$temp_file" "$sudoers_file"; then
        echo "  ✓ Sudoers file created successfully at $sudoers_file"
        echo "  ✓ MacPorts commands will no longer require password"
        echo ""
        echo "  The following commands now run without password:"
        echo "    - sudo port install <package>"
        echo "    - sudo port uninstall <package>"
        echo "    - sudo port upgrade <package>"
        echo "    - sudo port selfupdate"
        echo "    - sudo port sync"
        echo "    - sudo port clean <package>"
        echo "    - sudo port reclaim"
        echo "    - sudo port load <package>"
        echo "    - sudo port unload <package>"
    else
        echo "  ❌ Failed to create sudoers file"
        rm -f "$temp_file"
        return 1
    fi

    # Clean up temporary file
    rm -f "$temp_file"

    echo ""
    return 0
}

# Execute the function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    setup_macports_sudoers
fi
