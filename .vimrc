" see line numbers
set number

" highlight syntax
syntax on

" Tabs are four columns wide
" Each indentation level is one tab
" Tab in insert mode will not produce
"   the appropriate number of spaces
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab 

" F2 save
noremap <F2> :w<CR>
" F3 save and exit
noremap <F3> :wq<CR>
" F5 force quit
noremap <F5> :q!<CR>

