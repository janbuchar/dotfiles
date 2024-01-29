return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      yadm = {enable = true},
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function bufmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        bufmap(
          "n",
          "]c",
          function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(
              function()
                gs.next_hunk()
              end
            )
            return "<Ignore>"
          end,
          {expr = true}
        )

        bufmap(
          "n",
          "[c",
          function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(
              function()
                gs.prev_hunk()
              end
            )
            return "<Ignore>"
          end,
          {expr = true}
        )

        -- Actions
        bufmap({"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>")
        bufmap({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
        bufmap("n", "<leader>hS", gs.stage_buffer)
        bufmap("n", "<leader>hu", gs.reset_hunk)
        bufmap("n", "<leader>hR", gs.reset_buffer)
        bufmap("n", "<leader>hp", gs.preview_hunk)
        bufmap(
          "n",
          "<leader>hb",
          function()
            gs.blame_line {full = true}
          end
        )
        bufmap("n", "<leader>bt", gs.toggle_current_line_blame)
        bufmap("n", "<leader>hd", gs.diffthis)
        bufmap(
          "n",
          "<leader>hD",
          function()
            gs.diffthis("~")
          end
        )
        bufmap("n", "<leader>dt", gs.toggle_deleted)

        -- Text object
        bufmap({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end
    }
  },
  {
    "tpope/vim-fugitive"
  }
}
