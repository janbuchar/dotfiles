runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set nocompatible
set noswapfile
set timeoutlen=50
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
set hidden

set autoindent
set smartindent

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au FileType markdown set tw=80
au FileType markdown set expandtab

let g:pandoc#modules#disabled = ["folding", "spell"]
let g:pandoc#formatting#mode = "ha"
let g:pandoc#formatting#textwidth = 80

let g:airline#extensions#whitespace#enabled = 0

set noruler
set showcmd
set laststatus=2
set noshowmode
let g:cscope_silent = 1

""" Key bindings

"" Basic shortcuts
nnoremap - /
nnoremap ! :!
set pastetoggle=<F10>
let g:AutoPairsShortcutJump = '<C-e>'
let mapleader = "," 

"" Cscope bindings

nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>

" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>

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
