# Completion system

# Add to fpath BEFORE compinit
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)

# Initialize completion system (rebuild cache once per day)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
autoload -Uz bashcompinit && bashcompinit

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh)

# jj (jujutsu)
command -v jj &>/dev/null && source <(COMPLETE=zsh jj)

# kubebuilder (if exists)
[[ -f $HOME/.config/kubebuilder/completion.zsh ]] && source $HOME/.config/kubebuilder/completion.zsh

# AWS completions
if command -v aws_completer &>/dev/null; then
  complete -C "$(which aws_completer)" aws
  complete -C "$(which aws_completer)" aws2
  complete -C "$(which aws_completer)" aws-sso
fi
