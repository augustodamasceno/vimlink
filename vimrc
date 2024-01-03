""" Vimlink .vimrc
"""
""" Copyright (c) 2015-2024, Augusto Damasceno.
""" All rights reserved.
""" 
""" SPDX-License-Identifier: BSD-2-Clause

""" STRUCTURE AND APPEARANCE
""" see line numbers
set number
""" highlight syntax
syntax on
""" Tabs are four columns wide
""" Each indentation level is one tab
""" Don't change tab for spaces
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab 
""" Equal size windows
winc = 
""" English Dictionary
set dictionary+=~/.dic/en_US.dic
""" Colors legible for dark background
set background=dark
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

""" MAPPING COMMANDS
"""" Convert all tabs into 4 spaces
noremap ctabs :%s/\t/    /g<CR>
""" Switch buffer files
noremap <C-b> :bn<CR>
""" Indent All Lines
noremap <C-i> gg=G
""" Show/Hide Tagbar window
noremap tags :TagbarToggle<CR>

""" FUNCTIONS
function! ReplaceBeginningChars(numChars, newText) range
	let l:pattern = '^.\{' . a:numChars . '}\ze'
	execute a:firstline . ',' . a:lastline . 's/' . l:pattern . '/' . a:newText . '/'
endfunction

command! -nargs=+ -range=% Rbeg :<line1>,<line2>call ReplaceBeginningChars(<f-args>)

"""" Ale Pluging Configuration by Victor Mours (Reference 4 in notes.md)
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
