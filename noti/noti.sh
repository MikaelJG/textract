#!/bin/bash

# Current directory
current_dir=$(pwd)

# Script location 
script_file=${BASH_SOURCE[0]}

# Script full directory
script_dir=$(dirname "$script_dir")
#
read_path="$script_dir"/read.sh

# empty ARGS is given "--help"

if [ -z "$1" ]; then
    ARGS=("--help")
else
    ARGS=("$@")
fi

case ${ARGS[0]} in
    -help|--help)   
        echo "Provide an argument" ; exit ;;
    *)

        if [ "${#ARGS[@]}" -ge 2 ]; then
            echo "ARGS count is greater or equal to 2"
            $read_path "$2" "$1"
        else
            echo "ARGS count is smaller than 2"
        fi
        # [[ " $2 " -eq 0 ]] && $read_path "$2" "$1" || $read_path "$1";;
esac

