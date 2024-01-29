if (vim.fn.has("termguicolors")) then
  vim.opt.termguicolors = true
  vim.cmd("hi LineNr ctermbg=NONE guibg=NONE")
end

vim.cmd "colorscheme nordfox"
