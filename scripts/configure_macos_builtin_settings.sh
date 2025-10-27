#!/usr/bin/env bash

# Global variable to track if Dock needs restart
DOCK_NEEDS_RESTART=false

# Global variable to track if logout is needed
LOGOUT_NEEDED=false

# Function to configure Dock auto-hide
configure_dock_autohide() {
    local dock_autohide=$(defaults read com.apple.dock autohide 2>/dev/null)
    if [ "$dock_autohide" = "1" ]; then
        echo "  Dock auto-hide already enabled, skipping..."
    else
        echo "  Configuring Dock to auto-hide..."
        defaults write com.apple.dock autohide -bool true
        DOCK_NEEDS_RESTART=true
    fi
}

# Function to configure hot corners
configure_hot_corners() {
    local corners=("tl" "tr" "bl" "br")
    local needs_update=false
    for corner in "${corners[@]}"; do
        local current_value=$(defaults read com.apple.dock "wvous-${corner}-corner" 2>/dev/null)
        if [ "$current_value" != "0" ]; then
            needs_update=true
            break
        fi
    done
    if [ "$needs_update" = false ]; then
        echo "  Hot corners already disabled, skipping..."
    else
        echo "  Configuring Hot Corners to be disabled..."
        for corner in "${corners[@]}"; do
            defaults write com.apple.dock "wvous-${corner}-corner" -int 0
        done
        DOCK_NEEDS_RESTART=true
    fi
}

# Function to disable automatic space rearrangement
configure_space_rearrangement() {
    local mru_spaces=$(defaults read com.apple.dock mru-spaces 2>/dev/null)
    if [ "$mru_spaces" = "0" ]; then
        echo "  Automatic space rearrangement already disabled, skipping..."
    else
        echo "  Disabling automatic space rearrangement..."
        defaults write com.apple.dock mru-spaces -bool false
        DOCK_NEEDS_RESTART=true
    fi
}

# Function to disable press-and-hold for accent characters
configure_press_and_hold() {
    local press_hold=$(defaults read -g ApplePressAndHoldEnabled 2>/dev/null)
    if [ "$press_hold" = "0" ]; then
        echo "  Press-and-hold already disabled, skipping..."
    else
        echo "  Disabling press-and-hold for accent characters..."
        defaults write -g ApplePressAndHoldEnabled -bool false
        LOGOUT_NEEDED=true
    fi
}

# Function to disable automatic period substitution
configure_period_substitution() {
    local period_sub=$(defaults read -g NSAutomaticPeriodSubstitutionEnabled 2>/dev/null)
    if [ "$period_sub" = "0" ]; then
        echo "  Automatic period substitution already disabled, skipping..."
    else
        echo "  Disabling automatic period substitution..."
        defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
        LOGOUT_NEEDED=true
    fi
}

# Function to disable Spotlight keyboard shortcut
configure_spotlight_shortcut() {
    local spotlight_enabled=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:64:enabled" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    if [ "$spotlight_enabled" = "false" ]; then
        echo "  Spotlight keyboard shortcut already disabled, skipping..."
    else
        echo "  Disabling Spotlight keyboard shortcut (Command+Space)..."
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"
        LOGOUT_NEEDED=true
    fi
}

# Function to configure input source switching to Alt+Space
configure_input_source_switching() {
    local enabled=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:60:enabled" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    local param0=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:60:value:parameters:0" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    local param1=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:60:value:parameters:1" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    local param2=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:60:value:parameters:2" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    if [ "$enabled" = "true" ] && [ "$param0" = "32" ] && [ "$param1" = "49" ] && [ "$param2" = "524288" ]; then
        echo "  Input source switching (Alt+Space) already configured, skipping..."
    else
        echo "  Configuring input source switching to Alt+Space..."
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '
            <dict>
              <key>enabled</key><true/>
              <key>value</key><dict>
                <key>parameters</key>
                <array>
                  <integer>32</integer>   <!-- Space character (ASCII) -->
                  <integer>49</integer>   <!-- Key code for Space key -->
                  <integer>524288</integer>   <!-- Alt/Option modifier (2^19) -->
                </array>
                <key>type</key>
                <string>standard</string>
              </dict>
            </dict>'
        LOGOUT_NEEDED=true
    fi
}

