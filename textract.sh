#!/bin/bash

# Halt the script execution when an error is spotted
set -e

current_dir=$(pwd)
default_output_dir="$(pwd)/output"

# Determine sed syntax to use
if [ "$(uname)" == "Darwin" ]; then
  # Mac OS
  SED() {
    sed -i '' "$1" "$2"
  }
else
  SED() {
    sed -i "$1" "$2"
  }
fi

# if there is no value, give help and exit
if [ $# -lt 2 ]; then
    echo "To extract verbatim content,"
    echo "Provide a .tex file as first argument."
    echo "Plus, a file extention as second argument." ;
    echo "OPTIONAL: An output directory as a third argument (default: $default_output_dir)."; exit 1
fi
# define and test arg 1 - the .tex file

tex_file="$current_dir/$1"

if cat "$tex_file" >/dev/null 2>&1; then
    echo "file found"
else
    echo "file not found" ; exit 1
fi

ex_ext="$2"
# If the second argument is not specified, use the default output dir
output_dir="${3:-$default_output_dir}"

if cd "$output_dir" >/dev/null 2>&1; then
    echo "Output directory found"
    cd - > /dev/null
else
    echo "Output directory ($output_dir) not found. I will attempt to create it."
    mkdir -p $output_dir
    if [ $? -ne 0 ]; then
      echo "Error: I was unable to create the directory."
      exit 1  # Exit the script with a non-zero exit code
    fi
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
# Create keywords.csv
# Format: Line number, keywords
#
##################################

# Disclosure: I got this front ChatGPT.
# https://chat.openai.com/share/ab176cb0-4878-4c03-8f3d-1f0f11f58fe6
awk -F '[:,]' '/%keywords/ {
    line = $0;
    gsub(/%keywords: /, "", line);
    gsub(/ /, ",", line);
    gsub(/%keywords:/, "", line);
    printf "%d:%s\n", NR, line
}' example.tex > keywords.csv

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

SED 's/\\section{//' verbatim.csv
SED 's/\\subsection{//' verbatim.csv
SED 's/}//' verbatim.csv

SED 's/\\section{//' section.csv
SED 's/\\subsection{//' section.csv
SED 's/}//' section.csv

##################################
#
# For each keyword list find section
#
##################################

while IFS= read -r line; do
  IFS=':' read -r key_num keywords <<< "$line"
  section=$(find_section "$key_num")

  sed -n "${section}p" $tex_file
done < keywords.csv >> kw_section.csv
paste -d ':' keywords.csv kw_section.csv > best_keywords.csv
rm keywords.csv kw_section.csv
mv best_keywords.csv keywords.csv

SED 's/\\section{//' keywords.csv
SED 's/\\subsection{//' keywords.csv
SED 's/}//' keywords.csv

##################################
#
# prompt user
# "Place the output in $output_dir: ? [y,n]
#
##################################
if [ "${AUTO}" = "true" ]; then
  echo "Launching in AUTO mode, skipping prompts."
else
  read -p "Place the output in $output_dir? [y/yes,n/no]: " answer

  lower_answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

  # Check if the answer is "yes"
  if [[ "$lower_answer" == "y" || "$lower_answer" == "yes" ]]; then
      echo "Extracting..."
  else
      echo "Extraction aborted." ; exit 1
  fi
fi

#################################
#
# Insert the verbatim in a new file, named with the section's name
#
#################################

