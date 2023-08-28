
![Logo](https://github.com/MikaelJG/noti/blob/master/assets/.png)

Textract is a CLI tool to scrape .tex files. It is the fastest example finder for lazy researchers.

## Example

Given a .tex file.

```
\chapter{Basics}

\section{Variables}

\begin{verbatim}
    int: integers                   
    double: floating-point numbers
    char: individual characters   
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

## Usage

# Example 1

Command line.

```bash
$ ./textract ruby.tex rb
```

Extracted.

```
├── examples 
    ├── variable.rb
    ├── logical_operators.rb
    ├── ...
```

# Example 2

Command line.

```bash
$ ./textract kubernetes.tex abc
```

Extracted.

```
├── examples 
    ├── variable.abc
    ├── logical_operators.abc
    ├── ...
```

## Installation


## Alias for textract

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

