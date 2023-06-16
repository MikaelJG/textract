
![Logo](https://github.com/MikaelJG/noti/blob/master/assets/.png)

Textract is a CLI tool to scape .tex files. It is the fastest example finder for lazy researchers.

Textract works in harmony with [Noti](https://github.com/noti), my Note parser/editor CLI tool.

## Installation

In your home directory, create or update your .bashrc file.
```bash
$ cd # move to home
$ vim .bashrc # edit your .bashrc file
$ alias noti="~/path/to/noti.sh" # write an alias to noti.sh

# for example
  alias noti="~/code/noti/noti/noti.sh"
```
Using zsh? Update your .zshrc file.
```bash
$ cd # move to home
$ vim .zshrc # edit your zshrc file 
$ alias noti="~/path/to/noti.sh" # write an alias to noti.sh

# for example
  alias noti="~/code/noti/noti/noti.sh"
```
## Usage 

Textract extracts verbatim examples and creates an example directory (output) for them.
```bash
$ ./textract file-to-extract extension-for-the-ex-files

# for example
$ ./textract ruby.tex rb
```
## Demo

To come.

