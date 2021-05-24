#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

usage="$0 [-r] [-a] [-l LENGHT] files..."

recursive=false
all=false
lenght=16

while getopts ":r?a?l:" opt; do
    case $opt in
        r)
            recursive=true
            ;;
        a)
            all=true
            ;;
        l)
            lenght=$OPTARG
            echo $lenght
            if [[ ! $lenght =~ ^[0-9]+$ ]]; then
                echo $usage
                exit 1
            fi
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
        filename="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)$ext"
        
        if [ -d $filepath ]; then
            if $recursive && [ ! -L $filepath ]; then
                rename "$filepath" $(ls -b $filepath)
            fi
            if ! $all; then
                continue
            fi
        fi
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
