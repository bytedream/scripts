#!/bin/bash

check_commands() {
    failure=false
    for cmd in "dig" "curl"; do
        if ! command -v $cmd &> /dev/null; then
            echo "'$cmd' must be installed"
            failure=true
        fi
    done

    if $failure; then
        exit 1
    fi
}

main() {
    for name in $@; do
        echo "---> $name"
        for tld in "com" "org" "net" "io"; do
            dst_ip=`dig 1.1.1.1 +short $name.$tld | tail -n 1`
            if [ ! $dst_ip ]; then
                echo -e "\t$name.$tld: AVAILABLE"
            else
                echo -e "\t$name.$tld: NOT available"
            fi
        done

        github_availability=`curl -o /dev/null -s -w "%{http_code}" https://github.com/$name`
        if [ "$github_availability" == "200" ]; then
            echo -e "\tGitHub: NOT available"
        else
            echo -e "\tGitHub: AVAILABLE"
        fi
    done
}

check_commands
main $@
