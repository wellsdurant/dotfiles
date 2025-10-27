# Functions
function __multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

# General
abbr -a dotdot --regex '^\.\.+$' --function __multicd

# Git
abbr -a gs "git status"

# uv
abbr -a pip "uv pip"
