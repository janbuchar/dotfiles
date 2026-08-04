return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "purarue/gitsigns-yadm.nvim" },
    opts = {
      _on_attach_pre = function(_, callback)
        require("gitsigns-yadm").yadm_signs(callback)
      end,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function bufmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        bufmap("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        bufmap("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        bufmap({ "n", "v" }, "<leader>hs", gs.stage_hunk)
        bufmap({ "n", "v" }, "<leader>hr", gs.reset_hunk)
        bufmap("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        bufmap("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        bufmap("n", "<leader>hS", gs.stage_buffer)
        bufmap("n", "<leader>hu", gs.reset_hunk)
        bufmap("n", "<leader>hR", gs.reset_buffer)
        -- Hunk preview, upgraded. difftsigns shows the same familiar layout
        -- (removed lines, then added) but additionally highlights the exact
        -- tokens that changed and dims the lines that were only reformatted,
        -- with a header quantifying the split. Falls back to gitsigns' own
        -- preview if difftsigns is unavailable (e.g. in vscode).
        bufmap("n", "<leader>hp", function()
          local ok, difftsigns = pcall(require, "difftsigns")
          if ok and difftsigns.preview() ~= nil then
            return
          end
          gs.preview_hunk()
        end, { desc = "preview hunk (structural)" })

        -- The plain gitsigns preview, kept as an escape hatch.
        bufmap("n", "<leader>hP", gs.preview_hunk, { desc = "preview hunk (line-based)" })
        bufmap("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end)
        bufmap("n", "<leader>bt", gs.toggle_current_line_blame)
        bufmap("n", "<leader>hd", gs.diffthis)
        bufmap("n", "<leader>hD", function()
          gs.diffthis("~")
        end)
        bufmap("n", "<leader>dt", gs.toggle_deleted)

        bufmap("n", "<leader>xb", "<Cmd>GitBase<CR>", { desc = "git: diff vs default branch (merge base)" })
        bufmap("n", "<leader>xH", "<Cmd>GitBase HEAD<CR>", { desc = "git: diff vs HEAD" })
        bufmap("n", "<leader>xI", "<Cmd>GitBase!<CR>", { desc = "git: diff vs index (reset)" })

        -- Text object
        bufmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      -- gitsigns is a *consumer* of the base store (lua/gitbase.lua), never its
      -- owner. Traffic runs both ways:
      --
      --   in:  when the base changes, push it into gitsigns. `global = true` so it
      --        covers every buffer *and* every buffer opened later; the buffer-local
      --        default would leave the rest of the session quietly comparing against
      --        the index. difftsigns comes along for free, as it borrows gitsigns'
      --        base revision.
      --   out: gitsigns is already the thing tracking HEAD, which makes it the
      --        natural place to notice a rebase or a branch switch and ask the store
      --        to re-resolve.
      local gitbase = require("gitbase")
      local group = vim.api.nvim_create_augroup("gitbase_gitsigns", { clear = true })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitBaseChanged",
        group = group,
        callback = function(args)
          require("gitsigns").change_base(args.data.base, true)
        end,
      })

      -- change_base re-enters this via GitSignsUpdate, but last_head is already
      -- current by then, so it settles after one extra pass rather than looping.
      local last_head
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitSignsUpdate",
        group = group,
        callback = function()
          if vim.g.gitsigns_head == last_head then
            return
          end
          last_head = vim.g.gitsigns_head
          gitbase.refresh()
        end,
      })
    end,
  },
  {
    "tpope/vim-fugitive",
  },
}
