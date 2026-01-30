# AWS configuration

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
  bold=$(tput bold)
  underline=$(tput smul)
  reset=$(tput sgr0)
  cat <<EOF

Please generate and configure an AWS access key
===============================================

1. If you haven't already, visit ${underline}https://pacman.xero-support.com/${reset} to set your AWS password and MFA device (authy is recommended)
2. Visit ${underline}https://console.aws.amazon.com/iam/home#/users/${USER}@xero.com?section=security_credentials${reset} and login using:

    Account ID: ${bold}xero-ps-paas-identity${reset}
    IAM user name: ${bold}${USER}@xero.com${reset}
    Password: ${bold}your AWS password configured via Pacman, not your Okta password${reset}
    MFA Code: ${bold}6 digit code from Authy${reset}

3. Under ${bold}Access keys${reset} deactivate and delete any existing access keys.
4. Click ${bold}Create Access Key${reset}
5. Under ${bold}Access keys${reset} click ${bold}Create Access Key${reset}
6. Copy your ${bold}Access key ID${reset} into the prompt below
7. Copy your ${bold}Secret access key${reset} into the prompt below (will not be echoed)

To skip, press enter. To configure this later run ${bold}aws-doctor${reset}.
EOF
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
