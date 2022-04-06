#!/bin/bash

while getopts ":o:" opt; do
  case $opt in
      o)
        output=$OPTARG
        ;;
      *)
        echo "Unsupported argument was given (only '-o' is allowed)"
        exit 1
        ;;
    esac
done
shift $((OPTIND -1))


if [ -z $output ]; then
    echo "An output must be provided ('-o' flag)"
    exit 1
fi

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$output "${@}"
