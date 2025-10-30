#!/usr/bin/env bash

# Global variable to track if logout is needed
LOGOUT_NEEDED=false

# Function to disable "Hide Obsidian" keyboard shortcut
disable_hide_obsidian_shortcut() {
    # Check if Obsidian is installed
    if [ ! -d "/Applications/Obsidian.app" ]; then
        echo "  Obsidian is not installed, skipping..."
        return 0
    fi

    local current_value=$(defaults read md.obsidian NSUserKeyEquivalents 2>/dev/null || echo "")
    if echo "$current_value" | grep -q '"Hide Obsidian".*=.*"@~^$\\\\Uf70f"'; then
        echo "  'Hide Obsidian' already disabled, skipping..."
    else
        echo "  Disabling 'Hide Obsidian' by remapping to <Cmd+Ctrl+Alt+Shift+F12>..."
        defaults write md.obsidian NSUserKeyEquivalents -dict-add "Hide Obsidian" "@~^\$\Uf70f"
        LOGOUT_NEEDED=true
    fi
}

# Function to handle logout if needed
logout_if_needed() {
    if [ "$LOGOUT_NEEDED" = true ]; then
        echo ""
        echo "Some changes require logging out to take effect."
        read -p "Do you want to log out now? (y/n): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Logging out to apply changes..."
            osascript -e 'tell application "System Events" to log out'
            exit 0
        else
            echo "Logout cancelled. Please log out manually to apply all changes."
            exit 0
        fi
    fi
}

# Main function to configure Obsidian
configure_obsidian() {
    echo "Configuring Obsidian..."
    echo ""

    # Disable hide shortcut
    disable_hide_obsidian_shortcut
    echo ""

    # Handle logout if needed
    logout_if_needed
    echo ""
}

# Execute the function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    configure_obsidian
fi
