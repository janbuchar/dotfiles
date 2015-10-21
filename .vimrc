set nocompatible
set noswapfile
filetype plugin indent on

if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

set number
colorscheme elflord
highlight LineNr ctermfg=white ctermbg=black

set confirm
set incsearch
set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full

nmap - /

set autoindent
set smartindent
set pastetoggle=<F10>

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au FileType markdown set tw=80
au FileType markdown set expandtab

