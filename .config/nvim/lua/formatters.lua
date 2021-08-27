local M = {}

M.prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
    stdin = true
  }
end

M.eslint = function()
  return {
    exe = "eslint",
    args = {"--fix", "--no-ignore", "--stdin-filename", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
    stdin = false
  }
end

M.black = function()
  return {
    exe = "black",
    args = {"-"},
    stdin = true
  }
end

M.isort = function()
  return {
    exe = "isort",
    args = {"-"},
    stdin = true
  }
end

M.luafmt = function()
  return {
    exe = "luafmt",
    args = {"--indent-count", 2, "--stdin"},
    stdin = true
  }
end

return M
