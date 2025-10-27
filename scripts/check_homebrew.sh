#!/usr/bin/env bash

# Function to check if Homebrew is installed
check_homebrew_installation() {
    echo "Checking Homebrew installation..."
    echo ""

    if command -v brew &>/dev/null; then
        echo "✅ Homebrew is installed: $(which brew)"
        local brew_version=$(brew --version | head -n 1)
        echo "   $brew_version"
        echo ""
        return 0
    else
        echo "❌ Homebrew is not installed."
        echo ""
        echo "To install Homebrew, run:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo ""
        echo "Or use the dotfiles installer:"
        echo "  make config"
        echo ""
        return 1
    fi
}

# Function to check Homebrew location
check_homebrew_location() {
    echo "Checking Homebrew location..."
    echo ""

    local brew_path=$(which brew 2>/dev/null)

    # Determine architecture
    local arch=$(uname -m)

    if [ "$arch" = "arm64" ]; then
        # Apple Silicon
        if [ "$brew_path" = "/opt/homebrew/bin/brew" ]; then
            echo "✅ Homebrew is in the correct location for Apple Silicon:"
            echo "   /opt/homebrew/bin/brew"
        else
            echo "⚠️  Homebrew location may not be optimal for Apple Silicon:"
            echo "   Current: $brew_path"
            echo "   Expected: /opt/homebrew/bin/brew"
        fi
    else
        # Intel
        if [ "$brew_path" = "/usr/local/bin/brew" ]; then
            echo "✅ Homebrew is in the correct location for Intel Mac:"
            echo "   /usr/local/bin/brew"
        else
            echo "⚠️  Homebrew location may not be optimal for Intel Mac:"
            echo "   Current: $brew_path"
            echo "   Expected: /usr/local/bin/brew"
        fi
    fi
    echo ""
}

# Function to check shell profile configuration
check_shell_profile() {
    local shell_name=$1
    local profile_file=$2
    local check_pattern=$3

    if [ ! -f "$profile_file" ]; then
        echo "⚠️  $shell_name profile not found: $profile_file"
        return 1
    fi

    if grep -q "$check_pattern" "$profile_file" 2>/dev/null; then
        echo "✅ $shell_name profile contains Homebrew initialization"
        echo "   File: $profile_file"
        return 0
    else
        echo "❌ $shell_name profile does NOT contain Homebrew initialization"
        echo "   File: $profile_file"
        return 1
    fi
}

