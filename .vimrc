set nocompatible
set noswapfile
filetype plugin indent on

if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

set number
highlight LineNr ctermfg=white ctermbg=black

set confirm
set incsearch
set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full
set langmap=ě2,š3,č4,ř5,ž6,ý7,á8,í9,é0,\":,-/,_?

imap <C-h> <C-Left>
imap <C-j> <C-Down>
imap <C-k> <C-Up>
imap <C-l> <C-Right> 
set autoindent
set smartindent

