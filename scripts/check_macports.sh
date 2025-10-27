#!/usr/bin/env bash

# Function to check if Xcode Command Line Tools are installed
check_xcode_tools() {
    echo "Checking Xcode Command Line Tools..."
    echo ""

    if xcode-select -p &>/dev/null; then
        echo "  ✅ Xcode Command Line Tools are installed"
        local xcode_path=$(xcode-select -p)
        echo "     Path: $xcode_path"
        echo ""
        return 0
    else
        echo "  ❌ Xcode Command Line Tools are NOT installed"
        echo ""
        echo "  MacPorts requires Xcode Command Line Tools to compile software."
        echo ""
        echo "  To install, run:"
        echo "    xcode-select --install"
        echo ""
        return 1
    fi
}

# Function to check if MacPorts is installed
check_macports_installation() {
    echo "Checking MacPorts installation..."
    echo ""

    if [ -x /opt/local/bin/port ]; then
        echo "  ✅ MacPorts is installed: /opt/local/bin/port"
        local port_version=$(/opt/local/bin/port version)
        echo "     $port_version"
        echo ""
        return 0
    else
        echo "  ❌ MacPorts is not installed"
        echo ""
        echo "  To install MacPorts, run:"
        echo "    make config"
        echo ""
        echo "  Or install manually from:"
        echo "    https://www.macports.org/install.php"
        echo ""
        return 1
    fi
}

# Function to check MacPorts PATH configuration
check_macports_path() {
    echo "Checking MacPorts PATH configuration..."
    echo ""

    if echo "$PATH" | grep -q "/opt/local/bin"; then
        echo "  ✅ /opt/local/bin is in PATH"
    else
        echo "  ⚠️  /opt/local/bin is NOT in PATH"
        echo "     MacPorts binaries may not be accessible"
    fi

    if echo "$PATH" | grep -q "/opt/local/sbin"; then
        echo "  ✅ /opt/local/sbin is in PATH"
    else
        echo "  ⚠️  /opt/local/sbin is NOT in PATH"
        echo "     Some MacPorts system binaries may not be accessible"
    fi

    echo ""

    if ! echo "$PATH" | grep -q "/opt/local"; then
        echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  HOW TO ADD MACPORTS TO YOUR PATH"
        echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  For Bash (add to ~/.bash_profile):"
        echo "    export PATH=\"/opt/local/bin:/opt/local/sbin:\$PATH\""
        echo ""
        echo "  For Zsh (add to ~/.zprofile):"
        echo "    export PATH=\"/opt/local/bin:/opt/local/sbin:\$PATH\""
        echo ""
        echo "  For Fish (add to ~/.config/fish/config.fish):"
        echo "    set -gx PATH /opt/local/bin /opt/local/sbin \$PATH"
        echo ""
        echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        return 1
    fi

    return 0
}

# Function to check MacPorts environment variables
check_macports_environment() {
    echo "Checking MacPorts environment..."
    echo ""

    # Check MANPATH (optional but recommended)
    if echo "$MANPATH" | grep -q "/opt/local/share/man" || [ -z "$MANPATH" ]; then
        echo "  ✅ MANPATH is configured for MacPorts (or using default)"
    else
        echo "  ⚠️  MANPATH may not include MacPorts man pages"
        echo "     Add to your shell profile:"
        echo "       export MANPATH=\"/opt/local/share/man:\$MANPATH\""
    fi

    echo ""
}

