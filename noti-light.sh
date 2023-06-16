#!/bin/bash

# Current directory
script_file=${BASH_SOURCE[0]}

# Script full directory
script_dir=$(dirname "$script_file")

note_path=$1

# empty ARGS is given "--help"
if [ -z "$1" ]; then
    ARGS=("--help")
else
    ARGS=("$@")
fi

case ${ARGS[0]} in
    -help|--help)   
        echo "Provide the path to the note."
        echo "./noti-light.sh ~/code/notes/note.rb  "; exit ;;
    *)

        if [ "${#ARGS[@]}" -ge 2 ]; then
            echo "Provide the path to the note."
            echo "./noti-light.sh ~/code/notes/note.rb  "; exit
        else
            if cat "$note_path" >/dev/null 2>&1; then
                cat "$note_path" ; exit
            fi
        fi
esac

echo "Couldn't find the file"
