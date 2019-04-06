#!/usr/bin/env bash

# Strict mode-lite for Bash
# For details: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -eo pipefail
IFS=$'\n\t'

readonly DIR="$(dirname "$0")"

# Imports following functions (used to load config file):
#   - parse_yaml()
#   - create_variables()
. "${DIR}/yaml.sh"

# Method that logs to stderr and exits.
err() {
  echo "$@" >&2
  exit 1
}

arg_files=()
arg_exec=()
config_file='.psstrc'

# Not using `getopts` because it doesn't support long option
# names or aliases effectively.
while [ ! -z "${1}" ]; do
  opt=${1}; arg=${2}
  case "${opt}" in
    -f|--file) arg_files+=(${arg}) && shift ;;
    -e|--exec) arg_exec+=(${arg}) && shift ;;
    -c|--config) config_file="${arg}" && shift ;;
    -*) err "Unexpected option ${opt}" ;;
    exec) shift && arg_exec+=($@) && break ;;
    *) arg_exec+=($@) && break ;;
  esac
  shift
done

# Load configuration from config file if present.
if [ -f ${config_file} ]; then
  echo "Reading ${config_file}"

  # The follow variables are created:
  #   - provider_*
  #   - files
  #   - exec
  create_variables ${config_file}
fi

# Overwrite values from config file if args exist.
if [ ! ${#arg_files[@]} -eq 0 ]; then files=${arg_files[*]}; fi
if [ ! ${#arg_exec[@]} -eq 0 ]; then exec=${arg_exec[*]}; fi

# TODO: save current env vars to a file so they can be re-applied.
  # use printenv

# TODO: Load config from provider option if set.

# Source files if provided.
for file in "${files[@]}"; do
  echo "Sourcing ${file}"
  set -a
  . $file
  set +a
done

# TODO: source temp file with original env vars so that they have priority.

# Execute command if provided.
if [ ! ${#exec[@]} -eq 0 ]; then
  echo "Running: ${exec[*]}"
  exec ${exec[*]}
fi
