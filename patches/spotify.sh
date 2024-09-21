#!/usr/bin/env sh

verify_commands() {
  commands=("curl")
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

  sh <(curl -sSL https://spotx-official.github.io/run.sh)
}

main

