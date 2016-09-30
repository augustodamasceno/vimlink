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

""" Dictionaries
""" See https://packages.debian.org/jessie/wordlist
set dictionary+=/usr/share/dict/american-english-insane
set dictionary+=/usr/share/dict/brazilian
set dictionary+=/usr/share/dict/words 

""" F2 save
noremap <F2> :w<CR>
""" F3 save and exit
noremap <F3> :wq<CR>
""" F4 run compile.sh
noremap <F4> :!sh compile.sh<CR>
""" F5 force quit
noremap <F5> :q!<CR>
""" Switch buffer files
noremap <C-b> :bn<CR>
""" Execute /usr/bin/vimprog1
noremap exec1 :!/usr/bin/vimexec1
""" Indent All Lines
noremap <C-i> gg=G

""" C programming commands
noremap ctest i<C-r>=system("echo \"#include <stdlib.h>\n
\#include <stdio.h>\n\n
\int main(int argc, char ** argv)\n
\{\n
\  return 0;\n
\} \"")<CR><Esc><CR>

""" Compile Script for F4 Function
noremap fun4 i<C-r>=system("echo \"#!/bin/bash\n\n\n
\echo ------------BEGIN---------------\n
\echo ------------REMOVE--------------\n
\rm\n
\echo ------------COMPILE-------------\n\n
\echo ------------EXECUTE-------------\n
\./\n
\echo ------------END-----------------\"")<CR><Esc><CR>

""" Convert tabs into 4 spaces
noremap ctabs :%s/\t/    /g

""" MPI Support -- MPI INIT
"""noremap minit i<C-r>=system("echo \"/* INIT */\n
"""\int comm_sz;\n
"""\int my_rank;\n\n
"""\/* int MPI_Init(&argc, &argv); */\n
"""\MPI_Init(NULL, NULL);\n\n
"""\MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);\n
"""\MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);\n\n
"""\MPI_Finalize();\n\"")<CR><Esc><CR>

""" MPI Support -- MPI SEND
"""noremap msend i<C-r>=system("echo \"
"""\MPI_Send(void*, int count, MPI_Datatype, \
"""\int dest, int tag, MPI_COMM_WORLD);\n
"""\ \"")<CR><Esc><CR>


