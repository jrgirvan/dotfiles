# Aliases

# Editor
alias vim='$(mise where neovim@0.11.7)/bin/nvim'
alias v='$(mise where neovim@0.11.7)/bin/nvim'

# Neovim 0.12 until i know is stable and i can switch to it as default
alias v12='NVIM_APPNAME=nvim-v12 $(mise where neovim@0.12.0)/bin/nvim'

# Core utils
alias ls='ls --color=auto'

# Kubernetes
alias kubectx='kubectl-ctx'
alias kubens='kubectl-ns'
alias kubelogin='kubectl-oidc_login'
alias krew='kubectl-krew'
