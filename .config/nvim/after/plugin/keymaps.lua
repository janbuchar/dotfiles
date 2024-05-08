local map = vim.keymap.set

-- Making splits
map("n", "<leader>-", "<cmd>split<cr>")
map("n", "<leader><bar>", "<cmd>vsplit<cr>")

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", {silent = true})

-- Switching buffers
map("n", "J", "<Plug>(cokeline-focus-prev)", {silent = true})
map("n", "K", "<Plug>(cokeline-focus-next)", {silent = true})

map("n", "gT", "<nop>")
map(
  "n",
  "gt",
  function()
    _G.buffers()
  end,
  {silent = true}
)

-- Open commandline
map("n", "<leader><leader>", ":")

-- Join/Split lines
map("n", "gj", "J")
map("n", "gs", "i<CR><ESC>")

-- Folds
map("n", "<TAB>", "za")

-- File browser
map("n", "<leader>t", "<cmd>RnvimrToggle<cr>", {silent = true})
map("t", "<esc>", "<cmd>RnvimrToggle<cr>", {silent = true})

-- Start/end of line
map({"n", "v"}, "gh", "^")
map({"n", "v"}, "gl", "$")

-- Cancel highlight
map("n", "<Esc>", "<cmd>noh<CR>", {silent = true})

-- IDE actions
map("n", "<leader>r", "<cmd>FzfLua resume<cr>", {silent = true})
map(
  "n",
  "<leader>n",
  function()
    require("fzf-lua").git_files({cwd = vim.loop.cwd()})
  end,
  {silent = true}
)
map("n", "<leader>m", "<cmd>FzfLua git_status<cr>", {silent = true})
map("n", "<leader>N", "<cmd>FzfLua files<cr>", {silent = true})

map("n", "<leader>f", "<cmd>FormatWrite<cr>", {silent = true})
map(
  {"n", "v"},
  "<leader>c",
  function()
    require("refactoring").select_refactor()
  end,
  {silent = true}
)

map("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", {silent = true})
map("n", "<leader>k", "<cmd>Lspsaga hover_doc<cr>", {silent = true})
map("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<cr>", {silent = true})

map("n", "<leader>y", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", {silent = true})
map("n", "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", {silent = true})
map("n", "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", {silent = true})
map("n", "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>", {silent = true})
map("n", "<leader>l", "<cmd>FzfLua git_commits<cr>", {silent = true})
map("n", "<leader>M", function() _G.macros() end, {silent = true})

map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", {silent = true})
map("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", {silent = true})
map("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", {silent = true})
map("n", "gr", "<cmd>FzfLua lsp_references<cr>", {silent = true})
