# SSH agent setup

if is_macos; then
    # macOS uses the system SSH agent with Keychain integration.
    # Keys are configured in ~/.ssh/config with:
    #   AddKeysToAgent yes
    #   UseKeychain yes
    #
    # To add keys to Keychain once:
    #   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    #   ssh-add --apple-use-keychain ~/.ssh/id_ed25519_john-girvan_xero
    :
elif is_linux; then
    # Linux SSH agent setup
    # Start ssh-agent if not running
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > "$HOME/.ssh/agent-env"
    fi

    # Source agent environment
    if [[ -f "$HOME/.ssh/agent-env" ]]; then
        source "$HOME/.ssh/agent-env" > /dev/null
    fi

    # Auto-add keys if keychain is available
    if command -v keychain &>/dev/null; then
        eval $(keychain --eval --quiet id_ed25519 id_ed25519_john-girvan_xero 2>/dev/null)
    fi
fi
