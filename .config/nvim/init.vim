" Plugins
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

"" Colors
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': ':TSUpdate'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'ap/vim-css-color'

"" Git support
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'josa42/nvim-lightline-lsp'
Plug 'gfanto/fzf-lsp.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'glepnir/lspsaga.nvim'

" Formatting
Plug 'mhartington/formatter.nvim'
call plug#end()

" Plugin management

let g:plugin_lock = '~/.config/nvim/plugin.lock'

command UpdatePlugins
  \ PlugUpdate | execute 'PlugSnapshot!' . g:plugin_lock

command SnapshotPlugins
  \ execute 'PlugSnapshot!' . g:plugin_lock

command SyncPlugins
  \ source g:plugin_lock


" Python for defx
let g:python3_host_prog = '/usr/bin/python'

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

" Completion options
set completeopt=menuone,noselect

" Autoreload
set autoread

" Lightline
function! WDRelativeFilename()
	return expand('%')
endfunction

function! LspDiagnosticCount(label, type)
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    let count = luaeval('vim.lsp.diagnostic.get_count(0, "' . a:type . '")')
    if (count > 0)
      return a:label . ': ' . count
    else
      return ''
    end
  else
    return ''
  end
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
	\     [ 'lsp_status', 'fileencoding', 'filetype', 'percent' ],
	\     [ 'lsp_errors', 'lsp_warnings', 'lsp_infos', 'lsp_hints' ],
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
	\   'lsp_errors': 'lightline#lsp#errors',
	\   'lsp_warnings': 'lightline#lsp#warnings',
	\   'lsp_infos': 'lightline#lsp#info',
	\   'lsp_hints': 'lightline#lsp#hints',
	\   'lsp_status': 'lightline#lsp#status',
	\ },
	\ 'component_type': {
	\   'buffers': 'tabsel',
        \   'lsp_errors': 'error',
        \   'lsp_warnings': 'warning',
        \   'lsp_infos': 'middle',
        \   'lsp_hints': 'middle',
	\ },
	\ 'component_function': {
	\   'filename': 'WDRelativeFilename',
	\ },
	\ 'tabline_subseparator': {'left': '', 'right': ''}
	\ }

let g:lightline#bufferline#show_number = 2
let g:lightline#lsp#indicator_errors = 'E: '
let g:lightline#lsp#indicator_warnings = 'W: '
let g:lightline#lsp#indicator_info = 'I: '
let g:lightline#lsp#indicator_hints = 'H: '

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
nmap <silent> <leader>rn <Cmd>Lspsaga rename<CR>
nmap <silent> <leader>a :CodeActions<CR>
vmap <silent> <leader>a :<C-U>RangeCodeActions<CR>
nmap <silent> <leader>k <Cmd>Lspsaga hover_doc<CR>
nmap <silent> <leader>d <Cmd>Lspsaga show_line_diagnostics<CR>
nmap <silent> <leader>y :WorkspaceSymbols<CR>
nmap <silent> <leader>n :call fzf#run(fzf#wrap(fzf#vim#with_preview({'source': 'ag -g ""', 'options': ['--prompt', 'Files> ']})))<CR>
nmap <silent> <leader>N :Files<CR>
nmap <silent> <leader>f :FormatWrite<CR>
nmap <silent> <leader>d :Diagnostics<CR>
nmap <silent> gd :Definitions<CR>
nmap <silent> gy :TypeDefinitions<CR>
nmap <silent> gi :Implementations<CR>
nmap <silent> gr :References<CR>

"" Code completion menu
inoremap <silent><expr> <C-Space> pumvisible() ? compe#confirm({'keys': '<CR>', 'select': v:true}) : compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({'keys': '<CR>', 'select': v:true})
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

""" Browse completions with TAB
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ compe#complete()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Formatting
lua << EOF
formatters = require("formatters")

require("formatter").setup({
  filetype = {
    lua = {formatters.luafmt}
  }
})
EOF