while IFS= read -r line; do
    IFS=',' read -r ver_num start_point end_point ver_num_lines sec_name <<< "$line"

    lowercase_sec_name=$(echo "$sec_name" | tr '[:upper:]' '[:lower:]')
    no_space_sec_name="${lowercase_sec_name// /_}"
    final_sec_name="${no_space_sec_name//[\(\)]/}"

    sec_length=${#final_sec_name}

    # bash string format
    # ${string:start:length}

    if (( sec_length <= 5 )); then
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}

        # write to the model file
        touch "$output_dir"/"$substring1".$ex_ext
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1".$ex_ext

        # clean the model file
        SED 's/\\end{verbatim}//' "$output_dir"/"$substring1".$ex_ext
        SED 's/\\begin{verbatim}//' "$output_dir"/"$substring1".$ex_ext

        # copy the model file as a link
        if [ "$substring1" != "$substring2" ]; then
          rm -f $output_dir/$substring2.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring2".$ex_ext
        fi

    elif (( sec_length <= 10 )); then
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        substring3=${final_sec_name:0:10}

        # write to the model file
        touch "$output_dir"/"$substring1".$ex_ext
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1".$ex_ext

        # clean the model file
        SED 's/\\end{verbatim}//' "$output_dir"/"$substring1".$ex_ext
        SED 's/\\begin{verbatim}//' "$output_dir"/"$substring1".$ex_ext

        # copy the model file as a link
        if [ "$substring1" != "$substring2" ]; then
          rm -f $output_dir/$substring2.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring2".$ex_ext
        fi
        if [ "$substring1" != "$substring3" ]; then
          rm -f $output_dir/$substring3.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring3".$ex_ext
        fi

    elif (( sec_length <= 15 )); then
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        substring3=${final_sec_name:0:10}

        # write to the model file
        touch "$output_dir"/"$substring1".$ex_ext
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1".$ex_ext

        # clean the model file
        SED 's/\\end{verbatim}//' "$output_dir"/"$substring1".$ex_ext
        SED 's/\\begin{verbatim}//' "$output_dir"/"$substring1".$ex_ext

        # copy the model file as a link
        if [ "$substring1" != "$substring2" ]; then
          rm -f $output_dir/$substring2.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring2".$ex_ext
        fi
        if [ "$substring1" != "$substring3" ]; then
          rm -f $output_dir/$substring3.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring3".$ex_ext
        fi
    else
        substring1=${final_sec_name}
        substring2=${final_sec_name:0:5}
        substring3=${final_sec_name:0:10}

        # write to the model file
        touch "$output_dir"/"$substring1".$ex_ext
        sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$substring1".$ex_ext

        # clean the model file
        SED 's/\\end{verbatim}//' "$output_dir"/"$substring1".$ex_ext
        SED 's/\\begin{verbatim}//' "$output_dir"/"$substring1".$ex_ext

        # copy the model file as a link
        if [ "$substring1" != "$substring2" ]; then
          rm -f $output_dir/$substring2.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring2".$ex_ext
        fi
        if [ "$substring1" != "$substring3" ]; then
          rm -f $output_dir/$substring3.$ex_ext
          ln -s "$output_dir"/"$substring1".$ex_ext "$output_dir"/"$substring3".$ex_ext
        fi
    fi

    # clean up the new doc
done < verbatim.csv

#################################
#
# Create links for keywords to the matching verbatim file
#
#################################

while IFS= read -r line; do
    IFS=':' read -r key_num keywords sec_name <<< "$line"

    lowercase_sec_name=$(echo "$sec_name" | tr '[:upper:]' '[:lower:]')
    no_space_sec_name="${lowercase_sec_name// /_}"
    final_sec_name="${no_space_sec_name//[\(\)]/}"

    OLD_IFS=$IFS
    IFS=','
    read -ra elements <<< "$keywords"
    IFS=$OLD_IFS

    for keyword in "${elements[@]}"; do
      lowercase_key_name=$(echo "$keyword" | tr '[:upper:]' '[:lower:]')
      no_space_key_name="${lowercase_key_name// /_}"
      final_key_name="${no_space_key_name//[\(\)]/}"

      rm -f $output_dir/$final_key_name.$ex_ext
      ln -s $output_dir/$final_sec_name.$ex_ext $output_dir/$final_key_name.$ex_ext
    done
done < keywords.csv

rm section.csv verbatim.csv keywords.csv


echo "Successfully extracted in $output_dir"

