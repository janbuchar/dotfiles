" Plugins
let g:ale_disable_lsp = 1
call plug#begin(stdpath('data') . '/plugged')

"" Editing/navigation stuff
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'moll/vim-bbye'

"" Sessions
Plug 'thaerkh/vim-workspace'

"" Lightline
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'maximbaz/lightline-ale'

"" Colors
Plug 'arcticicestudio/nord-vim'

"" Git support
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'

"" JS/TS + React
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

"" Python
Plug 'vim-python/python-syntax'

call plug#end()

" LSP plugins
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-python',
  \ 'coc-lists',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-cssmodules',
  \ ]

" Python for defx
let g:python3_host_prog = '/usr/bin/python'

" Python settings
let g:python_highlight_all = 1
autocmd FileType python let b:coc_root_patterns = ['pyproject.toml',  'requirements.txt', '.git', '.env']

call coc#config('python.pythonPath', $VIRTUAL_ENV . '/bin/python')
call coc#config('python.jediEnabled', '')

" coc.nvim  settings
call coc#config('diagnostic.displayByAle', '1')
call coc#config('list.source.files.excludePatterns', [
			\ '**/node_modules/**',
			\ '**/node_modules/**/.*', 
			\ '**/node_modules/**/.*/**',
			\ '**/build/**',
			\ '**/build/**/.*', 
			\ '**/build/**/.*/**',
			\])

" Colors
colorscheme nord

"" Defx cursor line
autocmd BufEnter * highlight CursorLine ctermbg=0
autocmd FileType defx setlocal cursorline
autocmd FileType defx highlight CursorLine ctermbg=8

" Autoreload
autocmd FocusGained,BufEnter * :silent! !
autocmd FocusGained,BufEnter * :silent! :GitGutter

" Gitgutter on YADM-managed files
autocmd BufEnter * :call s:yadm_init()
function! s:yadm_init() abort
	call system('yadm ls-files --error-unmatch ' . expand('%:p'))
	if v:shell_error == 0
		let g:gitgutter_git_args = '--git-dir=$HOME/.config/yadm/repo.git'
	endif
endfunction

" Disable history management in vim-workspace (when enabled, it created empty
" undo history items for some reason)
let g:workspace_persist_undo_history = 0
let g:workspace_autosave_untrailspaces = 0
let g:workspace_autosave_untrailtabs = 0

" Line numbers
set number
set relativenumber

" Local (per-project) .nvimrc files
set exrc
set secure

" Navigation
set cursorline
set scrolloff=10

" Backup files
set nobackup
set nowritebackup
set noswapfile

" Buffer settings
set hidden

"" Timeouts for better UX
set timeoutlen=1000
set ttimeoutlen=50
set updatetime=250

"" Lightline
set laststatus=2
set showtabline=2
set noshowmode

function! CocStatus()
	return substitute(get(g:, 'coc_status', ''), '(.* venv)', '(venv)', '')
endfunction

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'mode_map': {
      \   'n' : 'N',
      \   'i' : 'I',
      \   'R' : 'R',
      \   'v' : 'V',
      \   'V' : 'VL',
      \   "\<C-v>": 'VB',
      \   'c' : 'C',
      \   's' : 'S',
      \   'S' : 'SL',
      \   "\<C-s>": 'SB',
      \   't': 'T',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [
      \     [ 'cocstatus', 'fileencoding', 'filetype', 'percent' ],
      \     [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos' ],
      \   ]
      \ },
      \ 'inactive': {
      \   'right': [ [ 'percent' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_infos': 'lightline#ale#infos',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel',
      \   'linter_checking': 'right',
      \   'linter_infos': 'right',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'right',
      \ },
      \ 'component_function': {
      \   'cocstatus': 'CocStatus',
      \ },
      \ 'tabline_subseparator': {'left': '', 'right': ''}
      \ }
let g:lightline#bufferline#show_number = 2

" Key bindings

"" Space bar is the leader
let mapleader = " "

"" F10 to toggle paste mode
set pastetoggle=<F10>

"" CZ keyboard adaptation
""" Number keys
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

""" Search
nnoremap - /

""" ftFT next match
nnoremap ů ;

"" Making splits
nnoremap <leader>- :split<cr>
nnoremap <leader><bar> :vsplit<cr>

"" Switching buffers
nnoremap <silent> J :bprevious<CR>
nnoremap <silent> K :bnext<CR>

"" Join/Split lines
nnoremap <leader>j J
nnoremap <leader>s i<CR><ESC>

"" File browser
nnoremap <silent> <leader>t :Defx `expand('.')` -columns=indent:git:filename:type -search=`expand('%:p')` -split=floating -wincol=0 -winrow=1 -winwidth=50 -winheight=`&lines - 3` -toggle=1 -buffer-name=defx<CR>

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
	nnoremap <silent><buffer><expr> o
		\ defx#is_directory() ?
		\ defx#do_action('open_or_close_tree') :
		\ defx#do_action('multi', ['drop', 'quit'])
	nnoremap <silent><buffer><expr> <CR>
		\ defx#is_directory() ?
		\ defx#do_action('open_or_close_tree') :
		\ defx#do_action('multi', ['drop', 'quit'])
	nnoremap <silent><buffer><expr> h
		\ defx#do_action('search', fnamemodify(defx#get_candidate().action__path, ':h'))
	nnoremap <silent><buffer><expr> q
		\ defx#do_action('quit')
	nnoremap <silent><buffer><expr> <C-n>
		\ defx#do_action('new_file')
	nnoremap <silent><buffer><expr> <C-f>
		\ defx#do_action('new_directory')
	nnoremap <silent><buffer><expr> dd
		\ defx#do_action('remove')
	nnoremap <silent><buffer><expr> cc
		\ defx#do_action('rename')
endfunction

"" Start/end of line
nnoremap gh ^
vnoremap gh ^
nnoremap gl $
vnoremap gl $

"" Cancel highlight
nnoremap <Esc> :noh<CR>

"" Close buffer
nnoremap <leader>q :Bdelete<CR>

"" IDE actions
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>do <Plug>(coc-codeaction)
nmap <silent> <leader>k :call CocAction('doHover')<CR>
nmap <silent> <leader>y :CocList symbols<CR>
nmap <silent> <leader>n :CocList files<CR>
nmap <silent> <leader>f <Plug>(ale_fix)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"" Browse completion lists with Tab
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"" Accept completion with Enter
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

"" Accept first completion on text with Ctrl+space
inoremap <silent><expr> <c-space> pumvisible() ? coc#_select_confirm() : coc#refresh()

