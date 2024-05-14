local shared = require("nvim_shared")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {"simrat39/rust-tools.nvim", "folke/neodev.nvim", "hrsh7th/cmp-nvim-lsp"},
    config = function()
      require("neodev").setup(
        {
          override = function(root_dir, library)
            if vim.fn.filereadable(root_dir .. "/.nvim.lua") then
              library.enabled = true
              library.plugins = true
            end
          end
        }
      )

      local nvim_lsp = require("lspconfig")
      local rt = require("rust-tools")

      local config = shared.create_lsp_config()

      rt.setup(
        {
          server = {
            on_attach = config.on_attach
          }
        }
      )

      nvim_lsp.tsserver.setup(config)
      nvim_lsp.basedpyright.setup(config)
      nvim_lsp.jsonls.setup(config)
      nvim_lsp.cssls.setup(config)
      nvim_lsp.dockerls.setup(config)
      nvim_lsp.lua_ls.setup(config)
    end
  }
}
