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

vim.opt.cmdheight = 0

-- Autoreload
vim.opt.autoread = true

-- Keep buffers current even when the pane is out of focus. 
local checktime_timer = vim.uv.new_timer()
if checktime_timer then
  checktime_timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      -- Skip while editing the command line or in insert mode to avoid
      -- disrupting active typing; the autocommands above cover those moments.
      local mode = vim.fn.mode()
      if mode == "c" or mode:sub(1, 1) == "i" then
        return
      end
      vim.cmd("silent! checktime")
    end)
  )
end

-- Sessions
vim.o.sessionoptions =
  "buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"

-- Splits should be equal-sized
vim.opt.equalalways = true
vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("equal_splits", { clear = true }),
  callback = function()
    vim.cmd("wincmd =")
  end,
})
