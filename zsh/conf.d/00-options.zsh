# Shell options and keybindings

# Keybindings
bindkey "^[[3~" delete-char

# Shell options
setopt IGNORE_EOF  # Don't exit on Ctrl-D

# Completion styling (before compinit)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Environment detection
export MACHINE_TYPE="${MACHINE_TYPE:-$(cat ~/.machine_type 2>/dev/null || echo 'personal')}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    export OS_TYPE="macos"
elif [[ -f /etc/arch-release ]]; then
    export OS_TYPE="arch"
else
    export OS_TYPE="linux"
fi

# Helper functions for conditional configs
is_work() { [[ "$MACHINE_TYPE" == "work" ]]; }
is_personal() { [[ "$MACHINE_TYPE" == "personal" ]]; }
is_macos() { [[ "$OS_TYPE" == "macos" ]]; }
is_linux() { [[ "$OS_TYPE" == "linux" ]] || [[ "$OS_TYPE" == "arch" ]]; }
is_arch() { [[ "$OS_TYPE" == "arch" ]]; }