# Function to check for conflicts with Homebrew
check_brew_conflicts() {
    echo "Checking for potential conflicts with Homebrew..."
    echo ""

    if command -v brew &>/dev/null; then
        echo "  ⚠️  Homebrew is also installed"
        echo ""

        # Check PATH order
        local port_pos=$(echo "$PATH" | tr ':' '\n' | grep -n "/opt/local/bin" | head -1 | cut -d: -f1)
        local brew_pos=$(echo "$PATH" | tr ':' '\n' | grep -n -E "/(opt/homebrew|usr/local)/bin" | head -1 | cut -d: -f1)

        if [ -n "$port_pos" ] && [ -n "$brew_pos" ]; then
            if [ "$port_pos" -lt "$brew_pos" ]; then
                echo "  ✅ MacPorts comes before Homebrew in PATH (MacPorts has priority)"
            else
                echo "  ⚠️  Homebrew comes before MacPorts in PATH (Homebrew has priority)"
                echo "     This may cause conflicts. Consider reordering your PATH."
            fi
        fi
        echo ""
        echo "  Note: Having both MacPorts and Homebrew can cause conflicts."
        echo "  It's generally recommended to use one package manager."
        echo ""
    else
        echo "  ✅ No Homebrew installation detected (no conflicts)"
        echo ""
    fi
}

# Function to test MacPorts functionality
test_macports_functionality() {
    echo "Testing MacPorts functionality..."
    echo ""

    if [ ! -x /opt/local/bin/port ]; then
        echo "  ⚠️  MacPorts is not installed, skipping functionality test"
        echo ""
        return 1
    fi

    # Test port search
    echo "  Running 'port version'..."
    if /opt/local/bin/port version &>/dev/null; then
        echo "  ✅ Basic port commands are working"
    else
        echo "  ❌ Port commands are failing"
        echo "     Try running: sudo port selfupdate"
    fi

    echo ""

    # Check port tree
    echo "  Checking port tree..."
    if [ -d /opt/local/var/macports/sources/rsync.macports.org/macports/release/tarballs/ports ]; then
        echo "  ✅ Port tree exists"
    else
        echo "  ⚠️  Port tree may be missing or corrupted"
        echo "     Run: sudo port selfupdate"
    fi

    echo ""
}

# Function to check for sudo access
check_sudo_access() {
    echo "Checking sudo access..."
    echo ""

    if sudo -n true 2>/dev/null; then
        echo "  ✅ Sudo access is available (cached)"
    else
        echo "  ℹ️  Sudo access will be required for MacPorts operations"
        echo "     Most MacPorts commands need sudo to install packages"
    fi

    echo ""
}

# Main function
main() {
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║           MacPorts Configuration Check                         ║"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo ""

    # Check Xcode Command Line Tools (required)
    local xcode_ok=0
    check_xcode_tools
    xcode_ok=$?

    # If Xcode tools not installed, stop here as it's a prerequisite
    if [ $xcode_ok -ne 0 ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "SUMMARY"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "❌ Xcode Command Line Tools must be installed before using MacPorts"
        echo ""
        echo "Install with: xcode-select --install"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        return 1
    fi

    # Check MacPorts installation
    local macports_ok=0
    check_macports_installation
    macports_ok=$?

    if [ $macports_ok -ne 0 ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "SUMMARY"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "❌ MacPorts is not installed"
        echo ""
        echo "Install with: make config"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        return 1
    fi

    # Check PATH
    local path_ok=0
    check_macports_path
    path_ok=$?

    # Check environment
    check_macports_environment

    # Check for conflicts
    check_brew_conflicts

    # Check sudo
    check_sudo_access

    # Test functionality
    if [ $macports_ok -eq 0 ]; then
        test_macports_functionality
    fi

    # Summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "SUMMARY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ $xcode_ok -eq 0 ] && [ $macports_ok -eq 0 ] && [ $path_ok -eq 0 ]; then
        echo "✅ MacPorts is properly configured!"
        echo ""
        echo "Everything looks good. You can start using MacPorts."
        echo ""
        echo "Common commands:"
        echo "  sudo port install <package>    # Install a package"
        echo "  sudo port selfupdate           # Update MacPorts"
        echo "  sudo port upgrade outdated     # Upgrade all packages"
    else
        echo "⚠️  MacPorts has some configuration issues."
        echo ""
        echo "Issues found:"
        [ $xcode_ok -ne 0 ] && echo "  - Xcode Command Line Tools not installed"
        [ $macports_ok -ne 0 ] && echo "  - MacPorts not installed"
        [ $path_ok -ne 0 ] && echo "  - PATH configuration"
        echo ""
        echo "Follow the instructions above to fix these issues."
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Execute main function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
