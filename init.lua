local set = vim.o
local g = vim.g
local fn = vim.fn
local key = vim.keymap

set.encoding = "utf-8"
set.fileencodings = "utf-8,ucs-bom,cp1252,default,latin9"
set.number = true
set.ignorecase = true
set.mouse = "a"
set.termguicolors = true
set.foldmethod = "syntax"
set.foldenable = false
set.foldnestmax = 10
set.foldlevel = 2

g.mapleader = " "

set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftwidth = 4
set.smarttab = true
set.autoindent = true

g.onedark_config = { style = "deep" }

-- VimL configurations and Vim-Plug commands as they cannot be transfered without a change in the package manager
vim.cmd([[
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
Plug 'andweeb/presence.nvim' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim' 
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'

" Always set as the last one
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Getting rid of the stupid W (or Q) is not a command error
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Customizing Coc.nvim
" Mapping F2 to autocomplete 
inoremap <silent><expr> <F2> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<F2>\<c-r>=coc#enter()\<F2>"

command! Cd set autochdir
colorscheme onedark

autocmd VimLeave * silent set guicursor=a:ver10-blinkon1

" Customizing pear-tree
let g:pear_tree_pairs = {
            \ '(': {'closer': ')'},
            \ '[': {'closer': ']'},
            \ '{': {'closer': '}'},
            \ "'": {'closer': "'"},
            \ '"': {'closer': '"'},
            \ '/*': {'closer': '*/'},
            \ }
]])

-- Customizing Airline
if not fn.exists('g:airline_symbols') then
    g.airline_symbols = {}
end

g.airline_left_sep = ''
g.airline_left_alt_sep = ''
g.airline_right_sep = ''
g.airline_right_alt_sep = ''
g.airline_symbols["readonly"] = ''
g[ "airline#extensions#tabline#enabled" ] = 1
g[ "airline#extensions#tabline#left_sep" ] = ''
g[ "airline#extensions#tabline#left_alt_sep" ] = '' 
g[ "airline#extensions#whitespace#enabled" ] = 0

-- Remapping Ctrl-D to multi-select because of convenience and to avoid overlap with NERDTree shortcut
g.VM_maps = {}
g.VM_maps['Find Under'] = '<C-d>'
g.VM_maps['Find Subword Under'] = '<C-d>'

-- Configuring todo-comments.nvim
require("todo-comments").setup {
-- config here
}

-- Configuring treesitter
require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }

require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = { "c", "cpp", "css", "html" }
    }
}

-- Configuring Startify
g.startify_files_number = 5
g.startify_lists = {
    { type = "files", header = {"\t\tRecent files"} },
    { type = "files", header = { "\t\tRecent files" }},
    { type = "sessions", header = { "\t\tRecent sessions" }},
    { type = "commands", header = { "\t\tCommands" }}
}
g.startify_fortune_use_unicode = 1
g.startify_padding_left = 5
g.startify_custom_header = 'startify#pad(startify#fortune#cowsay())'

-- Keymaps
-- to fix Windows Terminal problems
key.set('n', '<leader>v', '<C-v>', { noremap = false })

-- Customizing NERDTree
key.set('n', '<leader>n', ':NERDTreeFocus<CR>', { noremap = true })
key.set('n', '<C-n>', ':NERDTree<CR>', { noremap = true })
key.set('n', '<C-t>', ':NERDTreeToggle<CR>', { noremap = true })
key.set('n', '<C-f>', ':NERDTreeFind<CR>', { noremap = true })

