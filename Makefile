.PHONY: all config check check-brew check-port check-sip outdated help

# Default target
all: help

## help: Display this help message
help:
	@echo "Dotfiles Management"
	@echo "===================="
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## /  /'


## config: Configure macOS
config:
	@bash scripts/config_macos.sh


## check: Check all configurations (Homebrew + MacPorts + SIP for yabai)
check: check-brew check-port check-sip


## check-brew: Check Homebrew configuration
check-brew:
	@bash scripts/check_homebrew.sh


## check-port: Check MacPorts configuration
check-port:
	@bash scripts/check_macports.sh


## check-sip: Check SIP configuration for yabai
check-sip:
	@bash scripts/check_sip_for_yabai.sh


## outdated: List software that needs upgrading (Homebrew, MacPorts, Mac App Store)
outdated:
	@bash scripts/check_outdated.sh


