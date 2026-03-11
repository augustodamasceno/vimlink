# Vimlink Notes  
> Copyright (c) 2015-2026, Augusto Damasceno.  
> All rights reserved.  
> SPDX-License-Identifier: BSD-2-Clause  

# Manual Installation

## vim (with Python 3 support)
```bash
# Debian/Ubuntu — vim-nox includes Python 3 support
sudo apt install vim-nox
# Fedora/RHEL
sudo dnf install vim
# Arch Linux
sudo pacman -S vim
# macOS
brew install vim
# FreeBSD
sudo pkg install vim
```

## wget
```bash
# Debian/Ubuntu
sudo apt install wget
# Fedora/RHEL
sudo dnf install wget
# Arch Linux
sudo pacman -S wget
# macOS
brew install wget
# FreeBSD
sudo pkg install wget
```

## unzip
```bash
# Debian/Ubuntu
sudo apt install unzip
# Fedora/RHEL
sudo dnf install unzip
# Arch Linux
sudo pacman -S unzip
# macOS
brew install unzip
# FreeBSD
sudo pkg install unzip
```

## Python 3 + development headers
```bash
# Debian/Ubuntu
sudo apt install python3 python3-dev
# Fedora/RHEL
sudo dnf install python3 python3-devel
# Arch Linux
sudo pacman -S python
# macOS
brew install python3
# FreeBSD
sudo pkg install python3
```

## CMake
```bash
# Debian/Ubuntu
sudo apt install cmake
# Fedora/RHEL
sudo dnf install cmake
# Arch Linux
sudo pacman -S cmake
# macOS
brew install cmake
# FreeBSD
sudo pkg install cmake
```

## C++ compiler
```bash
# Debian/Ubuntu
sudo apt install build-essential
# Fedora/RHEL
sudo dnf install gcc-c++
# Arch Linux
sudo pacman -S gcc
# macOS
brew install gcc   # or: xcode-select --install
# FreeBSD
sudo pkg install gcc
```

## vim-plug
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
> Then open Vim and run `:PlugInstall`.

## YouCompleteMe (C, C++ and Python)
```bash
# After :PlugInstall has run:
python3 ~/.vim/plugged/YouCompleteMe/install.py --clangd-completer
```
> Requires python3, python3-dev, cmake, build-essential and clangd to be installed first.

## Exuberant Ctags
```bash
# Debian/Ubuntu
sudo apt install exuberant-ctags
# Fedora/RHEL
sudo dnf install ctags
# Arch Linux
sudo pacman -S ctags
# macOS
brew install ctags
# FreeBSD
sudo pkg install ctags
```

---

# Neovim Manual Installation

## neovim (>= 0.10)
```bash
# Debian/Ubuntu
sudo apt install neovim
# Fedora/RHEL
sudo dnf install neovim
# Arch Linux
sudo pacman -S neovim
# macOS
brew install neovim
# FreeBSD
sudo pkg install neovim
```

## git (required by lazy.nvim)
```bash
# Debian/Ubuntu
sudo apt install git
# Fedora/RHEL
sudo dnf install git
# Arch Linux
sudo pacman -S git
# macOS
brew install git
# FreeBSD
sudo pkg install git
```

## Node.js (required by Copilot plugin)
```bash
# Debian/Ubuntu
sudo apt install nodejs
# Fedora/RHEL
sudo dnf install nodejs
# Arch Linux
sudo pacman -S nodejs
# macOS
brew install node
# FreeBSD
sudo pkg install node
```

## ripgrep (required by Telescope live_grep)
```bash
# Debian/Ubuntu
sudo apt install ripgrep
# Fedora/RHEL
sudo dnf install ripgrep
# Arch Linux
sudo pacman -S ripgrep
# macOS
brew install ripgrep
# FreeBSD
sudo pkg install ripgrep
```

## clangd (C/C++ language server)
```bash
# Debian/Ubuntu
sudo apt install clangd
# Fedora/RHEL
sudo dnf install clang-tools-extra
# Arch Linux
sudo pacman -S clang
# macOS
brew install llvm
# FreeBSD
sudo pkg install llvm
```

