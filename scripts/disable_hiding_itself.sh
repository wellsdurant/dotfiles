#!/usr/bin/env bash

# Global variable to track if logout is needed
LOGOUT_NEEDED=false

# Function to disable "Hide" keyboard shortcut for a specific application
disable_hide_shortcut() {
    local app_name="$1"
    local app_path="$2"
    local bundle_id="$3"
    local menu_item="$4"

    # Check if application is installed
    if [ ! -d "$app_path" ]; then
        echo "  $app_name is not installed, skipping..."
        return 0
    fi

    local current_value=$(defaults read "$bundle_id" NSUserKeyEquivalents 2>/dev/null || echo "")
    if echo "$current_value" | grep -q "\"$menu_item\".*=.*\"@~^$\\\\Uf70f\""; then
        echo "  '$menu_item' already disabled for $app_name, skipping..."
    else
        echo "  Disabling '$menu_item' for $app_name by remapping to <Cmd+Ctrl+Alt+Shift+F12>..."
        defaults write "$bundle_id" NSUserKeyEquivalents -dict-add "$menu_item" "@~^\$\Uf70f"
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

# Main function to disable "Hide" shortcuts for applications
disable_hiding_itself() {
    echo "Disabling 'Hide' keyboard shortcuts for applications..."
    echo ""

    # Disable hide shortcut for Obsidian
    disable_hide_shortcut "Obsidian" "/Applications/Obsidian.app" "md.obsidian" "Hide Obsidian"
    echo ""

    # Disable hide shortcut for Brave Browser
    disable_hide_shortcut "Brave Browser" "/Applications/Brave Browser.app" "com.brave.Browser" "Hide Brave Browser"
    echo ""

    # Disable hide shortcut for Claude
    disable_hide_shortcut "Claude" "/Applications/Claude.app" "com.anthropic.claude" "Hide Claude"
    echo ""

    # Handle logout if needed
    logout_if_needed
}

# Execute the function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    disable_hiding_itself
fi
