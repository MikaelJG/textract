#!/bin/bash

current_dir=$(pwd)

# if there is no value, give help and exit
if [ $# -le 1 ]; then
    echo "To extract verbatim content,"
    echo "Provide a .tex file as first argument."
    echo "Plus, a file extention as second argument." ; exit
fi
# define and test arg 1 - the .tex file

tex_file="$current_dir/$1"

if cat "$tex_file" >/dev/null 2>&1; then
    echo "file found"
else 
    echo "file not found" ; exit
fi

ex_ext="$2"
output_dir="$3"

if cd "$output_dir" >/dev/null 2>&1; then
    echo "Output directory found"
else 
    echo "Output directory not found" ; exit
fi

##################################
#
# Find the right section, given an array of line numbers
# This implementation is based on the two crystal ball algorithm puzzle.
#
# [120,149,220]
# 
# if number is 135, finds section start at 120
#
##################################

find_section() {
    target=$1
    length=${#section_start_a[@]}
    sqrtLength=$(echo "sqrt($length)" | bc)
    jmpAmount=$(echo "($sqrtLength + 0.5) / 1" | bc)

    i=$jmpAmount

    while (( i < length )); do
        if (( section_start_a[i] > target )); then
            break
        fi
        i=$((i + jmpAmount))
    done

    i=$((i - jmpAmount))

    local j
    for (( j = 0; j <= jmpAmount && i < length; j++, i++ )); do
        if (( section_start_a[i] > target )); then
            
            i=$(( i - 1 ))

            section=${section_start_a[i]}
            
            echo "$section"
            return
        fi
    done

    echo "-1"
    
}

##################################
#
# Create verbatim.csv
# Format: Verbatim number, Start, End, Number of lines for Verbatim
#
##################################


# This pattern should be relative
awk '/begin{verbat/ { print NR }' "$tex_file" >> begin.txt

# This pattern should be relative
awk '/end{verbat/ { print NR }' "$tex_file" >> end.txt

paste -d ',' begin.txt end.txt > both.csv 
awk -F ',' '{result = $2 - $1; print $0 "," result}' both.csv >> no_num_verbatim.csv
nl -w1 -s, no_num_verbatim.csv > verbatim.csv

rm begin.txt end.txt both.csv no_num_verbatim.csv

##################################
#
# Create section.csv
# Format: Section number, Start, Name of Section 
#
##################################
awk '/section/ { print NR "," $0 }' "$tex_file" >> no_num_section.csv
nl -w1 -s, no_num_section.csv > section.csv

rm no_num_section.csv

##################################
#
# Create array of Section Start
#
##################################

section_start_a=()

while IFS= read -r line; do
    IFS=',' read -r sec_num start_point sec_name <<< "$line"
    section_start_a+=("$start_point")
done < section.csv

rm section.csv

# Append large number, allows last verbatim not to overheap.
# Otherwise, last verbatim fails the algo.
section_start_a+=("100000")

##################################
#
# For each verbatim find section
#
##################################

while IFS= read -r line; do
    IFS=',' read -r ver_num start_point end_point ver_num_lines <<< "$line"
    section=$(find_section "$start_point")

    sed -n "${section}p" "$tex_file"

done < verbatim.csv >> section.csv

paste -d ',' verbatim.csv section.csv > best_verbatim.csv 

rm verbatim.csv ; mv best_verbatim.csv verbatim.csv

sed -i 's/\\section{//' verbatim.csv
sed -i 's/\\subsection{//' verbatim.csv
sed -i 's/}//' verbatim.csv

sed -i 's/\\section{//' section.csv
sed -i 's/\\subsection{//' section.csv
sed -i 's/}//' section.csv

##################################
#
# prompt user
# "Place the output in $output_dir: ? [y,n] 
#
##################################
read -p "Place the output in $output_dir? [y/yes,n/no]: " answer

lower_answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check if the answer is "yes"
if [[ "$lower_answer" == "y" || "$lower_answer" == "yes" ]]; then
    echo "Extracting..."
else
    echo "Extraction aborted." ; exit
fi

#################################
#
# Insert the verbatim in a new file, named with the section' name
#
#################################

while IFS= read -r line; do
    IFS=',' read -r ver_num start_point end_point ver_num_lines sec_name <<< "$line"

    lowercase_sec_name="${sec_name,,}"
    no_space_sec_name="${lowercase_sec_name// /_}"
    final_sec_name="${no_space_sec_name//[\(\)]/}"

    sec_length=${#final_sec_name}

    # bash string format
    # ${string:start:length}

    if (( sec_length <= 5 )); then
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        
        # write to the model file
        touch "$output_dir"/"$substring1"."$ex_ext"
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1"."$ex_ext"

        # clean the model file
        sed -i 's/\\end{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"
        sed -i 's/\\begin{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"

        # cp the model file
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring2"."$ex_ext"
    elif (( sec_length <= 10 )); then
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        substring3=${final_sec_name:0:10}

        # write to the model file
        touch "$output_dir"/"$substring1"."$ex_ext"
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1"."$ex_ext"

        # clean the model file
        sed -i 's/\\end{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"
        sed -i 's/\\begin{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"

        # cp the model file
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring2"."$ex_ext"
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring3"."$ex_ext"

    elif (( sec_length <= 15 )); then
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        substring3=${final_sec_name:0:10}

        # write to the model file
        touch "$output_dir"/"$substring1"."$ex_ext"
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1"."$ex_ext"

        # clean the model file
        sed -i 's/\\end{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"
        sed -i 's/\\begin{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"

        # cp the model file
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring2"."$ex_ext"
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring3"."$ex_ext"
    else
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        substring3=${final_sec_name:0:10}

        # write to the model file
        touch "$output_dir"/"$substring1"."$ex_ext"
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1"."$ex_ext"

        # clean the model file
        sed -i 's/\\end{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"
        sed -i 's/\\begin{verbatim}//' "$output_dir"/"$substring1"."$ex_ext"

        # cp the model file
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring2"."$ex_ext"
        cp "$output_dir"/"$substring1"."$ex_ext" "$output_dir"/"$substring3"."$ex_ext"
    fi

    # clean up the new doc
done < verbatim.csv

rm section.csv verbatim.csv

echo "Successfully extracted in $output_dir"

