return {
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      "pmizio/typescript-tools.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.lsp.config("*", {
        on_attach = function(client, bufnr)
          client.server_capabilities.document_formatting = false
        end,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.enable({
        "basedpyright",
        "ts_ls",
        "jsonls",
        "cssls",
        "dockerls",
        "lua_ls",
        "yamlls",
      })

      -- require("typescript-tools").setup({ on_attach = config.on_attach })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      enabled = true,
    },
  },
}
