#!/usr/bin/env bash

# Function to check if SIP is properly configured for yabai scripting additions
check_sip_for_yabai() {
    echo "Checking SIP configuration for yabai scripting additions..."
    echo ""

    # Check if csrutil is available
    if ! command -v csrutil &>/dev/null; then
        echo "ERROR: csrutil command not found. Are you running macOS?"
        return 1
    fi

    # Get SIP status
    local sip_status=$(csrutil status)
    echo "Current SIP Status:"
    echo "$sip_status"
    echo ""

    # Check if SIP is completely disabled (not recommended but works)
    if echo "$sip_status" | grep -q "System Integrity Protection status: disabled"; then
        echo "✅ SIP is completely disabled."
        echo "⚠️  WARNING: This is not recommended for security reasons."
        echo "   Consider enabling SIP with only necessary components disabled."
        echo ""
        echo "✅ Yabai scripting additions should work."
        return 0
    fi

    # Check for custom configuration (handles both "enabled" and "unknown" status with Custom Configuration)
    if echo "$sip_status" | grep -q "Custom Configuration"; then
        echo "SIP has custom configuration."
        echo ""

        # Check for the specific flags that need to be disabled for yabai
        # For yabai scripting additions, we need:
        # - Debugging Restrictions: disabled

        local debugging_disabled=false

        if echo "$sip_status" | grep -q "Debugging Restrictions: disabled"; then
            debugging_disabled=true
        fi

        if [ "$debugging_disabled" = true ]; then
            echo "✅ SIP is properly configured for yabai scripting additions."
            echo "   - Debugging Restrictions: disabled ✅"
            echo ""
            echo "✅ Yabai scripting additions should work."
            return 0
        else
            echo "❌ SIP is NOT properly configured for yabai scripting additions."
            echo ""
            echo "Required configuration:"
            echo "   - Debugging Restrictions: disabled ❌"
            echo ""
            show_sip_configuration_instructions
            return 1
        fi
    fi

    # Check if SIP is fully enabled (default configuration)
    if echo "$sip_status" | grep -q "System Integrity Protection status: enabled"; then
        if ! echo "$sip_status" | grep -q "Custom Configuration"; then
            echo "❌ SIP is fully enabled (default configuration)."
            echo "   Yabai scripting additions will NOT work."
            echo ""
            show_sip_configuration_instructions
            return 1
        fi
    fi

    # Unexpected SIP status
    echo "⚠️  Unable to determine SIP configuration."
    echo "   Please check manually with: csrutil status"
    return 1
}

# Function to show instructions for configuring SIP
show_sip_configuration_instructions() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "HOW TO CONFIGURE SIP FOR YABAI SCRIPTING ADDITIONS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "⚠️  WARNING: Modifying SIP affects system security. Proceed carefully."
    echo ""
    echo "Steps to configure SIP:"
    echo ""
    echo "1. Reboot your Mac into Recovery Mode:"
    echo "   - Intel Mac: Restart and hold Cmd+R during boot"
    echo "   - Apple Silicon: Shutdown, then press and hold power button until"
    echo "     'Loading startup options' appears, then select Options"
    echo ""
    echo "2. Open Terminal from the Utilities menu"
    echo ""
    echo "3. Run the following command to disable debugging restrictions:"
    echo "   csrutil enable --without fs --without debug --without nvram"
    echo ""
    echo "4. Reboot your Mac normally"
    echo ""
    echo "5. Run the following command to enable non-Apple-signed arm64e binaries:"
    echo "   nvram boot-args=-arm64e_preview_abi"
    echo ""
    echo "6. Reboot your Mac normally"
    echo ""
    echo "7. Run this script again to verify the configuration"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "For more information, see:"
    echo "https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection"
    echo ""
}

# Function to check if yabai needs SIP configuration
check_yabai_installation() {
    echo "Checking yabai installation..."
    echo ""

    if command -v yabai &>/dev/null; then
        echo "✅ yabai is installed: $(which yabai)"
        local yabai_version=$(yabai --version)
        echo "   Version: $yabai_version"
        echo ""

        # Check if scripting addition is loaded
        echo "Checking if yabai scripting addition is loaded..."
        if yabai -m query --windows &>/dev/null; then
            echo "✅ Yabai is responding to queries (scripting addition likely working)"
        else
            echo "⚠️  Yabai query failed (scripting addition might not be working)"
        fi
        echo ""

        return 0
    else
        echo "ℹ️  yabai is not installed yet."
        echo "   Install it with: brew install yabai"
        echo ""
        return 1
    fi
}

# Main function
main() {
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║        SIP Configuration Check for Yabai                       ║"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo ""

    # Check yabai installation first
    check_yabai_installation
    echo ""

    # Check SIP configuration
    check_sip_for_yabai
    local sip_check_result=$?
    echo ""

    # Summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "SUMMARY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [ $sip_check_result -eq 0 ]; then
        echo "✅ Your system is properly configured for yabai scripting additions!"
        echo ""
        echo "Next steps:"
        echo "1. Load the scripting addition: sudo yabai --load-sa"
        echo "2. Start yabai: yabai --start-service"
        echo "3. Check status: yabai -m query --windows"
    else
        echo "❌ Your system is NOT properly configured for yabai scripting additions."
        echo ""
        echo "Follow the instructions above to configure SIP properly."
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Execute main function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
