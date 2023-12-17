import sys
from pathlib import Path

# Denine a general function to confirm data with the user
# Give as much information as possible to the user
# Facilitate testing
#
#

def ask_user_about(data, context):

    if len(data) == len(context):
        for data_value, data_context in zip(data, context):
            print(data_context, data_value)
    else:
        print("Your data is missing context.")
        print("Please revise.")
        sys.exit(1)

    user_input = input("Would you like to proceed? [Y/n]: ")

    if user_input.lower() in ["yes", "y"]:
        print("Proceeding...")
    elif user_input.lower() in ["no", "n"]:
        print("Exiting...")
        sys.exit(1)
    else:
        print("Invalid input. Please enter 'Y/yes' or 'N/no'.")
        print("Exiting...")
        sys.exit(1)


# Define the paths needed to run this program
# Give paths the easiest of names
# This will help for the entire length of this program
#
#

textra_directory = Path.home() / ".txtra"
current_directory = Path.cwd()
default_output_directory = current_directory / "output"
paths_data = [textra_directory, current_directory, default_output_directory]
paths_context = [
                    "Your textra directory is: ",
                    "Your current directory is: ",
                    "Your default output directory is:"
                 ]
print("")
print("Paths defined.")
print("")


# When something is defined,
# Give the information to the user
# 
# 

ask_user_about(paths_data, paths_context)

# Define the user's arguments
# Make every piece of data as readable as possible
#
#

user_arguments = sys.argv[1:]
user_number_of_arguments = len(user_arguments)

if user_number_of_arguments == 2 or user_number_of_arguments == 3:
    user_has_right_number_of_arguments = True
else
    print(f"You have given {user_number_of_arguments} command line arguments.")
    print("It is an invalid number, please revise.")
    print("Exiting...")
    sys.exit(1)

if user_has_right_number_of_arguments:
    user_has_two_arguments = True
    user_first_argument = user_arguments[0]
    user_second_argument = user_arguments[1]
    if user_number_of_arguments == 3:
        user_has_two_arguments = False
        user_third_argument = user_arguments[2]

if user_has_two_arguments:
    arguments_data = [user_first_argument, user_second_argument]
    arguments_context = [
                            "Your first argument is: ",
                            "Your second argument is: ",
                        ]
else
    arguments_data = [user_first_argument, user_second_argument, user_third_argument]
    arguments_context = [
                            "Your first argument is: ",
                            "Your second argument is: ",
                            "Your third argument is: ",
                        ]

print("")
print("User arguments defined.")
print("")
ask_user_about(arguments_data, arguments_context)


# Define the first argument - the .tex file
# Then, test the .tex file


user_tex_filename = user_arguments[0]
user_tex_filepath = current_dir / user_tex_filename
tex_file_data = [user_tex_filename, user_tex_filepath]
tex_file_context = [
                    "Your tex file name is: ",
                    "Your tex file path is: ",
                 ]
print("")
print("Tex file defined.")
print("")
ask_user_about(paths_data, paths_context)


# Define the second argument - the extension
# Define the third argument - the path *Optional
# 
#

