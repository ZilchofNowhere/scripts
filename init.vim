set number
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp1252,default,latin9
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
set guicursor=
set mouse=a
set termguicolors

" Tab behavior
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab autoindent

" Vim-Plug
" default plugin directory is ~/vimfiles/plugged
call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Color scheme
colorscheme onedark

" Customizing Airline
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
