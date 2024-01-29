vim.api.nvim_create_user_command("Envrc", ":edit $DIRENV_FILE", {nargs = 0})

vim.api.nvim_create_autocmd(
  {"BufNewFile", "BufRead"},
  {
    group = vim.api.nvim_create_augroup("envrc_syntax", {clear = true}),
    pattern = "*.envrc",
    callback = function()
      vim.opt.syntax = "sh"
    end
  }
)
