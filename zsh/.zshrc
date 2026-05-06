# ZSH Configuration
# Load all configs from conf.d in order

for conf in "$HOME/.config/zsh/conf.d/"*.zsh(N); do
  source "$conf"
done
# Docker completions are handled in conf.d/60-completions.zsh (fpath added before compinit).
# Do not let Docker Desktop re-append its compinit block here - it doubles startup time.
