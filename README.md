# My vim  


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

## Dependency  
* vim-plug  
### Instalation in Unix-like
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

```
> Open Vim and run :PlugInstall.

## Features and commands 

* See line numbers  
* Highlight syntax  
* Tabs are four columns wide  
* Each indentation level is one tab  
* Do not change tab for spaces 
* Equal size windows 
* English Dictionary completion  
* F2 command : save the file  
* F3 command : save and exit the file  
* F12 command : force quit (exit without saving changes)  
* F5 command : runs "make && make clean && make run"  
* F6 command : run python with the current file  
* F7 command : convert tabs into 4 spaces  
* Control + b command : change buffer files  
* Control + i command : Indent all lines  
* Control + e command : Got to the next error  
* vim-scripts/vim-asm: Adds support for assembly language syntax highlighting and features in Vim.  
* dense-analysis/ale: ALE (Asynchronous Lint Engine) is a plugin for real-time syntax checking and linting.  
* majutsushi/tagbar: Tagbar provides an overview of the structure of code files, displaying tags in a sidebar.  
* preservim/nerdtree: NERDTree is a file explorer tool that adds a navigable tree structure for files and directories.  
* ycm-core/YouCompleteMe: YouCompleteMe is a fast, powerful code completion engine for Vim.  
* itchyny/lightline.vim: Lightline is a lightweight status line/tabline for Vim, offering a visually appealing and informative status bar.  
* nathanaelkane/vim-indent-guides: Vim Indent Guides visually displays text indentation levels with subtly highlighted guides.  

## Notes and references in the file [notes.md"](https://github.com/augustodamasceno/vimlink/blob/main/notes.md) 