# 
# 
# #
# # Define the SED function based on the platform
# # Mac and linux do not use the same SED function
# # darwin is Mac
# #
# 
# def SED(pattern, file_path):
#     if sys.platform == "darwin":
#         sed_command = ["sed", "-i", "", pattern, file_path]
#     else:
#         sed_command = ["sed", "-i", pattern, file_path]
#     return sed_command
# 
# #
# # Check the number of arguments
# #
# 
# if len(sys.argv) < 2:
#     default_output_dir = "your_default_output_dir"
#     print("To extract verbatim content,")
#     print("Provide a .tex file as the first argument.")
#     print(f"Plus, a file extension as the second argument.")
#     print(f"OPTIONAL: An output directory as a third argument (default: {default_output_dir}).")
#     sys.exit(1)
# 
# if tex_file.is_file():
#     print("File found")
# else:
#     print("File not found")
#     sys.exit(1)
# 
# 
# ex_ext="$2"
# # If the third argument is not specified, use the default output dir
# output_dir="${3:-$default_output_dir}"
# 
# if cd "$output_dir" >/dev/null 2>&1; then
#     echo "Output directory found"
#     cd - > /dev/null
# else
#     echo "Output directory ($output_dir) not found. I will attempt to create it."
#     mkdir -p $output_dir
#     if [ $? -ne 0 ]; then
#       echo "Error: I was unable to create the directory."
#       exit 1  # Exit the script with a non-zero exit code
#     fi
# fi
# 
# ##################################
# #
# # Find the right section, given an array of line numbers
# # This implementation is based on the two crystal ball algorithm puzzle.
# #
# # [120,149,220]
# #
# # if number is 135, finds section start at 120
# #
# ##################################
# 
# find_section() {
#     target=$1
#     length=${#section_start_a[@]}
#     sqrtLength=$(echo "sqrt($length)" | bc)
#     jmpAmount=$(echo "($sqrtLength + 0.5) / 1" | bc)
# 
#     i=$jmpAmount
# 
#     while (( i < length )); do
#         if (( section_start_a[i] > target )); then
#             break
#         fi
#         i=$((i + jmpAmount))
#     done
# 
#     i=$((i - jmpAmount))
# 
#     local j
#     for (( j = 0; j <= jmpAmount && i < length; j++, i++ )); do
#         if (( section_start_a[i] > target )); then
# 
#             i=$(( i - 1 ))
# 
#             section=${section_start_a[i]}
# 
#             echo "$section"
#             return
#         fi
#     done
# 
#     echo "-1"
# 
# }
# 
# ##################################
# #
# # Create verbatim.csv
# # Format: Verbatim number, Start, End, Number of lines for Verbatim
# #
# ##################################
# 
# 
# # This pattern should be relative
# awk '/begin{verbat/ { print NR }' "$tex_file" >> begin.txt
# 
# # This pattern should be relative
# awk '/end{verbat/ { print NR }' "$tex_file" >> end.txt
# 
# paste -d ',' begin.txt end.txt > both.csv
# awk -F ',' '{result = $2 - $1; print $0 "," result}' both.csv >> no_num_verbatim.csv
# nl -w1 -s, no_num_verbatim.csv > verbatim.csv
# 
# rm begin.txt end.txt both.csv no_num_verbatim.csv
# 
# 
# ##################################
# #
# # Create keywords.csv
# # Format: Line number, keywords
# #
# ##################################
# 
# # Disclosure: I got this from ChatGPT.
# # https://chat.openai.com/share/ab176cb0-4878-4c03-8f3d-1f0f11f58fe6
# awk -F '[:,]' '/%keywords/ {
#     line = $0;
#     gsub(/%keywords: /, "", line);
#     gsub(/ /, ",", line);
#     gsub(/%keywords:/, "", line);
#     printf "%d:%s\n", NR, line
# }' $tex_file > keywords.csv
# 
# ##################################
# #
# # Create section.csv
# # Format: Section number, Start, Name of Section
# #
# ##################################
# awk '/section/ { print NR "," $0 }' "$tex_file" >> no_num_section.csv
# nl -w1 -s, no_num_section.csv > section.csv
# 
# rm no_num_section.csv
# 
# ##################################
# #
# # Create array of Section Start
# #
# ##################################
# 
# section_start_a=()
# 
# while IFS= read -r line; do
#     IFS=',' read -r sec_num start_point sec_name <<< "$line"
#     section_start_a+=("$start_point")
# done < section.csv
# 
# rm section.csv
# 
# # Append large number, allows last verbatim not to overheap.
# # Otherwise, last verbatim fails the algo.
# section_start_a+=("100000")
# 
# ##################################
# #
# # For each verbatim find section
# #
# ##################################
# 
# while IFS= read -r line; do
#     IFS=',' read -r ver_num start_point end_point ver_num_lines <<< "$line"
#     section=$(find_section "$start_point")
# 
#     sed -n "${section}p" "$tex_file"
# 
# done < verbatim.csv >> section.csv
# 
# paste -d ',' verbatim.csv section.csv > best_verbatim.csv
# 
# rm verbatim.csv ; mv best_verbatim.csv verbatim.csv
# 
# SED 's/\\section{//' verbatim.csv
# SED 's/\\subsection{//' verbatim.csv
# SED 's/}//' verbatim.csv
# 
# SED 's/\\section{//' section.csv
# SED 's/\\subsection{//' section.csv
# SED 's/}//' section.csv
# 
# ##################################
# #
# # For each keyword list find section
# #
# ##################################
# 
# while IFS= read -r line; do
#   IFS=':' read -r key_num keywords <<< "$line"
#   section=$(find_section "$key_num")
# 
#   sed -n "${section}p" $tex_file
# done < keywords.csv >> kw_section.csv
# paste -d ':' keywords.csv kw_section.csv > best_keywords.csv
# rm keywords.csv kw_section.csv
# mv best_keywords.csv keywords.csv
# 
# SED 's/\\section{//' keywords.csv
# SED 's/\\subsection{//' keywords.csv
# SED 's/}//' keywords.csv
# 
# ##################################
# #
# # prompt user
# # "Place the output in $output_dir: ? [y,n]
# #
# ##################################
# if [ "${AUTO}" = "true" ]; then
#   echo "Launching in AUTO mode, skipping prompts."
# else
#   read -p "Place the output in $output_dir? [y/yes,n/no]: " answer
# 
#   lower_answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
# 
#   # Check if the answer is "yes"
#   if [[ "$lower_answer" == "y" || "$lower_answer" == "yes" ]]; then
#       echo "Extracting..."
#   else
#       echo "Extraction aborted." ; exit 1
#   fi
# fi
# 
# #################################
# #
# # Insert the verbatim in a new file, named with the section's name
# #
# #################################
# 
# while IFS= read -r line; do
#     IFS=',' read -r ver_num start_point end_point ver_num_lines sec_name <<< "$line"
# 
#     lowercase_sec_name=$(echo "$sec_name" | tr '[:upper:]' '[:lower:]')
#     no_space_sec_name="${lowercase_sec_name// /_}"
#     final_sec_name="${no_space_sec_name//[\(\)]/}"
# 
#     # write to the model file
#     touch "$output_dir"/"$final_sec_name".$ex_ext
#     sed -n "${start_point},${end_point}p" "$tex_file" >> "$output_dir"/"$final_sec_name".$ex_ext
# 
#     # clean the model file
#     SED 's/\\end{verbatim}//' "$output_dir"/"$final_sec_name".$ex_ext
#     SED 's/\\begin{verbatim}//' "$output_dir"/"$final_sec_name".$ex_ext
#     
# done < verbatim.csv
# 
# #################################
# #
# # Create links for keywords to the matching verbatim file
# #
# #################################
# 
# while IFS= read -r line; do
#     IFS=':' read -r key_num keywords sec_name <<< "$line"
# 
#     lowercase_sec_name=$(echo "$sec_name" | tr '[:upper:]' '[:lower:]')
#     no_space_sec_name="${lowercase_sec_name// /_}"
#     final_sec_name="${no_space_sec_name//[\(\)]/}"
# # We must loop over each keyword in the comma-separated `keywords` value. According to Chat GPT, the way to do this is using IFS. However, since in this scope we are already using IFS to parse the string to split by `:` (e.g. `%keywords:var,vars:Variables`), we have to juggle the IFS.
# # We save the old IFS, perform the loop over `keywords`, and then restore the original IFS.
#     OLD_IFS=$IFS
#     IFS=','
#     read -ra elements <<< "$keywords"
#     IFS=$OLD_IFS
# 
#     for keyword in "${elements[@]}"; do
#       lowercase_key_name=$(echo "$keyword" | tr '[:upper:]' '[:lower:]')
#       no_space_key_name="${lowercase_key_name// /_}"
#       final_key_name="${no_space_key_name//[\(\)]/}"
# 
#       rm -f $output_dir/$final_key_name.$ex_ext
#       ln -s $output_dir/$final_sec_name.$ex_ext $output_dir/$final_key_name.$ex_ext
#     done
# done < keywords.csv
# 
# rm section.csv verbatim.csv keywords.csv
# 
# 
# echo "Successfully extracted in $output_dir"
# 
