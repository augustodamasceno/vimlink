#!/bin/bash

if (test -e ~/.vimrc_backup)
then
    mv ~/.vimrc_backup ~/.vimrc_backup_movein$(date +"%d%h%y_%H-%M-%S")
fi

if (test -e ~/.vimrc)
then
    mv ~/.vimrc ~/.vimrc_backup
fi

cp vimrc ~/.vimrc
