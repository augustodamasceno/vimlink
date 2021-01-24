#!/bin/bash

##
#	This script is part of the VIMLINK software.
#
#	This script:
#		Backup the .vimrc file.
#		Copy the VIMLINK .vimrc file.
#		Download and install an english 
#		  dictionary from Hunspell English Dictionaries.
##

if (test -e ~/.vimrc_backup)
then
	mv ~/.vimrc_backup ~/.vimrc_backup_movein$(date +"%d%h%y_%H-%M-%S")
fi

if (test -e ~/.vimrc)
then
	mv ~/.vimrc ~/.vimrc_backup
fi

cp vimrc ~/.vimrc

if (! test -d ~/.dic)
then
	mkdir ~/.dic
fi

wget http://downloads.sourceforge.net/wordlist/hunspell-en_US-2020.12.07.zip
unzip hunspell-en_US-2020.12.07.zip en_US.dic
rm hunspell-en_US-2020.12.07.zip
mv en_US.dic ~/.dic/

