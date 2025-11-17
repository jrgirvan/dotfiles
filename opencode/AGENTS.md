# Global OpenCode Rules

## Personal Preferences
- Use 2-space indentation for Lua code
- Follow snake_case naming for Lua functions and variables
- Use conventional commit messages
- Never modify history files (`.zsh_history`, etc.)

## Dotfiles Context
- This is a GNU stow-managed dotfiles repository
- Configs are organized by tool in named directories (nvim/, tmux/, etc.)
- Target directory is `~/.config/` (see `.stowrc`)
- Always check existing conventions before making changes

## Code Style
- Lua: 2-space indents, 120 column width (stylua)
- Shell: Standard sh/zsh conventions
- Nix: Follow nixpkgs-unstable style, alphabetical package lists
