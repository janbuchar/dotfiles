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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
      local autotag = require("nvim-ts-autotag")
      autotag.setup()

      local npairs = require("nvim-autopairs")

      npairs.setup({})

      _G.MUtils = {}

      MUtils.completion_confirm = function()
        return npairs.autopairs_cr()
      end

      vim.keymap.set(
        "i",
        "<CR>",
        "v:lua.MUtils.completion_confirm()",
        { expr = true, noremap = true }
      )
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
  { "itchyny/vim-cursorword" },
  {
    "numToStr/Comment.nvim",
    opts = {},
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
