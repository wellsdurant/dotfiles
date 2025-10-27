#!/usr/bin/env bash

# Function to check outdated Homebrew packages
check_brew_outdated() {
    echo "Checking Homebrew outdated packages..."
    echo ""

    if ! command -v brew &>/dev/null; then
        echo "  ⚠️  Homebrew is not installed"
        echo ""
        return 1
    fi

    echo "  Formulae (CLI tools):"
    local outdated_formulae=$(brew outdated --formula 2>/dev/null)
    if [ -z "$outdated_formulae" ]; then
        echo "    ✅ All formulae are up to date"
    else
        echo "$outdated_formulae" | sed 's/^/    /'
    fi
    echo ""

    echo "  Casks (GUI applications):"
    local outdated_casks=$(brew outdated --cask 2>/dev/null)
    if [ -z "$outdated_casks" ]; then
        echo "    ✅ All casks are up to date"
    else
        echo "$outdated_casks" | sed 's/^/    /'
    fi
    echo ""
}

# Function to check outdated MacPorts packages
check_port_outdated() {
    echo "Checking MacPorts outdated packages..."
    echo ""

    if [ ! -x /opt/local/bin/port ]; then
        echo "  ⚠️  MacPorts is not installed"
        echo ""
        return 1
    fi

    local outdated_ports=$(/opt/local/bin/port outdated 2>/dev/null)
    if echo "$outdated_ports" | grep -q "No installed ports are outdated"; then
        echo "  ✅ All MacPorts packages are up to date"
    else
        echo "$outdated_ports" | sed 's/^/  /'
    fi
    echo ""
}

# Function to check outdated Mac App Store applications
check_mas_outdated() {
    echo "Checking Mac App Store outdated applications..."
    echo ""

    if ! command -v mas &>/dev/null; then
        echo "  ⚠️  mas is not installed"
        echo "     Install it with: brew install mas"
        echo ""
        return 1
    fi

    local outdated_apps=$(mas outdated 2>/dev/null)
    if [ -z "$outdated_apps" ]; then
        echo "  ✅ All Mac App Store applications are up to date"
    else
        echo "$outdated_apps" | sed 's/^/  /'
    fi
    echo ""
}

# Main function
main() {
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║           Outdated Software Check                              ║"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo ""

    # Check Homebrew
    check_brew_outdated

    # Check MacPorts
    check_port_outdated

    # Check Mac App Store
    check_mas_outdated

    # Summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "UPGRADE COMMANDS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To upgrade all outdated packages:"
    echo ""
    echo "  Homebrew:"
    echo "    brew upgrade                    # Upgrade all formulae and casks"
    echo "    brew upgrade --formula          # Upgrade only formulae"
    echo "    brew upgrade --cask             # Upgrade only casks"
    echo ""
    echo "  MacPorts:"
    echo "    sudo port upgrade outdated      # Upgrade all outdated ports"
    echo ""
    echo "  Mac App Store:"
    echo "    mas upgrade                     # Upgrade all outdated apps"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Execute main function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
