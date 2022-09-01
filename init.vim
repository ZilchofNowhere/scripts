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

Plug 'https://github.com/tpope/vim-commentary' 
Plug 'http://github.com/tpope/vim-surround'
Plug 'tmsvg/pear-tree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'navarasu/onedark.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'https://github.com/PhilRunninger/nerdtree-visual-selection.git'
Plug 'Mofiqul/vscode.nvim'
Plug 'andweeb/presence.nvim' 
Plug 'doums/darcula'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'

" Always set as the last one
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Customizing onedark.nvim
let g:onedark_config = {
            \ 'style': 'deep',
            \}

" Color scheme
colorscheme onedark

" Customizing Airline 
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.readonly = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '' 
let g:airline#extensions#whitespace#enabled = 0

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

" Remapping Ctrl-D to multi-select because of convenience and to avoid overlap
" with NERDTree shortcut 
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>' " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'

" Customizing NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Remap <leader>n to visual block mode because Windows Terminal sees Ctrl-V as paste
nnoremap <leader>v <C-v> 

" Getting rid of the stupid W (or Q) is not a command error
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

" Aliasing `set autochdir` to 'Cd'
command Cd set autochdir 

" Customizing Startify
"let g:startify_custom_header = startify#pad(split(system('figlet -w 100 "Welcome to Neovim"'), '\n')) 
let g:startify_files_number = 5
let g:startify_lists = [
            \{"type": "files",    "header": ["\t\tRecent files"]},
            \{"type": "sessions", "header": ["\t\tRecent sessions"]},
            \{"type": "commands", "header": ["\t\tCommands"]}
            \]
let g:startify_fortune_use_unicode = 1
let g:startify_padding_left = 5
let g:startify_custom_header = 'startify#pad(startify#fortune#cowsay())'
