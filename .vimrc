""" see line numbers
set number

""" highlight syntax
syntax on

""" Tabs are four columns wide
""" Each indentation level is one tab
""" Tab in insert mode will not produce
"""   the appropriate number of spaces
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab 

""" Equal size windows
winc = 

""" F2 save
noremap <F2> :w<CR>
""" F3 save and exit
noremap <F3> :wq<CR>
""" F4 run compile
noremap <F4> :!sh compile.sh
""" F5 force quit
noremap <F5> :q!<CR>


""" C programming commands
noremap ctest i<C-r>=system("echo \"#include <stdlib.h>\n
\#include <stdio.h>\n\n
\#include <stdio.h>\n\n
\int main(int argc, char ** argv)\n
\{\n
\  return 0;\n
\} \"")<CR>