# Function to configure F16 to toggle Do Not Disturb
configure_dnd_f16() {
    local enabled=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:175:enabled" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    local param0=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:175:value:parameters:0" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    local param1=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:175:value:parameters:1" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)
    local param2=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:175:value:parameters:2" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null)

    # Check if already configured with F16 key [65535, 106, 0]
    if [ "$enabled" = "true" ] && [ "$param0" = "65535" ] && [ "$param1" = "106" ] && [ "$param2" = "0" ]; then
        echo "  Do Not Disturb toggle (F16) already configured, skipping..."
    else
        echo "  Configuring F16 to toggle Do Not Disturb..."
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 175 "
            <dict>
              <key>enabled</key>
              <true/>
              <key>value</key>
              <dict>
                <key>type</key>
                <string>standard</string>
                <key>parameters</key>
                <array>
                  <integer>65535</integer>   <!-- No character code -->
                  <integer>106</integer>   <!-- F16 key code -->
                  <integer>0</integer>   <!-- No modifier keys -->
                </array>
              </dict>
            </dict>"
        LOGOUT_NEEDED=true
    fi
}

# Function to disable "Minimize" keyboard shortcut
disable_minimize_shortcut() {
    local current_value=$(defaults read -g NSUserKeyEquivalents 2>/dev/null || echo "")
    if echo "$current_value" | grep -q 'Minimize.*=.*"@~^$\\\\Uf70f"'; then
        echo "  'Minimize' already disabled, skipping..."
    else
        echo "  Disabling 'Minimize' by remapping to <Cmd+Ctrl+Alt+Shift+F12>..."
        defaults write -g NSUserKeyEquivalents -dict-add "Minimize" "@~^\$\Uf70f"
        LOGOUT_NEEDED=true
    fi
}

# Function to disable "Hide Others" keyboard shortcut
disable_hide_others_shortcut() {
    local current_value=$(defaults read -g NSUserKeyEquivalents 2>/dev/null || echo "")
    if echo "$current_value" | grep -q '"Hide Others".*=.*"@~^$\\\\Uf70f"'; then
        echo "  'Hide Others' already disabled, skipping..."
    else
        echo "  Disabling 'Hide Others' by remapping to <Cmd+Ctrl+Alt+Shift+F12>..."
        defaults write -g NSUserKeyEquivalents -dict-add "Hide Others" "@~^\$\Uf70f"
        LOGOUT_NEEDED=true
    fi
}

# Function to disable "Hide Obsidian" keyboard shortcut
disable_hide_obsidian_shortcut() {
    local current_value=$(defaults read md.obsidian NSUserKeyEquivalents 2>/dev/null || echo "")
    if echo "$current_value" | grep -q '"Hide Obsidian".*=.*"@~^$\\\\Uf70f"'; then
        echo "  'Hide Obsidian' already disabled, skipping..."
    else
        echo "  Disabling 'Hide Obsidian' by remapping to <Cmd+Ctrl+Alt+Shift+F12>..."
        defaults write md.obsidian NSUserKeyEquivalents -dict-add "Hide Obsidian" "@~^\$\Uf70f"
        LOGOUT_NEEDED=true
    fi
}

# Function to restart Dock if needed
restart_dock_if_needed() {
    if [ "$DOCK_NEEDS_RESTART" = true ]; then
        echo "Restarting Dock..."
        killall Dock
        echo "Dock restarted"
    fi
}

# Function to logout if needed
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

# Function to configure all macOS built-in settings
configure_macos_builtin_settings() {
    echo "Configuring macOS settings..."

    # Dock settings
    configure_dock_autohide
    configure_hot_corners
    configure_space_rearrangement
    echo ""

    # Keyboard and text settings
    configure_press_and_hold
    configure_period_substitution
    echo ""

    # Keyboard shortcuts
    configure_spotlight_shortcut
    configure_input_source_switching
    configure_dnd_f16
    disable_minimize_shortcut
    disable_hide_others_shortcut
    disable_hide_obsidian_shortcut
    echo ""

    # Apply changes
    restart_dock_if_needed
    logout_if_needed
}
