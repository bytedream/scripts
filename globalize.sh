#!/bin/bash

check_and_exit() {
  if [ $? -eq 0 ]; then
    echo $1
    exit 0
  else
    echo $2
    exit 1
  fi
}

validate_script() {
  if [ ! -f "$1/$1.sh" ]; then
    echo "'$1' cannot be globalized"
    exit 1
  fi
}

main() {
  while getopts "?h?l?r?" opt; do
    case $opt in
      h)
        echo "Usage: $0 [-l|-r] <script name>"
        echo "  'script name' must be the name of a sub-directory in this directory"
        exit 0
        ;;
      l)
        link=true
        ;;
      r)
        remove=true
        ;;
      *)
        exit 1
        ;;
    esac
  done
  shift $((OPTIND -1))

  if [ $# -ge 1 ]; then
    if [ -d $1 ]; then
      executablePath="/usr/bin/$1"
      copyDir="/usr/share/$1"

      if ([ -f $executablePath ] || [ -d $copyDir ]) || [ ! -z $remove ] ; then
        if [ ! -z $remove ]; then
          if [ -d $copyDir ]; then
              rm -r $copyDir
          fi
          rm $executablePath
          check_and_exit "Unglobalized '$1'" "Failed to unglobalize '$1'"
        else
          echo "The script is already globalized"
        fi
      elif [ ! -z $link ]; then
        validate_script $1
        ln -s $1.* $executablePath
        chmod +x $executablePath
        check_and_exit "Globalized '$1'" "Failed to globalize '$1'"
      else
        validate_script $1
        cp -r $1 /usr/share
        ln -s /usr/share/$1/$1.* $executablePath
        chmod +x $executablePath
        check_and_exit "Globalized '$1'" "Failed to globalize '$1'"
      fi
    else
      echo "This script '$1' does not exist"
    fi
  else
    echo "No script to globalize were given"
  fi
}

main $@
