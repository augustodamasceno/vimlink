# Cheat Sheet by ChatGPT 4.0
> Prompt: Could you provide a Vim cheat sheet covering essential commands for navigation
>    , editing, searching, and general file management?
```
Vim Cheat Sheet
Basic Navigation

    h, j, k, l: Move left, down, up, right.
    0: Start of the line.
    $: End of the line.
    gg: Start of the document.
    G: End of the document.
    Ctrl+u: Half-page up.
    Ctrl+d: Half-page down.
    Ctrl+f: Page down.
    Ctrl+b: Page up.

Editing

    i: Insert mode at cursor.
    a: Insert mode after cursor.
    o: Open a new line below and enter insert mode.
    O: Open a new line above and enter insert mode.
    cw: Change word.
    dd: Delete line.
    yy: Yank (copy) line.
    p: Paste after cursor.
    P: Paste before cursor.
    x: Delete character at cursor.
    r: Replace single character.

Searching

    /[keyword]: Search for [keyword].
    n: Next occurrence.
    N: Previous occurrence.
    *: Search for word under cursor.
    :%s/old/new/g: Replace all occurrences of old with new.

File Management

    :w: Save file.
    :q: Quit Vim.
    :wq or :x: Save and quit.
    :q!: Quit without saving.
    :e [file]: Open [file] for editing.
    :tabnew [file]: Open [file] in a new tab.

Miscellaneous

    u: Undo.
    Ctrl+r: Redo.
    v: Visual mode.
    :help [keyword]: Get help for [keyword].
```

# Misc Notes  
```
esc : command mode
i : iterative mode
q! : exit without save
:q : exit
:w : save
:wq : exit & save
:v : select line
:y : copy text
:p : paste text
ctrl-w : remove word
ctrl-u : remove line
:number : go to line "number"
:0 : move cursor to init
:$ : move cursor to end
:!"shell command""
/word : search "word" word
:shell : open shell session (close with "exit")
:%s/search_for_this/replace_with_this/ 
:%s/search_for_this/replace_with_this/c
:mk letter : mark ('letter : got to mark)
crtl-g : filename
set lines=numberOFlin
set columns=numberOFcol

" Change tabs per spaces
:%s/\t/    /g

" Deleting 2 first chars in all lines
:'{,'}norm! 2x


<BS>           Backspace
<Tab>          Tab
<CR>           Enter
<Enter>        Enter
<Return>       Enter
<Esc>          Escape
<Space>        Space
<Up>           Up arrow
<Down>         Down arrow
<Left>         Left arrow
<Right>        Right arrow
<F1> - <F12>   Function keys 1 to 12
#1, #2..#9,#0  Function keys F1 to F9, F10
<Insert>       Insert
<Del>          Delete
<Home>         Home
<End>          End
<PageUp>       Page-Up
<PageDown>     Page-Down
<bar>          the '|' character, which otherwise needs to be escaped '\|'

" split and manage window
" From https://www.cs.oberlin.edu/~kuperman/help/vim/windows.html
 
 :e filename      - edit another file
 :split filename  - split window and load another file
 ctrl-w up arrow  - move cursor up a window
 ctrl-w ctrl-w    - move cursor to another window (cycle)
 ctrl-w_          - maximize current window
 ctrl-w=          - make all equal size
 10 ctrl-w+       - increase window size by 10 lines
 :vsplit file     - vertical split
 :sview file      - same as split, but readonly
 :hide            - close current window
 :only            - keep only this window open
 :ls              - show current buffers
 :b 2             - open buffer #2 in this window

x - Deletes the character under the cursor.
dw - Deletes the word from the current cursor position to the end.
dd - Deletes the current line and copies its content to the clipboard.
D - Deletes the line from the current cursor position to the end.
:A,Bd - Deletes from line A to line B and copies to the clipboard.
rx - Replaces the character under the cursor with the one specified in x.
u - Undoes the last modification.
U - Undoes all modifications made on the current line.
J - Joins the current line with the next one.
yy - Copies 1 line to the clipboard.
yNy - Copies N lines to the clipboard.
p - Pastes the content from the clipboard.
Np - Pastes the content from the clipboard N times.
cc - Deletes the line's content and copies it to the clipboard.
cNc - Deletes the content of N lines and copies it to the clipboard (starting from the current line).
ndd - Deletes the content of n lines starting from the current line.
nD - Deletes from the current cursor position to the end of n lines.

:winc = : equal size windows

" Completions

" Line completion
Ctrl-x Ctrl-l
" Word completion
Ctrl-x Ctrl-n
Ctrl-x Ctrl-p
" Filename completion
Ctrl-x Ctrl-f
" Dictionary completion
Ctrl-x Ctrl-k
```

# Sort

# Sort in reverse
:%sort!
Sort, removing duplicate lines
:%sort u
Sort using the external Unix sort utility, respecting month-name order
:%!sort -M
("respecting month-name order" means January < February < ... < December)

## Numeric sort
:sort n
(this way, 100 doesn't precede 20 in the sort)

## Sort subsections independently, in this example sort numbers between "start" and "end" markers
:g/start/+1,/end/-1 sort n
Sort only specific lines using ranges
sort lines 296 to 349, inclusive

:296,349sort


# References 
* https://www.vim.org/  
* http://www.vivaolinux.com.br/dica/Editor-Vim-Introducao-e-trabalhando-com-Vim  
* http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)  
* http://www.thegeekstuff.com/2009/01/vi-and-vim-editor-5-awesome-examples-for-automatic-word-completion-using-ctrl-x-magic/
* [Better linting in Vim with Ale by Victor Mours]( https://medium.com/@victormours/better-linting-in-vim-with-ale-1e4b1d5789af)  
* https://github.com/victormours/dotfiles

