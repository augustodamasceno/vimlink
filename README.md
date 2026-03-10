# Vimlink - My Vim Configuration    

> Copyright (c) 2015-2024, Augusto Damasceno.  
> All rights reserved.   
> SPDX-License-Identifier: BSD-2-Clause

## Contact
> [augustodamasceno@protonmail.com](mailto:augustodamasceno@protonmail.com)

## Installation for Unix-like systems.
* Run "install.sh" will backup your .vimrc file and copy the .vimrc file of this repository.
* If you don't have a .vimrc file, it just creates a new one for you.
* An english dictionary will be copied from Hunspell English Dictionaries
 (under a MIT-like license and BSD license for the affix file). 
See http://wordlist.aspell.net/hunspell-readme/.  

## Files
```shell
~/.vimrc
~/.vimrc_backup_*
~/.dic/en_US.dic
```  

## Dependencies  

`install.sh` automatically installs all dependencies listed below. For manual installation instructions of any individual package, see [notes.md](https://github.com/augustodamasceno/vimlink/blob/main/notes.md).

| Dependency | Description |
|---|---|
| **vim-nox** | Vim build compiled with Python 3 support, required by YouCompleteMe |
| **wget** | Downloads vim-plug and the English dictionary |
| **unzip** | Extracts the downloaded dictionary archive |
| **python3** | Runtime for YouCompleteMe and its build system |
| **python3-dev** | Python 3 C headers needed to compile the YouCompleteMe native extension |
| **cmake** | Build system used to compile the ycmd server |
| **build-essential** | GCC/G++ compiler and make, required to build ycmd |
| **clangd** | Language server providing C and C++ completions via YouCompleteMe |
| **Exuberant Ctags** | Generates tag files for code navigation (`:tags` command) |
| **vim-plug** | Vim plugin manager, fetches and manages all Vim plugins |
| **YouCompleteMe** | Fast code completion engine for C, C++ and Python |

## Features and commands 

* See line numbers  
* Highlight syntax  
* Tabs are four columns wide  
* Each indentation level is one tab  
* Do not change tab for spaces 
* Equal size windows 
* English Dictionary completion  
* Colors optimized for dark background  
* Backspace works over indentation, line breaks and insert start  
* Linter status shown in the status line (errors and warnings count)  
* ALE lints on save, not on buffer enter  
* Commands  
    * `ctabs` : convert tabs into 4 spaces  
    * `Rbeg` \<NUM-CHARS\> \<REPLACE-WITH\> : Replace beginning characters of a selection 
    * `tags` : Show/Hide Tags  
    * `Ycmoff` : Enable/Disable YouCompleteMe  
    * Control + b : change buffer files   
    * Control + e : Go to the next error  
    * Control + i : Indent all lines  
    * Control + t : Open NERDTree file explorer   
* Plugins
    * vim-scripts/vim-asm: Adds support for assembly language syntax highlighting and features in Vim.  
    * dense-analysis/ale: ALE (Asynchronous Lint Engine) is a plugin for real-time syntax checking and linting.  
    * majutsushi/tagbar: Tagbar provides an overview of the structure of code files, displaying tags in a sidebar.  
    * preservim/nerdtree: NERDTree is a file explorer tool that adds a navigable tree structure for files and directories.  
    * ycm-core/YouCompleteMe: YouCompleteMe is a fast, powerful code completion engine for Vim.  
    * itchyny/lightline.vim: Lightline is a lightweight status line/tabline for Vim, offering a visually appealing and informative status bar.  
    * nathanaelkane/vim-indent-guides: Vim Indent Guides visually displays text indentation levels with subtly highlighted guides.  

## Cheat Sheets and references in the file [notes.md](https://github.com/augustodamasceno/vimlink/blob/main/notes.md) 
