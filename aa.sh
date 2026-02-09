#!/usr/bin/env bash
set -e

echo "==> Updating zsh config files with OS/machine detection..."

# Create updated 00-options.zsh
cat > zsh/conf.d/00-options.zsh << 'EOF'
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
EOF

# Create updated 20-homebrew.zsh
cat > zsh/conf.d/20-homebrew.zsh << 'EOF'
# Homebrew setup (macOS only)

is_macos || return 0

eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1

# GNU tools - prefer over macOS POSIX versions
addToPathFront $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
addToPathFront $HOMEBREW_PREFIX/opt/grep/libexec/gnubin
EOF

# Create updated 80-ssh.zsh
cat > zsh/conf.d/80-ssh.zsh << 'EOF'
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
EOF

# Create updated 90-aws.zsh
cat > zsh/conf.d/90-aws.zsh << 'EOF'
# AWS configuration (work machines only)

is_work || return 0

# AWS Vault settings
export AWS_VAULT_KEYCHAIN_NAME=login
export AWS_SESSION_TOKEN_TTL=9h
export AWS_CHAINED_SESSION_TOKEN_TTL=9h

# AWS SSO helper functions
__aws_sso_profile_complete() {
  local _args=${AWS_SSO_HELPER_ARGS:- -L error}
  _multi_parts : "($(aws-sso ${=_args} list --csv Profile))"
}

aws-sso-profile() {
  local _args=${AWS_SSO_HELPER_ARGS:- -L error}
  if [[ -n "$AWS_PROFILE" ]]; then
    echo "Unable to assume a role while AWS_PROFILE is set"
    return 1
  fi
  if [[ -z "$1" ]]; then
    echo "Usage: aws-sso-profile <profile>"
    return 1
  fi
  eval $(aws-sso ${=_args} eval -p "$1")
  if [[ "$AWS_SSO_PROFILE" != "$1" ]]; then
    return 1
  fi
}

aws-sso-clear() {
  local _args=${AWS_SSO_HELPER_ARGS:- -L error}
  if [[ -z "$AWS_SSO_PROFILE" ]]; then
    echo "AWS_SSO_PROFILE is not set"
    return 1
  fi
  eval $(aws-sso ${=_args} eval -c)
}

# AWS region wrapper
aws() {
  local profile region
  # Find profile from arguments
  for i in {1..$#}; do
    if [[ "${argv[i]}" == --profile=* ]]; then
      profile="${argv[i]#*=}"
      break
    elif [[ "${argv[i]}" == "--profile" && -n "${argv[i+1]}" ]]; then
      profile="${argv[i+1]}"
      break
    fi
  done
  # Fall back to AWS_SSO_PROFILE env var
  profile=${profile:-$AWS_SSO_PROFILE}
  # No profile, just run command
  if [[ -z "$profile" ]]; then
    command aws "$@"
    return $?
  fi
  # Set region based on profile naming convention
  case "$profile" in
    *prod*) region="us-east-1" ;;
    *uat*)  region="us-west-2" ;;
    *test*) region="ap-southeast-2" ;;
    *)      region="" ;;
  esac
  if [[ -n "$region" ]]; then
    echo "Profile '$profile' detected, using region: $region" >&2
    AWS_REGION="$region" command aws "$@"
  else
    command aws "$@"
  fi
}

# AWS doctor functions
aws-creds-help() {
  bold=\$(tput bold)
  underline=\$(tput smul)
  reset=\$(tput sgr0)
  cat <<INNEREOF
Please generate and configure an AWS access key
===============================================
1. If you haven't already, visit \${underline}https://pacman.xero-support.com/\${reset} to set your AWS password and MFA device (authy is recommended)
2. Visit \${underline}https://console.aws.amazon.com/iam/home#/users/\${USER}@xero.com?section=security_credentials\${reset} and login using:
    Account ID: \${bold}xero-ps-paas-identity\${reset}
    IAM user name: \${bold}\${USER}@xero.com\${reset}
    Password: \${bold}your AWS password configured via Pacman, not your Okta password\${reset}
    MFA Code: \${bold}6 digit code from Authy\${reset}
3. Under \${bold}Access keys\${reset} deactivate and delete any existing access keys.
4. Click \${bold}Create Access Key\${reset}
5. Under \${bold}Access keys\${reset} click \${bold}Create Access Key\${reset}
6. Copy your \${bold}Access key ID\${reset} into the prompt below
7. Copy your \${bold}Secret access key\${reset} into the prompt below (will not be echoed)
To skip, press enter. To configure this later run \${bold}aws-doctor\${reset}.
INNEREOF
}

aws_vault_default_creds_exist() {
  if [[ $(aws-vault exec -j default --no-session 2>/dev/null | jq -r .AccessKeyId) != "" ]]; then
    echo aws-vault default profile has credentials
    return 0
  else
    return 42
  fi
}

aws_vault_default_creds_valid() {
  echo "Checking if credentials are valid ..."
  success="aws-vault default profile credentials are valid"
  aws-vault exec default -- echo "$success" 2>&1 | tee /dev/stderr | { ! grep -q InvalidClientTokenId ;}
  pstatus=(${pipestatus[*]})
  vault_error=${pstatus[1]}
  invalid_client_token_id=${pstatus[3]}
  if [[ ${invalid_client_token_id} -ne 0 ]]; then
    return 43
  elif [[ ${vault_error} -ne 0 ]]; then
    return 1
  else
    return 0
  fi
}

aws-doctor() {
  if [[ -n "${AWS_SHARED_CREDENTIALS_FILE:-}" ]]; then
    echo "Warning: You have set AWS_SHARED_CREDENTIALS_FILE. Please unset it."
  fi
  if [[ -f $HOME/.aws/credentials ]]; then
    echo -e "Warning: You have plaintext credentials in ~/.aws/credentials.\n\nPlease delete them:\n\nrm ~/.aws/credentials"
  fi
  if ! aws_vault_default_creds_exist || ! aws_vault_default_creds_valid; then
    if [[ ${pipestatus[*]} -ne 1 ]]; then
      aws-creds-help
      aws-vault add default
    else
      return 1
    fi
  fi
}
EOF

echo "✓ Updated zsh/conf.d/00-options.zsh"
echo "✓ Updated zsh/conf.d/20-homebrew.zsh"
echo "✓ Updated zsh/conf.d/80-ssh.zsh"
echo "✓ Updated zsh/conf.d/90-aws.zsh"
echo ""
echo "All zsh configs updated with OS/machine detection! 🎉"
echo ""
echo "The configs now support:"
echo "  - is_work() / is_personal() - Machine type detection"
echo "  - is_macos() / is_linux() / is_arch() - OS detection"
echo "  - Conditional loading (configs early-return if not applicable)"
echo ""
echo "Next steps:"
echo "  1. Run setup script to set machine type: ./scripts/setup.sh"
echo "  2. Restart shell: exec zsh"