# Function to check shell configurations
check_shell_configurations() {
    echo "Checking shell profile configurations..."
    echo ""

    local current_shell=$(basename "$SHELL")
    echo "Current shell: $current_shell"
    echo ""

    local all_good=true

    # Check Bash profile
    if [ -f "$HOME/.bash_profile" ]; then
        if ! check_shell_profile "Bash" "$HOME/.bash_profile" "brew shellenv"; then
            all_good=false
        fi
        echo ""
    fi

    # Check Zsh profile
    if [ -f "$HOME/.zprofile" ]; then
        if ! check_shell_profile "Zsh" "$HOME/.zprofile" "brew shellenv"; then
            all_good=false
        fi
        echo ""
    fi

    # Check Fish config
    if [ -f "$HOME/.config/fish/config.fish" ]; then
        if ! check_shell_profile "Fish" "$HOME/.config/fish/config.fish" "brew shellenv"; then
            all_good=false
        fi
        echo ""
    fi

    if [ "$all_good" = false ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "HOW TO ADD HOMEBREW TO YOUR SHELL PROFILE"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "For Bash (add to ~/.bash_profile):"
        echo '  eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon'
        echo '  # or'
        echo '  eval "$(/usr/local/bin/brew shellenv)"     # Intel'
        echo ""
        echo "For Zsh (add to ~/.zprofile):"
        echo '  eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon'
        echo '  # or'
        echo '  eval "$(/usr/local/bin/brew shellenv)"     # Intel'
        echo ""
        echo "For Fish (add to ~/.config/fish/config.fish):"
        echo '  eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon'
        echo '  # or'
        echo '  eval "$(/usr/local/bin/brew shellenv)"     # Intel'
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    fi

    return $([ "$all_good" = true ] && echo 0 || echo 1)
}

# Function to check PATH configuration
check_path_configuration() {
    echo "Checking PATH configuration..."
    echo ""

    local brew_bin_in_path=false

    # Check if brew binary directories are in PATH
    if echo "$PATH" | grep -q "/opt/homebrew/bin"; then
        echo "✅ /opt/homebrew/bin is in PATH (Apple Silicon)"
        brew_bin_in_path=true
    elif echo "$PATH" | grep -q "/usr/local/bin"; then
        echo "✅ /usr/local/bin is in PATH (Intel)"
        brew_bin_in_path=true
    else
        echo "❌ Homebrew bin directory is NOT in PATH"
        echo "   Current PATH: $PATH"
        brew_bin_in_path=false
    fi

    echo ""

    if [ "$brew_bin_in_path" = false ]; then
        echo "⚠️  Homebrew may not work correctly without being in PATH."
        echo "   Add Homebrew initialization to your shell profile."
        echo ""
        return 1
    fi

    return 0
}

# Function to check Homebrew environment variables
check_homebrew_environment() {
    echo "Checking Homebrew environment variables..."
    echo ""

    local all_set=true

    # Check HOMEBREW_PREFIX
    if [ -n "$HOMEBREW_PREFIX" ]; then
        echo "✅ HOMEBREW_PREFIX is set: $HOMEBREW_PREFIX"
    else
        echo "⚠️  HOMEBREW_PREFIX is not set"
        all_set=false
    fi

    # Check HOMEBREW_CELLAR
    if [ -n "$HOMEBREW_CELLAR" ]; then
        echo "✅ HOMEBREW_CELLAR is set: $HOMEBREW_CELLAR"
    else
        echo "⚠️  HOMEBREW_CELLAR is not set"
        all_set=false
    fi

    # Check HOMEBREW_REPOSITORY
    if [ -n "$HOMEBREW_REPOSITORY" ]; then
        echo "✅ HOMEBREW_REPOSITORY is set: $HOMEBREW_REPOSITORY"
    else
        echo "⚠️  HOMEBREW_REPOSITORY is not set"
        all_set=false
    fi

    echo ""

    if [ "$all_set" = false ]; then
        echo "⚠️  Some Homebrew environment variables are not set."
        echo "   This usually means 'brew shellenv' hasn't been evaluated."
        echo "   Make sure to run: eval \"\$(brew shellenv)\""
        echo ""
    fi

    return $([ "$all_set" = true ] && echo 0 || echo 1)
}

# Function to test Homebrew functionality
test_homebrew_functionality() {
    echo "Testing Homebrew functionality..."
    echo ""

    # Test brew doctor
    echo "Running 'brew doctor' (this may take a moment)..."
    local doctor_output=$(brew doctor 2>&1)
    local doctor_exit_code=$?

    if [ $doctor_exit_code -eq 0 ]; then
        echo "✅ brew doctor: Your system is ready to brew!"
    else
        echo "⚠️  brew doctor found some issues:"
        echo ""
        echo "$doctor_output" | head -n 20
        if [ $(echo "$doctor_output" | wc -l) -gt 20 ]; then
            echo "..."
            echo "(showing first 20 lines, run 'brew doctor' for full output)"
        fi
    fi

    echo ""
}

# Main function
main() {
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║           Homebrew Configuration Check                        ║"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo ""

    # Check installation
    if ! check_homebrew_installation; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "SUMMARY"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "❌ Homebrew is not installed. Install it to continue."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        return 1
    fi

    # Check location
    check_homebrew_location

    # Check PATH
    local path_ok=0
    check_path_configuration
    path_ok=$?

    # Check environment variables
    local env_ok=0
    check_homebrew_environment
    env_ok=$?

    # Check shell profiles
    local profile_ok=0
    check_shell_configurations
    profile_ok=$?

    # Test functionality
    if command -v brew &>/dev/null; then
        test_homebrew_functionality
    fi

    # Summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "SUMMARY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ $path_ok -eq 0 ] && [ $env_ok -eq 0 ] && [ $profile_ok -eq 0 ]; then
        echo "✅ Homebrew is properly configured!"
        echo ""
        echo "Everything looks good. You can start using Homebrew."
    else
        echo "⚠️  Homebrew has some configuration issues."
        echo ""
        echo "Issues found:"
        [ $path_ok -ne 0 ] && echo "  - PATH configuration"
        [ $env_ok -ne 0 ] && echo "  - Environment variables"
        [ $profile_ok -ne 0 ] && echo "  - Shell profile configuration"
        echo ""
        echo "Follow the instructions above to fix these issues."
        echo ""
        echo "Quick fix: Add this to your shell profile:"
        echo '  eval "$(brew shellenv)"'
        echo ""
        echo "Then restart your shell or run: source ~/.zprofile (or ~/.bash_profile)"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Execute main function if script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
