# Tool initializations

# Starship prompt
eval "$(starship init zsh)"

# Atuin shell history
eval "$(atuin init zsh)"

# Direnv
eval "$(direnv hook zsh)"

# Mise (runtime version manager)
eval "$(mise activate zsh)"

# kubectl completions (after direnv/mise to pick up env changes)
command -v kubectl &>/dev/null && source <(kubectl completion zsh)
