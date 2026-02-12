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
  {
    "yarospace/dev-tools.nvim",
    opts = {
      actions = {
        {
          name = "Open in browser",
          fn = function(action)
            local ctx = action.ctx

            local line_start = ctx.row + 1
            local line_end = ctx.row + 1

            if ctx.range ~= nil then
              line_end = ctx.range["end"].line + 1
            end

            Snacks.gitbrowse.open({
              line_start = line_start,
              line_end = line_end,
            })
          end,
        },
      },
    },
  },
}
