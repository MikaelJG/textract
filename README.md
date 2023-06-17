
![Logo](https://github.com/MikaelJG/noti/blob/master/assets/.png)

Textract is a CLI tool to scrape .tex files. It is the fastest example finder for lazy researchers.

Textract works in harmony with [Noti](https://github.com/noti), my note parser/editor CLI tool.

Included here is noti-light.sh. Provide a path to your file and it will print it for you.

The perfect combo: extract in output directory and search the same dir with noti-light!

## Installation

In your home directory, create or update your .bashrc file.
```bash
$ cd # move to home
$ vim .bashrc # edit your .bashrc file
$ alias textract="~/path/to/textract.sh" # write an alias to textract.sh
$ alias noti="~/path/to/noti-light.sh" # write an alias to noti-light.sh

# for example
  alias noti="~/code/textract/textract.sh
```
Using zsh? Update your .zshrc file.
```bash
$ cd # move to home
$ vim .zshrc # edit your zshrc file 
$ alias textract="~/path/to/textract.sh" # write an alias to textract.sh
$ alias noti="~/path/to/noti-light.sh" # write an alias to noti-light.sh

# for example
  alias noti="~/code/textract/textract.sh
```
## Usage 

Textract extracts verbatim examples and creates an example directory (output) for them.
```bash
$ ./textract file-to-extract extension-for-the-ex-files

# for example
$ ./textract ruby.tex rb
```
Noti-light finds the new extracted files and prints them (with cat).
```bash
$ ./textract file-to-extract extension-for-the-ex-files

# for example
$ ./textract ruby.tex rb
```

The combo!!!
```bash
$ ./textract file-to-extract extension-for-the-ex-files && ./noti-light output/file.sh

# for example
$ ./textract ruby.tex rb && ./noti-light output/variables.rb
```

## Demo

To come.

