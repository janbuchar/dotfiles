require("aerial").setup(
  {
    on_attach = function(bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>AerialToggle right<CR>", {})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
    end
  }
)
