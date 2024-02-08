#!/usr/bin/env sh

verify_commands() {
  commands=("systemd-resolve" "resolvectl")
  for command in "${commands[@]}"; do
    which $command &> /dev/null
    if [ $? -ne 0 ]; then
      echo "command '$command' not found"
      exit 1
    fi
  done
}

main() {
  verify_commands

  # elevate root rights if not present
  if [ "$UID" -ne 0 ]; then
    sudo "$0" "$@"
    exit $?
  else
    systemd-resolve --flush-caches
    resolvectl flush-caches
    systemd-resolve --statistics

    if [ $? -ne 0 ]; then
      echo "Failed to flush cache. Maybe the systemd-resolved service is not started/enabled?"
      exit 1
    fi
  fi
}

main $@
