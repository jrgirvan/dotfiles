# SSH agent setup
#
# macOS uses the system SSH agent with Keychain integration.
# Keys are configured in ~/.ssh/config with:
#   AddKeysToAgent yes
#   UseKeychain yes
#
# To add keys to Keychain once:
#   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
#   ssh-add --apple-use-keychain ~/.ssh/id_ed25519_john-girvan_xero
