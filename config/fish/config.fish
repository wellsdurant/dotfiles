# =============================================================================
# General
# =============================================================================

# Disable fish greeting
set -U fish_greeting ""

# =============================================================================
# Package Managers & Path Configuration
# =============================================================================

# MacPorts
set -gx PATH "/opt/local/bin" "/opt/local/sbin" $PATH
set -gx MANPATH "/opt/local/share/man" "$MANPATH"

# Homebrew initialization
eval "$(/opt/homebrew/bin/brew shellenv)"

# Prevent Homebrew from automatically updating before every brew command
# This speeds up brew operations but means you need to manually run 'brew update'
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# =============================================================================
# Terminal Multiplexer
# =============================================================================

# Launch tmux by default
if not test -n "$TMUX"
    sesh connect Home
end

# =============================================================================
# Man Page Configuration
# =============================================================================

# Man page configuration
set -gx MANPAGER "less -R"

# Configure colors for less
set -gx LESS_TERMCAP_md (printf "\e[01;31m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[01;44;33m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[01;32m")


# =============================================================================
# Shell Enhancement Tools
# =============================================================================

# zoxide (smart cd command)
zoxide init fish | source

# Configuring fzf.fish: <Ctrl+O> to open the selected file with $EDITOR while
# searching for directories and files
set fzf_directory_opts --bind "ctrl-o:execute(nvim {} &> /dev/tty)"

# =============================================================================
# Development Environments
# =============================================================================

# Cargo (Rust)
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

# Python: Activate the base venv if exists
if test -d "$HOME/.venv"
    source "$HOME/.venv/bin/activate.fish"
end

# pnpm (Node.js package manager)
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# Cairo
set -gx DYLD_LIBRARY_PATH "/opt/homebrew/lib" $DYLD_LIBRARY_PATH
set -gx PKG_CONFIG_PATH "/opt/homebrew/lib/pkgconfig" $PKG_CONFIG_PATH


