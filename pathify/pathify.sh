#!/bin/bash

while getopts "?l?f?" opt; do
  case $opt in
    l)
      link=true
      ;;
    f)
      force=true
      ;;
  esac
done
shift $((OPTIND -1))

if [ $# -ge 1 ]; then
  path="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)/../$1"
  if [ -d $path ]; then
    executablePath="/usr/bin/$1"
    copyDir="/usr/share/$1"

    if [ -f $executablePath ] || [ -d $copyDir ]; then
      if [ ! -z $force ]; then
        rm $executablePath
        if [ -d $copyDir ]; then
            rm -r $copyDir
        fi
          echo "Unpathified $1"
      else
        echo "The script is already installed"
      fi
    elif [ ! -z $link ]; then
      ln -s $path/$1.* $executablePath
      echo "Pathified $1"
    else
      cp -r $path /usr/share
      ln -s /usr/share/$1/$1.* $executablePath
      echo "Pathified $1"
    fi
  else
    echo "This script does not exist"
  fi
else
  echo "No script to pathify were given"
fi
