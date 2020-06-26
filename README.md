# My vim  


## Installation for Unix-like systems.
* Run "install.sh" will backup your .vimrc file and copy the .vimrc file of this repository.
* If you don't have a .vimrc file, it's just create a new one for you.
* Removing second order backups: rm ~/.vimrc_backup_*

## Features and commands 

* See line numbers  
* Highlight syntax  
* Tabs are four columns wide  
* Each indentation level is one tab  
* Do not change tab for spaces 
* Equal size windows 
* Dictionaries  
```shell
/usr/share/dict/american-english-insane  
/usr/share/dict/brazilian  
/usr/share/dict/words  
```
* F2 command : save the file  
* F3 command : save and exit the file  
* F12 command : force quit (exit without saving changes)  
* F5 command : runs "make && make clean && make run"  
* F6 command : run python with the current file  
* F7 command : convert tabs into 4 spaces  
* Control + b command : change buffer files  
* Control + i command : Indent all lines  
* "cbody" command : write inside the file:  
```c
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char ** argv)
{
  return 0;
} 
```
* "cfor" command : write inside the file:  
```c
for (i=0; i<n; i++)
{

}

```
  
## More commands and infos in the "man" file.  

