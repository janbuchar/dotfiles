local M = { formatters = {} }

M.create_lsp_config = function()
  return {
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }
end

M.formatters.prettier = function()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
  }
end

M.formatters.biome = function()
  return {
    exe = "biome",
    args = {
      "format",
      "--stdin-file-path",
      vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
  }
end

M.formatters.eslint = function()
  return {
    exe = "eslint",
    args = {
      "--fix",
      "--no-ignore",
      vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = false,
  }
end

M.formatters.black = function()
  return {
    exe = "black",
    args = { "-" },
    stdin = true,
  }
end

M.formatters.isort = function()
  return {
    exe = "isort",
    args = { "-" },
    stdin = true,
  }
end

M.formatters.ruff = function()
  return {
    exe = "ruff",
    args = { "format", "-q", "-" },
    stdin = true,
  }
end

M.formatters.stylua = function()
  return {
    exe = "stylua",
    args = {
      "-",
    },
    stdin = true,
  }
end

M.formatters.rustfmt = function()
  return {
    exe = "rustfmt",
    args = { "--edition", "2021" },
    stdin = true,
  }
end

return M