## pyright (Python language server)
```bash
pip install pyright
# or, with pipx:
pipx install pyright
```

## cmake-language-server (CMake LSP)
```bash
pip install cmake-language-server
```

## black (Python formatter)
```bash
pip install black
# or, with pipx:
pipx install black
```

## debugpy (Python debug adapter for nvim-dap)
```bash
pip install debugpy
```

## clang-format (C/C++ formatter)
```bash
# Debian/Ubuntu
sudo apt install clang-format
# Fedora/RHEL
sudo dnf install clang-tools-extra
# Arch Linux
sudo pacman -S clang
# macOS
brew install clang-format
```

## gdb (C/C++ debugger for nvim-dap)
```bash
# Debian/Ubuntu
sudo apt install gdb
# Fedora/RHEL
sudo dnf install gdb
# Arch Linux
sudo pacman -S gdb
# macOS
brew install gdb
# FreeBSD
sudo pkg install gdb
```

## lazy.nvim (plugin manager — auto-bootstrapped)
> lazy.nvim is cloned automatically on the first `nvim` launch via the
> bootstrap block in `~/.config/nvim/init.lua`. No manual step required.
> To trigger it manually:
```bash
git clone --filter=blob:none --branch=stable \
  https://github.com/folke/lazy.nvim.git \
  ~/.local/share/nvim/lazy/lazy.nvim
```
> Then open Neovim and run `:Lazy sync`.

---

# Cheat Sheet by Claude Sonnet 4.6
> Prompt: Could you provide a Vim cheat sheet covering essential commands for navigation, editing, searching, and general file management?
```
Vim Cheat Sheet

Navigation
    h, j, k, l      Move left, down, up, right
    0                Start of the line
    ^                First non-blank character of the line
    $                End of the line
    gg               Start of the document
    G                End of the document
    :<n>             Go to line n
    Ctrl+u           Half-page up
    Ctrl+d           Half-page down
    Ctrl+f           Page down
    Ctrl+b           Page up
    w                Next word
    b                Previous word
    %                Jump to matching bracket

Editing
    i                Insert mode at cursor
    a                Insert mode after cursor
    o                Open a new line below and enter insert mode
    O                Open a new line above and enter insert mode
    cw               Change word
    ciw              Change inner word
    cc               Change entire line
    dd               Delete line
    dw               Delete word
    D                Delete to end of line
    yy               Yank (copy) line
    yw               Yank word
    p                Paste after cursor
    P                Paste before cursor
    x                Delete character at cursor
    r                Replace single character
    u                Undo
    Ctrl+r           Redo
    .                Repeat last change
    >>               Indent line
    <<               Unindent line

Visual Mode
    v                Character visual mode
    V                Line visual mode
    Ctrl+v           Block visual mode
    y                Yank selection
    d                Delete selection
    >                Indent selection
    <                Unindent selection

Searching
    /keyword         Search forward for keyword
    ?keyword         Search backward for keyword
    n                Next occurrence
    N                Previous occurrence
    *                Search for word under cursor (forward)
    #                Search for word under cursor (backward)
    :%s/old/new/g    Replace all occurrences of old with new
    :%s/old/new/gc   Replace all with confirmation

File Management
    :w               Save file
    :q               Quit Vim
    :wq  or  :x      Save and quit
    :q!              Quit without saving
    :e <file>        Open file for editing
    :bn              Next buffer
    :bp              Previous buffer
    :ls              List open buffers
    :tabnew <file>   Open file in a new tab
    gt               Next tab
    gT               Previous tab

Windows / Splits
    :sp <file>       Horizontal split
    :vsp <file>      Vertical split
    Ctrl+w h/j/k/l   Move between splits
    Ctrl+w =         Equal size windows
    Ctrl+w q         Close split

Miscellaneous
    :help <keyword>  Get help
    :set number      Show line numbers
    :set paste       Toggle paste mode
    Ctrl+g           Show filename and position
    ga               Show ASCII value of character under cursor
    :!<cmd>          Run shell command
    :shell           Open a shell session (close with exit)
```

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

