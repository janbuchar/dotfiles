local shared = require("nvim_shared")

return {
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      "simrat39/rust-tools.nvim",
      "pmizio/typescript-tools.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local config = shared.create_lsp_config()

      require("rust-tools").setup({
        server = {
          on_attach = config.on_attach,
        },
      })

      require("typescript-tools").setup({ on_attach = config.on_attach })

      local nvim_lsp = require("lspconfig")
      nvim_lsp.basedpyright.setup(config)
      nvim_lsp.jsonls.setup(config)
      nvim_lsp.cssls.setup(config)
      nvim_lsp.dockerls.setup(config)
      nvim_lsp.lua_ls.setup(config)
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
