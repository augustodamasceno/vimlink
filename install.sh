#!/bin/bash
# Vimlink .vimrc
#
# Copyright (c) 2015-2024, Augusto Damasceno.
# All rights reserved.
# 
# SPDX-License-Identifier: BSD-2-Clause
#
#  This script:
#    Backup previous backup
#    Backup the .vimrc file.
#    Copy the VIMLINK .vimrc file to $HOME/.vimrc
#    Download and install an english 
#      dictionary from Hunspell English Dictionaries.

if (test -e ~/.vimrc_backup)
then
	echo "Making a backup of the previous backup"
	mv ~/.vimrc_backup ~/.vimrc_backup_movein$(date +"%d%h%y_%H-%M-%S")
fi

if (test -e ~/.vimrc)
then
	echo "Making a backup of the previous vimrc file"
	mv ~/.vimrc ~/.vimrc_backup
fi

echo "Installing the vimrc file"
cp vimrc ~/.vimrc

if (! test -d ~/.dic)
then
	mkdir ~/.dic
fi

if [ ! -f ~/.dic/en_US.dic ]; then
	echo "Installing the English dictionary"
	wget http://downloads.sourceforge.net/wordlist/hunspell-en_US-2020.12.07.zip
	unzip hunspell-en_US-2020.12.07.zip en_US.dic
	rm hunspell-en_US-2020.12.07.zip
	mv en_US.dic ~/.dic/
else
	echo "The English dictionary already exists"
fi

echo "All Done."


