return {
  {
    "EdenEast/nightfox.nvim",
    enabled = not vim.g.vscode
  },
  {
    "rmagatti/auto-session",
    enabled = not vim.g.vscode,
    opts = {
      auto_session_create_enabled = false
    }
  },
  {
    "https://git.sr.ht/~nedia/auto-save.nvim",
    enabled = not vim.g.vscode,
    event = {"BufReadPre"},
    opts = {
      events = {"InsertLeave", "BufLeave", "TextChanged"},
      save_fn = function()
        -- If there is a session, we autosave - like vim-workspace did
        if (require("auto-session.lib").current_session_name ~= nil) then
          vim.cmd("silent! w")
        end
      end
    }
  },
  {
    "stevearc/aerial.nvim",
    enabled = not vim.g.vscode,
    opts = {
      on_attach = function(bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>AerialToggle right<CR>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
      end
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    }
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>t",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager"
      }
    },
    ---@type YaziConfig
    opts = {
      open_for_directories = false,
      floating_window_scaling_factor = 0.75,
      yazi_floating_window_winblend = 10
    }
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {"kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter"},
    enabled = not vim.g.vscode,
    init = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("ufo").setup(
        {
          provider_selector = function(bufnr, filetype, buftype)
            return {"treesitter", "indent"}
          end,
          fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" ⋯ %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
              local chunkText = chunk[1]
              local chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
              else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, {chunkText, hlGroup})
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if curWidth + chunkWidth < targetWidth then
                  suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                end
                break
              end
              curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, {suffix, "MoreMsg"})
            return newVirtText
          end
        }
      )
    end
  },
  {
    "christoomey/vim-tmux-navigator",
    enabled = not vim.g.vscode,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious"
    },
    keys = {
      {"<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>"},
      {"<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>"},
      {"<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>"},
      {"<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>"},
      {"<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>"}
    }
  },
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup(
        {
          ui = {
            border = "rounded"
          },
          lightbulb = {
            enable = false
          },
          symbol_in_winbar = {
            enable = false
          }
        }
      )
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    }
  },
  {
    "famiu/bufdelete.nvim",
    enabled = not vim.g.vscode,
    keys = {
      {
        "<leader>q",
        "<cmd>Bdelete<CR>",
        silent = true
      }
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    enabled = not vim.g.vscode,
    opts = {
      scope = {
        enabled = false
      }
    }
  },
  {
    "folke/noice.nvim",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true
        }
      },
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = {pattern = "^:", icon = ":", lang = "vim"},
          search_down = {kind = "search", pattern = "^/", icon = "/", lang = "regex"},
          search_up = {kind = "search", pattern = "^%?", icon = "?", lang = "regex"},
          filter = {pattern = "^:%s*!", icon = "$", lang = "bash"},
          lua = {pattern = "^:%s*lua%s+", icon = "☾", lang = "lua"},
          help = {pattern = "^:%s*he?l?p?%s+", icon = "??"}
        }
      },
      popupmenu = {
        backend = "cmp"
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false -- add a border to hover docs and signature help
      }
    },
    dependencies = {"MunifTanjim/nui.nvim"}
  }
}
