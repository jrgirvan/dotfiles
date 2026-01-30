# Completion system

# Add to fpath BEFORE compinit
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)

# Initialize completion system (once!)
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# fzf
source <(fzf --zsh)

# jj (jujutsu)
source <(COMPLETE=zsh jj)

# kubebuilder (if exists)
[[ -f $HOME/.config/kubebuilder/completion.zsh ]] && source $HOME/.config/kubebuilder/completion.zsh

# AWS completions
if command -v aws_completer &>/dev/null; then
  complete -C "$(which aws_completer)" aws
  complete -C "$(which aws_completer)" aws2
  complete -C "$(which aws_completer)" aws-sso
fi
