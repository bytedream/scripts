#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

recursive=false

while getopts ":r?" opt; do
    case $opt in
        r)
            recursive=true
            ;;
        *)
            echo $usage
            exit 1
    esac
done
shift $((OPTIND-1))

function rename() {
    local base="$1"
    shift 1

    for file in $*; do
        file=${file//[\\]/}
        filepath="$base/$file"
        ext="${file##*.}"
        if [ "$ext" == "$file" ]; then
            ext=""
        else
            ext=".$ext"
        fi
        
        if [ -d $filepath ]; then
            if $recursive && [ ! -L $filepath ]; then
                rename "$filepath" $(ls -b $filepath)
            fi
            continue
        fi
        filename="$(md5sum $filepath | awk '{print $1}')$ext"
        mv "$filepath" "$base/$filename"
    done
}

if [ "$#" -eq 0 ]; then
    echo "At least one file must be given"
    exit 1
fi

declare -a files=()

for file in $@; do
    if [[ $file != /* ]]; then
        file="$(pwd)/$file"
    fi
    files+=("$file")
done

rename "/" "${files[@]}"

IFS=$SAVEIFS
