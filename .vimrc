""" see line numbers
set number

""" highlight syntax
syntax on

""" Tabs are four columns wide
""" Each indentation level is one tab
""" Tab in insert mode will produce
"""   the appropriate number of spaces
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab 

""" Equal size windows
winc = 

""" Dictionaries
set dictionary+=/usr/share/dict/words

""" F2 save
noremap <F2> :w<CR>
""" F3 save and exit
noremap <F3> :wq<CR>
""" F4 run compile
noremap <F4> :!sh compile.sh<CR>
""" F5 force quit
noremap <F5> :q!<CR>
""" Switch buffer files
noremap <C-b> :bn<CR>
""" Execute /usr/bin/vimprog1
noremap exec1 :!/usr/bin/vimprog1
""" Indent All Lines
noremap <C-i> gg=G

""" C programming commands
noremap ctest i<C-r>=system("echo \"#include <stdlib.h>\n
\#include <stdio.h>\n\n
\int main(int argc, char ** argv)\n
\{\n
\  return 0;\n
\} \"")<CR><Esc><CR>

