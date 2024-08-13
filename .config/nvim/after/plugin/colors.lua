if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
  vim.cmd("hi LineNr ctermbg=NONE guibg=NONE")
end

if not vim.g.vscode then
  vim.cmd("colorscheme nordfox")
end
