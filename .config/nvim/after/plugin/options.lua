-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Local (per-project) .nvimrc files
vim.opt.exrc = true
vim.opt.secure = true

-- Navigation
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.mouse = "a"

-- Backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Buffer settings
vim.opt.hidden = true

-- Timeouts for better UX
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 50
vim.opt.updatetime = 250

if vim.fn.has("nvim-0.8") then
  vim.opt.cmdheight = 0
end

-- Autoreload
vim.opt.autoread = true

-- Completions
vim.opt.completeopt = "menu,menuone,noselect"

-- Sessions
vim.o.sessionoptions =
  "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Splits should be equal-sized
vim.opt.equalalways = true
vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("equal_splits", { clear = true }),
  callback = function()
    vim.cmd("wincmd =")
  end,
})
