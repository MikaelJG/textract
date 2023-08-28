
![Logo](https://github.com/MikaelJG/noti/blob/master/assets/.png)

Textract is a CLI tool to scrape .tex files. It is the fastest example finder for lazy researchers.

## Usage 

Given a .tex file.

```
\chapter{C++ Basics}

\section{Variables}

\begin{verbatim}
    int: integers                   // 4 bytes
    double: floating-point numbers  // double 8 bytes
    char: individual characters     // 1 byte
\end{verbatim}

\subsection{Logical Operators}

\begin{verbatim}
    &&              and 
    ||              or
    !               not
\end{verbatim}
```
Create a file for your \begin{verbatim} to \end{verbatim} examples.

```
├── examples 
    ├── variable.
    ├── logical_operators
    ├── ...
```

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

## Demo

To come.

