# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for a zsh-based development environment using Antidote as the plugin manager. Supports macOS, Linux, and GitHub Codespaces with platform-specific configurations.

## Installation

```bash
./install.sh      # Install dotfiles (creates symlinks)
./install.sh -f   # Force mode (overwrites existing directories)
```

The install script:
- Symlinks configs to home directory (`~/.zshenv`, `~/.gitconfig`, `~/.tmux.conf`, `~/.ssh/`)
- Auto-detects platform (macOS/Linux/Codespaces) and links appropriate platform-specific configs
- Creates empty `.local` files for user overrides (git-ignored)

## Architecture

### Directory Structure
- `zsh/` - Shell configuration (main component)
- `git/` - Git configuration with platform variants
- `ssh/` - SSH configuration with platform variants
- `other/` - Other tool configs (tmux)
- `bin/` - Custom executables

### Zsh Configuration Loading Order
1. `.zshenv` - Sets `ZDOTDIR=$HOME/.dotfiles/zsh`, always loaded
2. `.zprofile` - Login shell: PATH setup, editor vars, mise activation
3. `.zshrc` - Interactive shell: Antidote plugins, aliases, history options

### Plugin System
Plugins are defined in `zsh/.zsh_plugins.txt` and managed by Antidote. Custom plugins live in `zsh/plugins/`:
- `op/` - 1Password CLI
- `pnpm/` - pnpm package manager
- `go/` - Go environment
- `mise/` - Mise version manager

To add a plugin: add it to `.zsh_plugins.txt`, then restart shell (Antidote auto-compiles).

### Platform-Specific Configs
Platform detection happens at install time, creating symlinks:
- `git/gitconfig.platform` → `gitconfig.macos` or `gitconfig.linux` or `gitconfig.codespaces`
- `ssh/config` → `config.macos` or `config.linux`

Local overrides (`*.local` files) are git-ignored and created automatically.

### Key Integrations
- **1Password**: SSH agent and git commit signing on macOS
- **Mise**: Version management for dev tools
- **Delta**: Enhanced git diffs (falls back to less if unavailable)
- **Powerlevel10k**: Prompt theme (configure with `p10k configure`)