# Neovim Cheat Sheet
```
Neovim Cheat Sheet  (leader key: <Space>)

Navigation
    h, j, k, l      Move left, down, up, right
    0                Start of the line
    ^                First non-blank character of the line
    $                End of the line
    gg               Start of the document
    G                End of the document
    :<n>             Go to line n
    Ctrl+u           Half-page up
    Ctrl+d           Half-page down
    Ctrl+f           Page down
    Ctrl+b           Page up  (also: next buffer in vimlink)
    w / b            Next / previous word
    %                Jump to matching bracket

Windows
    Ctrl+h/j/k/l     Move between splits
    :sp <file>       Horizontal split
    :vsp <file>      Vertical split

LSP
    gd               Go to definition
    gD               Go to declaration
    gr               Go to references
    gi               Go to implementation
    K                Hover documentation
    <leader>rn       Rename symbol
    <leader>ca       Code action
    <leader>f        Format buffer
    Ctrl+e           Go to next diagnostic

Completion (nvim-cmp)
    Ctrl+Space       Trigger completion
    Tab / Shift+Tab  Next / previous item
    Enter            Confirm selection
    Ctrl+e           Abort completion

Telescope (fuzzy finder)
    <leader>ff       Find files
    <leader>fg       Live grep (requires ripgrep)
    <leader>fb       Browse open buffers
    <leader>fh       Search help tags
    <leader>fd       Search diagnostics

Trouble (diagnostics list)
    <leader>xx       Toggle workspace diagnostics
    <leader>xX       Toggle buffer diagnostics

Harpoon (file bookmarks)
    <leader>ha       Add current file to Harpoon list
    <leader>hh       Toggle Harpoon quick menu
    <leader>h1-4     Jump to Harpoon file 1–4

Debugger (nvim-dap)
    <leader>db       Toggle breakpoint
    <leader>dc       Continue
    <leader>ds       Step over
    <leader>di       Step into
    <leader>do       Step out
    <leader>du       Toggle DAP UI

Gitsigns
    ]c / [c          Next / previous hunk
    <leader>gs       Stage hunk
    <leader>gu       Undo staged hunk
    <leader>gp       Preview hunk
    <leader>gb       Blame line

Oil (file manager)
    -                Open Oil in current directory
    Enter            Open file or directory
    -                Go up one directory
    :w               Apply pending changes
    g?               Show help

CMake (cmake-tools.nvim)
    :CMakeGenerate   Configure/generate build files
    :CMakeBuild      Build the project
    :CMakeRun        Run the selected target
    :CMakeDebug      Debug the selected target
    :CMakeClean      Clean build artifacts

Copilot
    Alt+Enter        Accept suggestion
    Alt+]            Next suggestion
    Alt+[            Previous suggestion
    Ctrl+]           Dismiss suggestion

Buffers
    Ctrl+b           Next buffer
    :bd              Delete (close) buffer
    :ls              List open buffers

Miscellaneous
    Ctabs            Convert tabs to 4 spaces
    Ctrl+i           Re-indent all lines
    :Lazy            Open lazy.nvim plugin manager UI
    :Lazy sync       Update all plugins
    :LspInfo         Show active LSP clients
    :TSUpdate        Update Treesitter parsers
    :checkhealth     Run Neovim health checks
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
* 1. https://www.vim.org/  
* 2. http://www.vivaolinux.com.br/dica/Editor-Vim-Introducao-e-trabalhando-com-Vim  
* 3. http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)  
* 4. http://www.thegeekstuff.com/2009/01/vi-and-vim-editor-5-awesome-examples-for-automatic-word-completion-using-ctrl-x-magic/
* 5. [Better linting in Vim with Ale by Victor Mours]( https://medium.com/@victormours/better-linting-in-vim-with-ale-1e4b1d5789af)  
* 6. https://github.com/victormours/dotfiles

