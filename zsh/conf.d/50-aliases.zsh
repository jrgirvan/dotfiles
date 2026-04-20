# Aliases

# Editor
alias vim='$(mise where neovim@0.11.7)/bin/nvim'
alias v='NVIM_APPNAME=nvim-v12 $(mise where neovim@0.12.2)/bin/nvim'

# Neovim 0.12 until i know is stable and i can switch to it as default
alias v11='$(mise where neovim@0.11.7)/bin/nvim'

# Core utils
alias cat='bat --no-pager'
alias ls='eza --group-directories-first'

# Kubernetes
alias kubectx='kubectl-ctx'
alias kubens='kubectl-ns'
alias kubelogin='kubectl-oidc_login'
alias krew='kubectl-krew'
