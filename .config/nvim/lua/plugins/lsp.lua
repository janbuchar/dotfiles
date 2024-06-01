local shared = require("nvim_shared")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local nvim_lsp = require("lspconfig")
      local rt = require("rust-tools")

      local config = shared.create_lsp_config()

      rt.setup({
        server = {
          on_attach = config.on_attach,
        },
      })

      nvim_lsp.tsserver.setup(config)
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
