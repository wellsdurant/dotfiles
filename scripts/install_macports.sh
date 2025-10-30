#!/usr/bin/env bash

# Function to get the latest MacPorts version from GitHub
get_latest_macports_version() {
    echo "  Fetching latest MacPorts version from GitHub..."

    # Fetch latest release info from GitHub API
    local api_url="https://api.github.com/repos/macports/macports-base/releases/latest"
    local version_info
    version_info=$(curl -s "$api_url" 2>/dev/null)

    if [ -z "$version_info" ]; then
        echo "  ⚠️  Failed to fetch from GitHub API, using fallback version 2.10.2"
        echo "2.10.2"
        return
    fi

    # Extract version tag (e.g., "v2.10.2")
    local version_tag
    version_tag=$(echo "$version_info" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$version_tag" ]; then
        echo "  ⚠️  Failed to parse version, using fallback version 2.10.2"
        echo "2.10.2"
        return
    fi

    echo "  Latest MacPorts version: $version_tag"
    echo "$version_tag"
}

# Function to install MacPorts
install_macports() {
    echo "Installing MacPorts..."

    # Check if MacPorts is already installed
    if command -v port &>/dev/null; then
        echo "  MacPorts is already installed: $(which port)"
        local port_version
        port_version=$(port version)
        echo "  $port_version"
        echo ""
        return 0
    fi

    echo "  MacPorts is not installed. Installing..."
    echo ""

    # Get the latest MacPorts version
    local macports_version
    macports_version=$(get_latest_macports_version)

    # Get macOS version
    local macos_version
    macos_version=$(sw_vers -productVersion)
    local macos_major
    macos_major=$(echo "$macos_version" | cut -d. -f1)

    echo "  Detected macOS version: $macos_version"

    # Determine the correct MacPorts package based on macOS version
    local pkg_name=""
    local os_name=""

    case "$macos_major" in
        15)
            os_name="Sequoia"
            pkg_name="MacPorts-${macports_version}-15-Sequoia.pkg"
            ;;
        14)
            os_name="Sonoma"
            pkg_name="MacPorts-${macports_version}-14-Sonoma.pkg"
            ;;
        13)
            os_name="Ventura"
            pkg_name="MacPorts-${macports_version}-13-Ventura.pkg"
            ;;
        12)
            os_name="Monterey"
            pkg_name="MacPorts-${macports_version}-12-Monterey.pkg"
            ;;
        11)
            os_name="BigSur"
            pkg_name="MacPorts-${macports_version}-11-BigSur.pkg"
            ;;
        *)
            echo "  ERROR: Unsupported macOS version: $macos_version"
            echo "  Please install MacPorts manually from: https://www.macports.org/install.php"
            return 1
            ;;
    esac

    echo "  Installing MacPorts $macports_version for macOS $os_name..."
    echo ""

    # Download MacPorts installer
    local download_url="https://github.com/macports/macports-base/releases/download/v${macports_version}/$pkg_name"
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
        local port_version
        port_version=$(/opt/local/bin/port version)
        echo "  $port_version"
        echo ""
    else
        echo "  ERROR: MacPorts installation verification failed"
        echo "  Expected port at: /opt/local/bin/port"
        return 1
    fi

    echo "  MacPorts installation complete!"
    echo ""
}
