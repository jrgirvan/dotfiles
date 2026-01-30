# Homebrew setup (must be early for PATH)

eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1

# GNU tools - prefer over macOS POSIX versions
addToPathFront $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/grep/libexec/gnubin
