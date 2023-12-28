""" This file is part of Vimlink software (V3.0)
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
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

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

"""" Ale Pluging Configuration by Victor Mours (Ref x)
nmap <silent> <C-e> <Plug>(ale_next_wrap)
let g:ale_lint_on_enter = 0
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'

function! LinterStatus() abort
	let l:counts = ale#statusline#Count(bufnr(''))    
	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors    
	return l:counts.total == 0 ? 'OK' : printf(
				        \   '%d⨉ %d⚠ ',
						\   all_non_errors,
						\   all_errors
						\)
endfunction
set statusline+=%=
set statusline+=\ %{LinterStatus()}

""" PLUGINS
call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/vim-asm'
Plug 'dense-analysis/ale'
Plug 'majutsushi/tagbar'
Plug 'preservim/nerdtree'
Plug 'ycm-core/YouCompleteMe'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'

call plug#end()

let g:indent_guides_enable_on_vim_startup = 1
set laststatus=2
