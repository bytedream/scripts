#!/bin/bash

while getopts ":o:output:" opt; do
  case $opt in
      o | output)
        output=$OPTARG
        shift $((OPTIND -1))
        ;;
      *)
        echo "Unsupported argument was given (only '-o' is allowed)"
        exit 1
        ;;
    esac
done


if [ -z $output ]; then
    echo "An output must be provided ('-o' flag)"
    exit 1
fi

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$output "${@}"
