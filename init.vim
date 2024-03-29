set guifont=Hasklug\ Nerd\ Font\ Mono:h11
set number
set cursorline
set cursorlineopt=both
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
set cmdheight=0
set timeoutlen=200
set autochdir
let mapleader = "\<Space>"
autocmd VimLeave * silent set guicursor=a:ver10-blinkon1

" Tab behavior
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab autoindent

" Setting the shell to powershell
let &shell = executable('pwsh.exe') ? 'pwsh' : 'powershell'
let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=

" Vim-Plug
" default plugin directory is ~/vimfiles/plugged  NOTE: not valid for neovim
call plug#begin()

Plug 'https://github.com/tpope/vim-commentary'
Plug 'http://github.com/tpope/vim-surround'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'navarasu/onedark.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'andweeb/presence.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'rcarriga/nvim-notify'
Plug 'vifm/vifm.vim'
Plug 'folke/which-key.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python -m chadtree deps'}
Plug 'tomasiser/vim-code-dark'
Plug 'nacro90/numb.nvim'
Plug 'xeluxee/competitest.nvim'
" Plug 'rebelot/heirline.nvim'
Plug 'arzg/vim-colors-xcode'

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
let g:codedark_italics = 1
let g:codedark_transparent = 0
colorscheme codedark
" augroup vim-colors-xcode
"     autocmd!
" augroup END
" autocmd vim-colors-xcode ColorScheme * hi Comment        cterm=italic gui=italic
" autocmd vim-colors-xcode ColorScheme * hi SpecialComment cterm=italic gui=italic

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
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#buffer_min_count = 2

" Changing warning and error icons
let airline#extensions#coc#warning_symbol = ''
let airline#extensions#coc#error_symbol = ''

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

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Mapping F2 in normal mode to see tooltip
nnoremap <silent> <F2> :call CocActionAsync('doHover')<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight hovered word
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remapping Ctrl-D to multi-select because of convenience and to avoid overlap
" with NERDTree shortcut
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>' " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'

" Mapping Space-e to open explorer
nnoremap <Space>e :!explorer .<CR>

" Remap <leader>v to visual block mode because Windows Terminal sees Ctrl-V as paste
nnoremap <leader>v <C-v>

" Enhancing copypasta
vnoremap <leader>y "+y
vnoremap <leader>p "+p
vnoremap <leader>x "_d
nnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>x "_d

" Getting rid of the stupid W (or Q) is not a command error
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
cnoreabbrev <expr> wQ ((getcmdtype() is# ':' && getcmdline() is# 'wQ')?('wq'):('wQ'))

" Mapping common window operations to Space
nnoremap <leader>c <C-w>c
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>d :bd<CR>

" Mapping C-s to save
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" Mapping Space-h to remove highlight
nnoremap <leader>g :noh<CR>

" Mapping Space-f to open init.vim
nnoremap <leader>f :e ~/AppData/Local/nvim/init.vim<CR>

" Mapping H and L to switch buffers
nnoremap H :bp<CR>
nnoremap L :bn<CR>

" Mapping C-c to run the file
nnoremap <C-c> :!run %<CR>
inoremap <C-c> <C-o>:!run %<CR>

" Mapping Space-s to open Startify
nnoremap <leader>s :Startify<CR>

" Mapping actions to carry lines
vnoremap <C-k> :m '<-2<CR>gv=gv
vnoremap <C-j> :m '>+1<CR>gv=gv
nnoremap <C-k> V:m '<-2<CR>V=<ESC>
nnoremap <C-j> V:m '>+1<CR>V=<ESC>

" Customizing Startify
"let g:startify_custom_header = startify#pad(split(system('figlet -w 100 "Welcome to Neovim"'), '\n'))
let g:startify_files_number = 10
let g:startify_lists = [
            \{"type": "files",    "header": ["\t\tRecent files"]},
            \{"type": "sessions", "header": ["\t\tRecent sessions"]},
            \{"type": "commands", "header": ["\t\tCommands"]}
            \]
let g:startify_fortune_use_unicode = 1
let g:startify_padding_left = 5
let g:startify_custom_header = 'startify#pad(startify#fortune#cowsay())'

" Customizing chadtree
nnoremap <leader>n :CHADopen<CR>
let g:chadtree_settings = {
            \'options.show_hidden' : v:true,
            \'ignore.name_exact' : [".DS_Store, .directory, thumbs.db", ".git", "desktop.ini"],
            \'view.width' : 20,
            \'theme.text_colour_set': "trapdoor",
            \'theme.icon_colour_set': "github",
            \}

" Lua configurations
lua require("init")
" lua require("hlconfig")
