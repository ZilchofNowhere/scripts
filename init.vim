set number
set linebreak
set shell=pwsh.exe
set relativenumber
set scrolloff=5
set ignorecase
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp1252,default,latin9
set mouse=a
set termguicolors
set foldmethod=syntax
set nofoldenable
set foldnestmax=10
set foldlevel=2
set signcolumn=auto
set timeoutlen=200
let mapleader = "\<Space>"
autocmd VimLeave * silent set guicursor=a:ver10-blinkon1

" Tab behavior
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab autoindent

" Setting the shell to powershell
let &shell = executable('pwsh.exe') ? 'pwsh.exe' : 'powershell'
let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=

" Vim-Plug
" default plugin directory is ~/vimfiles/plugged
call plug#begin()

Plug 'https://github.com/tpope/vim-commentary' 
Plug 'http://github.com/tpope/vim-surround'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'navarasu/onedark.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'andweeb/presence.nvim' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim' 
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'rcarriga/nvim-notify'
Plug 'folke/which-key.nvim'      
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'windwp/nvim-autopairs'

" Always set as the last one
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

call plug#end()

let g:indent_blankline_filetype_exclude = [                                                                
            \"lspinfo",                                                            
            \"packer",                                                             
            \"checkhealth",                                                        
            \"help",                                                               
            \"man",                                                                
            \"",                                                                   
            \"startify",
            \"Plugins"
        \] 

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

" Customizing Coc.nvim
" Mapping F2 in insert mode to autocomplete 
inoremap <silent><expr> <F2> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<F2>\<c-r>=coc#enter()\<F2>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Mapping F2 in normal mode to see tooltip
nnoremap <silent> <F2> :call CocActionAsync('doHover')<CR>

" Highlight hovered word
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remapping Ctrl-D to multi-select because of convenience and to avoid overlap
" with NERDTree shortcut 
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>' " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'

" Customizing NERDTree
nnoremap <leader>n :NeoTreeFocusToggle<CR>
nnoremap <C-n> :Neotree<CR>
nnoremap <C-t> :NeoTreeShowToggle<CR>
nnoremap <C-f> :NeoTreeFind<CR>

" Mapping Space-e to open explorer
nnoremap <Space>e :!explorer .<CR>
" Remap <leader>n to visual block mode because Windows Terminal sees Ctrl-V as paste
nnoremap <leader>v <C-v> 

" Getting rid of the stupid W (or Q) is not a command error
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

" Aliasing `set autochdir` to 'Cd'
command Cd set autochdir 

" Mapping Space-c to C-w C
nnoremap <leader>c <C-w>c 

" Mapping C-a to select all
nnoremap <C-a> ggVG

" Mapping C-c to copy to system clipboard
vnoremap <C-c> "+y

" Mapping C-s to save
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" Mapping Space-h to remove highlight
nnoremap <leader>h :noh<CR>
vnoremap <leader>h :noh<CR>

" Mapping H and L to switch buffers
nnoremap H :bp<CR>
nnoremap L :bn<CR>

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

" Lua configurations
lua << EOF

require("todo-comments").setup() 

-- Configuring treesitter
require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }

require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = { "c", "cpp", "css", "html" }
    }
    }

require "neo-tree".setup {
    close_if_last_window = true,
    filesystem = {
        filtered_items = {
            visible = true,
            never_show = {
                "desktop.ini"
            }
            }
        }
    }

require("which-key").setup()

require("nvim-autopairs").setup {
  enable_check_bracket_line = false
}

EOF

" Neovide configuration
if exists("g:neovide")
    set guifont=RecMonoCustom\ NF:h12
    let g:neovide_remember_window_size = v:true
endif
