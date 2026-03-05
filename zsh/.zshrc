# ZSH Configuration
# Load all configs from conf.d in order

for conf in "$HOME/.config/zsh/conf.d/"*.zsh(N); do
  source "$conf"
done
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/john.girvan/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
