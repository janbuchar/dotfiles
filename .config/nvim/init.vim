" Plugins
let g:ale_disable_lsp = 1
let g:ale_lint_delay = 250
let g:nvcode_termcolors=256

call plug#begin(stdpath('data') . '/plugged')

"" Editing/navigation stuff
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'christoomey/vim-tmux-navigator'
Plug 'moll/vim-bbye'
Plug 'itchyny/vim-cursorword'
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'kevinhwang91/rnvimr'

"" Sessions
Plug 'thaerkh/vim-workspace'

"" Lightline
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'maximbaz/lightline-ale'

"" Colors
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': ':TSUpdate'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'ap/vim-css-color'

"" Git support
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'
Plug 'dense-analysis/ale'

call plug#end()

" Plugin management

let g:plugin_lock = '~/.config/nvim/plugin.lock'

command UpdatePlugins
  \ PlugUpdate | execute 'PlugSnapshot!' . g:plugin_lock

command SyncPlugins
  \ source g:plugin_lock


" LSP plugins
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-pyright',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-cssmodules',
  \ 'coc-docker',
  \ ]

" Python for defx
let g:python3_host_prog = '/usr/bin/python'

" Python settings
let g:python_highlight_all = 1
augroup python_settings
	autocmd!
	autocmd FileType python let b:coc_root_patterns = ['pyproject.toml',  'requirements.txt', '.git', '.env']
augroup end

call coc#config('python.pythonPath', $VIRTUAL_ENV . '/bin/python')
call coc#config('python.jediEnabled', '')

" coc.nvim settings
call coc#config('diagnostic.displayByAle', '1')

" configure treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "all",
	highlight = {
		enable = true,
	},
}
EOF

" checks if your terminal has 24-bit color support
if (has("termguicolors"))
	set termguicolors
	hi LineNr ctermbg=NONE guibg=NONE
endif

" Colors
colorscheme nord

" Gitgutter on YADM-managed files
augroup yadm_gitgutter
	autocmd!
	autocmd BufNewFile,BufRead * :call s:yadm_init()
augroup end
function! s:yadm_init() abort
	call system('yadm ls-files --error-unmatch ' . expand('%:p'))
	if v:shell_error == 0
		let g:gitgutter_git_args = '--git-dir=$HOME/.config/yadm/repo.git'
	endif
endfunction

" .envrc syntax
augroup envrc_syntax
	autocmd!
	autocmd BufNewFile,BufRead *.envrc set syntax=sh
augroup end

" Splits should be equal-sized
set equalalways
augroup equal_splits
	autocmd!
	autocmd VimResized * wincmd =
augroup end

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
set mouse=a

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

" File browser settings
let g:rnvimr_enable_bw = 1
let g:rnvimr_enable_picker = 1
let g:rnvimr_ranger_cmd = 'ranger --cmd="set vcs_aware true"'

" Autoreload
set autoread

function! CocStatus()
	return substitute(get(g:, 'coc_status', ''), '(.* venv)', '(venv)', '')
endfunction

function! WDRelativeFilename()
	return expand('%')
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
	\   'filename': 'WDRelativeFilename'
	\ },
	\ 'tabline_subseparator': {'left': '', 'right': ''}
	\ }
let g:lightline#bufferline#show_number = 2

" Key bindings

"" Space bar is the leader
let mapleader = " "

"" F10 to toggle paste mode
set pastetoggle=<F10>

"" Making splits
nnoremap <leader>- :split<cr>
nnoremap <leader><bar> :vsplit<cr>

"" Switching buffers
nnoremap <silent> J :bprevious<CR>
nnoremap <silent> K :bnext<CR>

function Bufnumbers() abort
	return filter(range(1, bufnr('$')), {k, v -> bufexists(v) && buflisted(v) && !(getbufvar(v, '&filetype') ==# 'qf')})
endfunction

nnoremap gT <nop>
nmap gt :Buffers<CR>
nmap <silent> gt :call fzf#run(fzf#wrap({
	\ 'source': map(Bufnumbers(), {k, v -> printf('[%s] %s', lightline#bufferline#get_ordinal_number_for_buffer(v), bufname(v))}),
	\ 'sink': {line -> lightline#bufferline#go(substitute(line, '^\[\([0-9]*\)\].*', '\1', ''))},
	\ 'options': ['--prompt', 'Buffers> ', '--preview', stdpath('data') . '/plugged/fzf.vim/bin/preview.sh $(echo {} \| cut -d" " -f 2-)']}
	\ ))<CR>

"" Join/Split lines
nnoremap gj J
nnoremap gs i<CR><ESC>

"" File browser
nnoremap <silent> <leader>t :RnvimrToggle<CR>
tnoremap <silent> <M-o> <C-\><C-n>:RnvimrToggle<CR>

"" Start/end of line
nnoremap gh ^
vnoremap gh ^
nnoremap gl $
vnoremap gl $

"" Cancel highlight
nnoremap <silent> <Esc> :noh<CR>

"" Close buffer
nnoremap <silent> <leader>q :Bdelete<CR>

"" IDE actions
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>a <Plug>(coc-codeaction-selected)
vmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent> <leader>do <Plug>(coc-codeaction)
nmap <silent> <leader>k :call CocAction('doHover')<CR>
nmap <silent> <leader>y :CocFzfList symbols<CR>
nmap <silent> <leader>n :call fzf#run(fzf#wrap(fzf#vim#with_preview({'source': 'ag -g ""', 'options': ['--prompt', 'Files> ']})))<CR>
nmap <silent> <leader>N :Files<CR>
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

