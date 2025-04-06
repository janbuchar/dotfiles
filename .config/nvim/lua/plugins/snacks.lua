return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      indent = {
        scope = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<leader>q",
        function()
          if not vim.g.vscode then
            Snacks.bufdelete()
          end
        end,
      },
    },
  },
}
