#!/bin/bash

if (test -e ~/.vimrc_backup)
    then
        mv .vimrc_backup ".vimrc_backup_movein$(date +"%d%m%y%h")"
fi

if (test -e ~/.vimrc)
    then
        mv ~/.vimrc ~/.vimrc_backup
fi


cat .vimrc | grep -v \" > ~/.vimrc
