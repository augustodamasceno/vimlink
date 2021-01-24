""" This file is part of Vimlink software (V2.0)
""" See https://github.com/augustodamasceno/vimlink

""" STRUCTURE AND APPEARANCE
""" see line numbers
set number
""" highlight syntax
syntax on
""" Tabs are four columns wide
""" Each indentation level is one tab
""" expandtab change tab for spaces
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab 
""" Equal size windows
winc = 
""" English Dictionary
set dictionary+=~/.dic/en_US.dic
""" Colors legible for dark background
set background=dark

""" COMMANDS TO SAVE OR QUIT
""" F2 save
noremap <F2> :w<CR>
""" F3 save and exit
noremap <F3> :wq<CR>
""" F12 force quit
noremap <F12> :q!<CR>

""" PROGRAMMING COMMANDS
""" F5 runs "make && make clean && make run"
noremap <F5> :!make && make clean && make run<CR>
""" F6 runs python with the current file
noremap <F6> :!python %<CR>
""" F7 Convert tabs into 4 spaces
noremap <F8> :%s/\t/    /g<CR>

""" TEXT EDITION COMMANDS
""" Switch buffer files
noremap <C-b> :bn<CR>
""" Indent All Lines
noremap <C-i> gg=G
""" C basic body code
noremap cbody i<C-r>=system("echo \"#include <stdlib.h>\n
\#include <stdio.h>\n\n
\int main(int argc, char ** argv)\n
\{\n
\  return 0;\n
\} \"")<CR><Esc><CR>
""" C for loop
noremap cfor i<C-r>=system("echo \"for (i=0; i<n; i++)\n
\{\n\n
\}\"")<CR><Esc><CR>

