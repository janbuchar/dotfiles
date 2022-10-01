" Plugins
let g:nvcode_termcolors=256

call plug#begin(stdpath('data') . '/plugged')

Plug 'nvim-lua/plenary.nvim'

"" Editing/navigation stuff
Plug 'kylechui/nvim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'christoomey/vim-tmux-navigator'
Plug 'famiu/bufdelete.nvim'
Plug 'itchyny/vim-cursorword'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'kevinhwang91/rnvimr'

"" Sessions
Plug 'thaerkh/vim-workspace'

"" Statusline
Plug 'nvim-lualine/lualine.nvim'

"" Colors
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'ap/vim-css-color'

"" Git support
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

"" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'
Plug 'simrat39/rust-tools.nvim'

"" Completions
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'andersevenrud/cmp-tmux'
Plug 'ray-x/cmp-treesitter'

" Formatting
Plug 'mhartington/formatter.nvim'
call plug#end()

" Plugin management

let g:plugin_lock = '~/.config/nvim/plugin.lock'

command SnapshotPlugins
  \ execute 'PlugSnapshot! ' . g:plugin_lock

command SyncPlugins
  \ execute 'source ' . g:plugin_lock

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

if (has('nvim-0.8'))
	set cmdheight=0
endif

" File browser settings
let g:rnvimr_enable_bw = 1
let g:rnvimr_enable_picker = 1
let g:rnvimr_ranger_cmd = ['ranger', '--cmd="set vcs_aware true"']

" Autoreload
set autoread

" Completions
set completeopt=menu,menuone,noselect

" Key bindings

"" Space bar is the leader
let mapleader = " "

"" F10 to toggle paste mode
set pastetoggle=<F10>

"" Making splits
nnoremap <leader>- :split<cr>
nnoremap <leader><bar> :vsplit<cr>

nmap <silent> <C-h> :TmuxNavigateLeft<cr>

"" Switching buffers
nnoremap <silent> J :bprevious<CR>
nnoremap <silent> K :bnext<CR>

nnoremap gT <nop>
nmap <silent> gt :lua _G.buffers()<CR>

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
nmap <silent> <leader>r :FzfLua resume<CR>
nmap <silent> <leader>n <cmd>lua require("fzf-lua").git_files({cwd=vim.loop.cwd()})<CR>
nmap <silent> <leader>m :FzfLua git_status<CR>
nmap <silent> <leader>N :FzfLua files<CR>

nmap <silent> <leader>f :FormatWrite<CR>

nmap <silent> <leader>rn <Cmd>Lspsaga rename<CR>
nmap <silent> <leader>k <Cmd>Lspsaga hover_doc<CR>
nmap <silent> <leader>e <Cmd>Lspsaga show_line_diagnostics<CR>

nmap <silent> <leader>y :FzfLua lsp_live_workspace_symbols<CR>
nmap <silent> <leader>d :FzfLua diagnostics_document<CR>
nmap <silent> <leader>a :FzfLua lsp_code_actions<CR>

nmap <silent> gd :FzfLua lsp_definitions<CR>
nmap <silent> gy :FzfLua lsp_typedefs<CR>
nmap <silent> gi :FzfLua lsp_implementations<CR>
nmap <silent> gr :FzfLua lsp_references<CR>

" Formatting
lua << EOF
formatters = require("formatters")

require("formatter").setup({
  filetype = {
    lua = {formatters.luafmt}
  }
})
EOF
