# My vim  

```
Run "install.sh" will backup your .vimrc file and copy the .vimrc file of this repository.

Run "nocomments.sh" differs from "install.sh" just by removing spaces and comments of the .vimrc file.

If you don't have a .vimrc file, it's just create a new one for you.

Removing second order backups: rm ~/.vimrc_backup_*  
```

## Features and commands 

* See line numbers  
* Highlight syntax  
* Tabs are four columns wide  
* Each indentation level is one tab  
* Do not change tab for spaces  
* Dictionaries  
```
/usr/share/dict/american-english-insane  
/usr/share/dict/brazilian  
/usr/share/dict/words  
```
| Command | Description |  
| -- | -- |  
| F2 | save the file |  
| F3 | save and exit the file |  
| F4 | run the script file "compile.sh" in the same directory |    
| F5 | exit without change the file |  
| F7 | run python with the current file |  
| Control + b | switch between buffer files |       
| Control + i | indent all lines |   
| Type "ctabs" | convert tabs into 4 spaces |  
| Type "exec1" | call /usr/bin/vimexec1 programm |  
| Type "ctest" | write inside the file: |    
||#include <stdlib.h> |
||#include <stdio.h> |
||int main(int argc, char ** argv) |  
||{ |  
||  return 0; |  
||} |  
|| |  
| Type "fun4" | write inside the file: |  
||#!/bin/bash|  
||echo ------------BEGIN---------------|  
||echo ------------REMOVE--------------|  
||rm|  
||echo ------------COMPILE-------------|  
||echo ------------EXECUTE-------------|  
||./|  
||echo ------------END-----------------|     
