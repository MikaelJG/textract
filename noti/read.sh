script_dir=${BASH_SOURCE[0]}
# dir=$(dirname $script_dir)
# noti_dir=$(dirname $dir)

note_no_ext=$1
language=$2
complete_file="$note_no_ext.$language"

note_path=~/code/noti_me/notes/languages/$language/$complete_file

if cat "$note_path" >/dev/null 2>&1; then
    echo "cat worked"
    # clear ; cat "${NOTES_R["FILE"]}" ; exit
fi

clear ; echo "Couldn't find the file"
