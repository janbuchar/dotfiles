return {
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    config = function()
      vim.lsp.enable({
        "basedpyright",
        "ts_ls",
        "jsonls",
        "cssls",
        "dockerls",
        "lua_ls",
        "yamlls",
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    -- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
    -- No need for lazy.nvim to lazy-load it.
    lazy = false,
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
