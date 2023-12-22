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
* vim-scripts/vim-asm: Improves how assembly code looks in Vim with better colors and formatting   
* dense-analysis/ale: Checks your code for errors as you type and suggests corrections  
* majutsushi/tagbar: Shows an outline of your code (like functions and variables) in a sidebar, making it easier to navigate through the code.  
* preservim/nerdtree: Adds a file explorer inside Vim, allowing you to browse and open files directly from the editor.  

## More commands and infos in the "man" file.  
