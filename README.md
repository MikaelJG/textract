
![Logo](https://github.com/MikaelJG/noti/blob/master/assets/.png)

Textract is a CLI tool to scrape .tex files. It is the fastest example finder for lazy researchers.

## Usage

Given a .tex file, an extension and a path.

```bash
$ ./textract ruby.tex rb ~/ruby/examples
```
From the ruby.tex file.

```
\chapter{Basics}

\section{Variables}
%keywords:var,vars

\begin{verbatim}
    int: integers                   
    double: floating-point numbers
    char: individual characters   
\end{verbatim}
```

The following examples will be extracted.

```
├── ruby
    ├── examples 
        ├── variable.rb
        ├── vars -> /path/to/variables.abc
        ├── var -> /path/to/variables.abc
```

### Both Keywords and Paths are optional

Given a .tex file, an extension.

```bash
$ ./textract kubernetes.tex abc
```

From the kubernetes.tex file.

```
\chapter{Basics}

\section{Variables}

\begin{verbatim}
    int: integers                   
    double: floating-point numbers
    char: individual characters   
\end{verbatim}
```

The following examples will be extracted.

```
├── examples 
    ├── variable.abc
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

