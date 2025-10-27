function vman --description 'Open man pages in Neovim'
    if test (count $argv) -eq 0
        echo "Usage: vman <command>"
        echo "Example: vman ls"
        return 1
    end

    # Check if the man page exists
    if not man -w $argv >/dev/null 2>&1
        echo "No manual entry for $argv"
        return 1
    end

    # Open man page in Neovim with proper formatting
    # Use MANPAGER to format with col, then open in Neovim
    nvim -c "Man $argv" -c "only"
end

# Copy man's completions to vman
complete -c vman --wraps man
