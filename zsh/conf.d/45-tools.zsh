# Tool initializations

# Mise (runtime version manager) - must be first so mise-managed tools are on PATH
eval "$(mise activate zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Atuin shell history
eval "$(atuin init zsh)"

# kubectl completions (lazy-loaded on first use)
if command -v kubectl &>/dev/null; then
  kubectl() {
    unfunction kubectl
    source <(command kubectl completion zsh)
    command kubectl "$@"
  }
fi
