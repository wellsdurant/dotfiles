# Dotfiles

Personal macOS configuration and dotfiles.

## Structure

```
.
├── config/              # Application configuration files
│   ├── alacritty/       # Alacritty terminal emulator
│   ├── espanso/         # Text expander
│   ├── fish/            # Fish shell
│   ├── karabiner/       # Keyboard customization
│   ├── kitty/           # Kitty terminal emulator
│   ├── nvim/            # Neovim editor
│   ├── sesh/            # Session manager
│   ├── sketchybar/      # macOS menu bar
│   ├── skhd/            # Hotkey daemon
│   ├── tmux/            # Terminal multiplexer
│   └── yabai/           # Window manager
├── home/                # Shell configuration files (linked to ~/)
│   ├── bash_profile     # Bash shell configuration
│   └── zprofile         # Zsh shell configuration
├── scripts/             # Setup and configuration scripts
│   ├── config_macos.sh                     # Main orchestrator script
│   ├── configure_macos_builtin_settings.sh # macOS system settings
│   ├── install_homebrew.sh                 # Homebrew installation
│   ├── install_macports.sh                 # MacPorts installation
│   ├── install_applications.sh             # Application installation
│   ├── link_configs.sh                     # Symlink configuration files
│   ├── check_sip_for_yabai.sh              # Check SIP configuration for yabai
│   ├── check_homebrew.sh                   # Check Homebrew configuration
│   ├── check_macports.sh                   # Check MacPorts configuration
│   └── check_outdated.sh                   # Check for outdated software
└── Makefile             # Convenient make targets

```

## Quick Start

Run the full macOS configuration:

```bash
make config
```

This will:
1. Configure macOS system settings (Dock, keyboard shortcuts, etc.)
2. Install Homebrew (if not already installed)
3. Install MacPorts (if not already installed)
4. Install applications via Homebrew, MacPorts, and Mac App Store
5. Link configuration files to home directory

Check all configurations:

```bash
make check
```

This will verify Homebrew, MacPorts, and SIP configurations.

Check for outdated software:

```bash
make outdated
```

This will list all software that needs upgrading from Homebrew, MacPorts, and Mac App Store.

## What Gets Configured

### macOS System Settings

**Dock:**
- Auto-hide Dock
- Disable Hot Corners
- Disable automatic space rearrangement

**Keyboard & Text:**
- Disable press-and-hold for accent characters
- Disable automatic period substitution

**Keyboard Shortcuts:**
- Disable Spotlight keyboard shortcut (`<Cmd+Space>`)
- Set `<Alt+Space>` to select the previous input source 
- Set `<F16>` to toggle Do Not Disturb
- Disable "Minimize" (`<Cmd+M>`) by remapping to the unlikely key combination `<Cmd+Ctrl+Alt+Shift+F12>`
- Disable "Hide Others" (`<Cmd+Alt+H>`) by remapping to the unlikely key combination `<Cmd+Ctrl+Alt+Shift+F12>`
- Disable "Hide Obsidian" (`<Cmd+H>` in Obsidian) by remapping to the unlikely key combination `<Cmd+Ctrl+Alt+Shift+F12>`

### Applications Installed

**Homebrew Casks (GUI Applications):**
- Fonts: JetBrains Mono Nerd Font, SF Symbols
- Productivity: Karabiner-Elements, Homerow, Espanso, Raycast
- System: BetterDisplay, Macs Fan Control
- Terminals: kitty
- Browsers: Brave Browser
- Editors: Visual Studio Code
- Note-taking: Obsidian
- Reference: Zotero
- PDF: PDF Expert
- AI: Claude

**Homebrew Formulae (CLI Tools):**
- Window management: yabai, skhd, sketchybar
- Shell: fish
- Package managers: mas
- CLI tools: tldr, zoxide, tmux, sesh, fzf, fd, neovim, uv

**MacPorts Packages:**
- lua51

**Mac App Store Apps:**
- Kindle
- LINE

### Configuration Files

All files in `home/` are linked to `~/` with a dot prefix:
- `home/bash_profile` → `~/.bash_profile`
- `home/zprofile` → `~/.zprofile`

All directories in `config/` are linked to `~/.config/`:
- `config/fish` → `~/.config/fish`
- `config/nvim` → `~/.config/nvim`
- `config/kitty` → `~/.config/kitty`
- And all other config directories...

**Backups:**
Existing configuration files are automatically backed up to `backup_YYYYMMDD_HHMMSS/` before being replaced.


## Requirements

- macOS
- Bash (for running scripts)
- Optional: Mac App Store account (for Kindle and LINE)

Note: Homebrew and MacPorts will be automatically installed by the setup script if not already present.

## License

Personal use only.
