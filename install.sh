#!/bin/bash

if (test -e ~/.vimrc_backup)
    then
        mv .vimrc_backup ".vimrc_backup_movein$(date +"%d%m%y%h")"
fi

mv ~/.vimrc ~/.vimrc_backup
cp .vimrc ~/.vimrc
