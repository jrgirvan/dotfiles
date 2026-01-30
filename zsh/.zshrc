# ZSH Configuration
# Load all configs from conf.d in order

for conf in "$HOME/.config/zsh/conf.d/"*.zsh(N); do
  source "$conf"
done
