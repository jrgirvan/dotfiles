# BEGIN_AWS_REGION_WRAPPER
# Smart AWS wrapper function for Zsh
aws() {
  local profile region

  # Iterate through arguments to find the profile
  # This handles both "--profile my-profile" and "--profile=my-profile"
  for i in {1..$#}; do
    if [[ "${argv[i]}" == --profile=* ]]; then
      profile="${argv[i]#*=}"
      break
    elif [[ "${argv[i]}" == "--profile" && -n "${argv[i+1]}" ]]; then
      profile="${argv[i+1]}"
      break
    fi
  done

  # If profile was not found in args, fall back to the AWS_PROFILE env var
  profile=${profile:-$AWS_SSO_PROFILE}

  # If no profile could be determined, just run the command and exit
  if [[ -z "$profile" ]]; then
    command aws "$@"
    return $?
  fi

  # Set region based on your environment naming convention
  case "$profile" in
    *prod*) region="us-east-1"      ;; # <-- Change to your PROD region
    *uat*)  region="us-west-2"      ;; # <-- Change to your UAT region
    *test*) region="ap-southeast-2" ;; # <-- Change to your TEST region
    *)      region=""               ;; # No match, do nothing
  esac

  # If a region rule matched, run the command with the region set
  if [[ -n "$region" ]]; then
    # Inform the user on stderr (won't interfere with command output)
    echo "Profile '$profile' detected, using region: $region" >&2
    # Set the environment variable for this command only, then execute
    AWS_REGION="$region" command aws "$@"
  else
    # No region rule matched, so run the command as normal
    command aws "$@"
  fi
}
# END_AWS_REGION_WRAPPER

