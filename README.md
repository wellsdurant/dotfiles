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

## Usage

### Quick Start

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

Check Homebrew configuration:

```bash
make check-brew
```

This will verify that Homebrew is properly installed and configured in your shell profiles.

Check MacPorts configuration:

```bash
make check-port
```

This will verify that MacPorts and Xcode Command Line Tools are properly installed and configured.

Check for outdated software:

```bash
make outdated
```

This will list all software that needs upgrading from Homebrew, MacPorts, and Mac App Store.

### What Gets Configured

#### macOS System Settings

**Dock:**
- Auto-hide Dock
- Disable Hot Corners
- Disable automatic space rearrangement

**Keyboard & Text:**
- Disable press-and-hold for accent characters
- Disable automatic period substitution

**Keyboard Shortcuts:**
- Disable Spotlight keyboard shortcut (Cmd+Space)
- Set input source switching to Alt+Space
- Set F16 to toggle Do Not Disturb
- Disable "Minimize" (Cmd+M)
- Disable "Hide Others" (Cmd+Opt+H)
- Disable "Hide Obsidian" (Cmd+H in Obsidian)

#### Applications Installed

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

#### Configuration Files

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

## Manual Setup

You can also run individual scripts:

```bash
# Configure macOS settings only
bash scripts/configure_macos_builtin_settings.sh

# Install Homebrew only
bash scripts/install_homebrew.sh

# Install MacPorts only
bash scripts/install_macports.sh

# Install applications only
bash scripts/install_applications.sh

# Link configuration files only
bash scripts/link_configs.sh

# Check SIP configuration for yabai
bash scripts/check_sip_for_yabai.sh

# Check Homebrew configuration
bash scripts/check_homebrew.sh

# Check MacPorts configuration
bash scripts/check_macports.sh

# Check for outdated software
bash scripts/check_outdated.sh
```

## Requirements

- macOS
- Bash (for running scripts)
- Optional: Mac App Store account (for Kindle and LINE)

Note: Homebrew and MacPorts will be automatically installed by the setup script if not already present.

## Important Notes

**Homebrew Persistence:**
The installation script loads Homebrew in the current session, but you'll need to ensure Homebrew is in your shell's PATH permanently. The script installs Homebrew, but you should verify that your shell configuration (`.zprofile`, `.bash_profile`, or `config.fish`) includes the Homebrew initialization:

For Fish (already configured in `config/fish/config.fish`):
```fish
eval "$(/opt/homebrew/bin/brew shellenv)"
```

For Bash/Zsh (add to your profile if not present):
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Yabai Scripting Additions:**
Yabai requires specific SIP (System Integrity Protection) configuration to enable scripting additions. After running `make config`, you should:

1. Check your SIP configuration:
   ```bash
   make check
   # or directly: bash scripts/check_sip_for_yabai.sh
   ```

2. If SIP is not properly configured, follow the instructions provided by the script to:
   - Boot into Recovery Mode
   - Run `csrutil enable --without debug`
   - Reboot and verify

3. Once SIP is configured, load the scripting addition:
   ```bash
   sudo yabai --load-sa
   yabai --start-service
   ```

For more details, see the [yabai wiki](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection).

## Features

- ✅ **Idempotent**: Safe to run multiple times - checks if settings/apps are already configured
- ✅ **Automatic backups**: Backs up existing configs before overwriting
- ✅ **Modular**: Each script can be run independently
- ✅ **User-friendly**: Prompts for confirmation before logging out
- ✅ **Error handling**: Validates files exist and backups succeed before making changes

## License

Personal use only.
