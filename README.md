# My vim  

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
* vim-plug  
### Instalation in Unix-like
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

```
> Open Vim and run :PlugInstall.
* YouCompleteMe completions for several programming languages    
> https://ycm-core.github.io/YouCompleteMe/#installation  

## Features and commands 

* See line numbers  
* Highlight syntax  
* Tabs are four columns wide  
* Each indentation level is one tab  
* Do not change tab for spaces 
* Equal size windows 
* English Dictionary completion  
* Commands  
    * 'ctabs' : convert tabs into 4 spaces  
    * 'rbeg' <NUM-CHARS> <REPLACE-WITH> : Replace beginning characters of a selection 
    * Control + b : change buffer files   
    * Control + i : Indent all lines  
    * Control + e : Got to the next error  
* Plugins
    * vim-scripts/vim-asm: Adds support for assembly language syntax highlighting and features in Vim.  
    * dense-analysis/ale: ALE (Asynchronous Lint Engine) is a plugin for real-time syntax checking and linting.  
    * majutsushi/tagbar: Tagbar provides an overview of the structure of code files, displaying tags in a sidebar.  
    * preservim/nerdtree: NERDTree is a file explorer tool that adds a navigable tree structure for files and directories.  
    * ycm-core/YouCompleteMe: YouCompleteMe is a fast, powerful code completion engine for Vim.  
    * itchyny/lightline.vim: Lightline is a lightweight status line/tabline for Vim, offering a visually appealing and informative status bar.  
    * nathanaelkane/vim-indent-guides: Vim Indent Guides visually displays text indentation levels with subtly highlighted guides.  

## Notes and references in the file [notes.md](https://github.com/augustodamasceno/vimlink/blob/main/notes.md) 
