local shared = require("nvim_shared")

return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "echasnovski/mini.pairs",
    version = "*",
    config = function()
      require("mini.pairs").setup()
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
  {
    "echasnovski/mini.cursorword",
    version = "*",
    config = function()
      require("mini.cursorword").setup()
    end,
  },
  {
    "echasnovski/mini.comment",
    version = "*",
    config = function()
      require("mini.comment").setup()
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    main = "guess-indent",
    opts = {},
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        filetype = {
          lua = { shared.formatters.stylua },
        },
      })
    end,
  },
}
