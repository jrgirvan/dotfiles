# Shell options and keybindings

# Keybindings
bindkey "^[[3~" delete-char

# Shell options
setopt IGNORE_EOF  # Don't exit on Ctrl-D

# Completion styling (before compinit)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
