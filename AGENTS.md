# Agent Guidelines

## Build/Deploy Commands
- **Nix Darwin**: `cd nix-darwin && make darwin` (or `darwin-rebuild switch --flake .`)
- **SketchyBar Bridge**: `cd sketchybar/bridge && make`
- **Lua Formatting**: Use `stylua` with 2-space indents, 120 column width

## Code Style
- **Lua**: 2-space indentation, snake_case for functions/variables, no trailing commas
- **Shell**: Use standard sh/zsh conventions, source scripts from `.config/zsh/`
- **Git**: Use conventional commit messages, configure per-user settings in `git/personal` or `git/work`
- **Config Files**: Use dotfile stow structure - configs in named dirs (nvim/, tmux/, etc.)
- **Nix**: Follow nixpkgs-unstable conventions, list packages alphabetically in `flake.nix`

## Structure
- Multiple nvim configs exist (`nvim/`, `nvim-new/`, `nvim-next/`) - ask which to modify
- SketchyBar uses Lua-based config with C bridge helpers
- Configs are managed via GNU stow from dotfiles root
- Use `~/.config/` (XDG_CONFIG_HOME) for all config locations

## Important
- Never modify `.zsh_history` 
- Test nix changes with `darwin-rebuild build` before `switch`
- SketchyBar changes require `brew services restart sketchybar`
