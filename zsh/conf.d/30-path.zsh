# PATH modifications

addToPathFront $HOME/.local/bin
addToPathFront $HOME/.local/scripts
addToPathFront $HOME/go/bin
addToPathFront $HOME/.krew/bin
addToPathFront /usr/local/opt/curl/bin

# Ghostty
[[ -n "$GHOSTTY_BIN_DIR" ]] && addToPath $GHOSTTY_BIN_DIR

# Dotnet
addToPath $HOME/.dotnet
addToPath $HOME/.dotnet/tools

# OpenCode
addToPathFront $HOME/.opencode/bin
