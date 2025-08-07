" Basics
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions

" Color
syntax on
colorscheme darkblue

" Indentation
filetype plugin indent on   " allows auto-indenting depending on file type
set tabstop=4               " number of columns occupied by a tab character
set expandtab               " convert tabs to white space
set shiftwidth=4            " width for autoindents
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing

" Global properties
set pastetoggle=<F12>
noremap <F10> :syntax sync fromstart
set splitbelow
set splitright

" Backups
set backup 
set undodir=~/.config/nvim/.undo/
set backupdir=~/.config/nvim/.backup/
set directory=~/.config/nvim/.swp/

" Custom commands
"" Search
noremap <F2> :set spell! spell?<CR>
noremap <F4> :set hlsearch! hlsearch?<CR>
set ignorecase
set smartcase
"" Splits
command -nargs=* -complete=file Sj set splitbelow <bar> split <args>
command -nargs=* -complete=file Sk set nosplitbelow <bar> split <args>
command -nargs=* -complete=file Sd set splitbelow <bar> split <args>
command -nargs=* -complete=file Su set nosplitbelow <bar> split <args>
command -nargs=* -complete=file Sh set nosplitright <bar> vertical split <args>
command -nargs=* -complete=file Sl set splitright <bar> vertical split <args>

" Plugins
" specify directory for plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'arcticicestudio/nord-vim'

" initialize plugin system
call plug#end()
