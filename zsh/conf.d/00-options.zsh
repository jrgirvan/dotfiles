# Shell options and keybindings

# Keybindings
bindkey "^[[3~" delete-char
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[OH"  beginning-of-line
bindkey "^[OF"  end-of-line

# Ctrl+Left/Right - word movement
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Shell options
setopt IGNORE_EOF  # Don't exit on Ctrl-D

# Completion styling (before compinit)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
