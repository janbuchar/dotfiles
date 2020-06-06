let mapleader = " " 

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

runtime airline_theme.vim

set nocompatible
set noswapfile

set timeoutlen=500
set ttimeoutlen=50
set updatetime=250

filetype plugin indent on

if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

set relativenumber
set number
colorscheme elflord
highlight LineNr ctermfg=white ctermbg=black

set confirm
set incsearch
set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full
set hidden

set autoindent
set smartindent

let g:pandoc#modules#disabled = ["folding", "spell"]
let g:pandoc#formatting#mode = "ha"
let g:pandoc#formatting#textwidth = 80

let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 0
let g:airline_theme = "teyras"
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = ''

set noruler
set showcmd
set laststatus=2
set noshowmode
let g:cscope_silent = 1

" neocomplete support
"let g:neocomplete#enable_at_startup = 1

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif

autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*'

""" Key bindings

"" Number keys
nnoremap + 1
vnoremap + 1
nnoremap ě 2
vnoremap ě 2
nnoremap š 3
vnoremap š 3
nnoremap č 4
vnoremap č 4
nnoremap ř 5
vnoremap ř 5
nnoremap ž 6
vnoremap ž 6
nnoremap ý 7
vnoremap ý 7
nnoremap á 8
vnoremap á 8
nnoremap í 9
vnoremap í 9
nnoremap é 0
vnoremap é 0

"" Basic shortcuts

" Search (cz keyboard)
nnoremap - /

" ftFT next match (cz keyboard)
nnoremap ů ;

" Run shell command
nnoremap ! :!

" Start/end of line
nnoremap gh ^
vnoremap gh ^
nnoremap gl $
vnoremap gl $

" Moving between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set pastetoggle=<F10>
let g:AutoPairsShortcutJump = '<C-e>'

" Format paragraph
nnoremap <leader>f gwip

"" Git commands
nnoremap <leader>c :Gcommit -a<cr>
nnoremap <leader>p :Gpush<cr>
nnoremap <leader>P :Gpull<cr>

nnoremap <Esc> :noh<cr>

" Wrap CtrlP so that it searches for the project VCS root, but doesn't try to
" index the home (or root) directory

function GetWorkingPath(cwd)
	let path = a:cwd

	while path != $HOME && path != "/"
		echo path
		if isdirectory(path . "/.git")
			return path
		endif

		let path = simplify(path . "/..")
	endwhile

	return a:cwd
endfunction

function CtrlPWrapper()
	execute 'CtrlP' GetWorkingPath(getcwd())
endfunction

let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_map = '<nop>'
nnoremap <c-p> :call CtrlPWrapper()<cr>

