#!/usr/bin/env bash

# Function to install MacPorts
install_macports() {
    echo "Installing MacPorts..."

    # Check if MacPorts is already installed
    if command -v port &>/dev/null; then
        echo "  MacPorts is already installed: $(which port)"
        local port_version=$(port version)
        echo "  $port_version"
        echo ""

        # Update port tree
        echo "  Updating MacPorts port tree..."
        sudo port selfupdate
        echo ""
        return 0
    fi

    echo "  MacPorts is not installed. Installing..."
    echo ""

    # Get macOS version
    local macos_version=$(sw_vers -productVersion)
    local macos_major=$(echo "$macos_version" | cut -d. -f1)

    echo "  Detected macOS version: $macos_version"

    # Determine the correct MacPorts package based on macOS version
    local pkg_name=""
    local os_name=""

    case "$macos_major" in
        15)
            os_name="Sequoia"
            pkg_name="MacPorts-2.10.2-15-Sequoia.pkg"
            ;;
        14)
            os_name="Sonoma"
            pkg_name="MacPorts-2.10.2-14-Sonoma.pkg"
            ;;
        13)
            os_name="Ventura"
            pkg_name="MacPorts-2.10.2-13-Ventura.pkg"
            ;;
        12)
            os_name="Monterey"
            pkg_name="MacPorts-2.10.2-12-Monterey.pkg"
            ;;
        11)
            os_name="BigSur"
            pkg_name="MacPorts-2.10.2-11-BigSur.pkg"
            ;;
        *)
            echo "  ERROR: Unsupported macOS version: $macos_version"
            echo "  Please install MacPorts manually from: https://www.macports.org/install.php"
            return 1
            ;;
    esac

    echo "  Installing MacPorts for macOS $os_name..."
    echo ""

    # Download MacPorts installer
    local download_url="https://github.com/macports/macports-base/releases/download/v2.10.2/$pkg_name"
    local tmp_pkg="/tmp/$pkg_name"

    echo "  Downloading MacPorts installer..."
    if curl -L "$download_url" -o "$tmp_pkg"; then
        echo "  Download complete"
    else
        echo "  ERROR: Failed to download MacPorts installer"
        return 1
    fi
    echo ""

    # Install MacPorts
    echo "  Installing MacPorts (requires sudo)..."
    if sudo installer -pkg "$tmp_pkg" -target /; then
        echo "  MacPorts installation complete"
    else
        echo "  ERROR: Failed to install MacPorts"
        rm -f "$tmp_pkg"
        return 1
    fi
    echo ""

    # Clean up
    rm -f "$tmp_pkg"

    # Verify installation using absolute path
    if [ -x /opt/local/bin/port ]; then
        echo "  ✅ MacPorts successfully installed: /opt/local/bin/port"
        local port_version=$(/opt/local/bin/port version)
        echo "  $port_version"
        echo ""
    else
        echo "  ERROR: MacPorts installation verification failed"
        echo "  Expected port at: /opt/local/bin/port"
        return 1
    fi

    echo "  MacPorts installation complete!"
}
