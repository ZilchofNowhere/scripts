set number
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp1252,default,latin9
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
set mouse=a
set termguicolors
let mapleader = "\<Space>"
autocmd VimLeave * silent set guicursor=a:ver10-blinkon1

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
Plug 'tmsvg/pear-tree'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'https://github.com/PhilRunninger/nerdtree-visual-selection.git'
" Always set as the last one
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Color scheme
colorscheme onedark

" Customizing Airline
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

"Customizing pear-tree
let g:pear_tree_pairs = {
            \ '(': {'closer': ')'},
            \ '[': {'closer': ']'},
            \ '{': {'closer': '}'},
            \ "'": {'closer': "'"},
            \ '"': {'closer': '"'},
            \ '/*': {'closer': '*/'},
            \ }

" Customizing Coc.nvim
" Mapping F2 to autocomplete 
inoremap <silent><expr> <F2> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<F2>\<c-r>=coc#enter()\<F2>"

" Customizing NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
a
