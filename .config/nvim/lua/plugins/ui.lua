return {
  {
    "EdenEast/nightfox.nvim",
    enabled = not vim.g.vscode,
  },
  {
    "thaerkh/vim-workspace",
    enabled = not vim.g.vscode,
    init = function()
      -- Disable history management (when enabled, it created empty undo history items for some reason)
      vim.g.workspace_persist_undo_history = 0
      vim.g.workspace_autosave_untrailspaces = 0
      vim.g.workspace_autosave_untrailtabs = 0
    end
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
    "kevinhwang91/rnvimr",
    enabled = not vim.g.vscode,
    init = function()
      vim.g.rnvimr_enable_bw = 1
      vim.g.rnvimr_enable_picker = 1
      vim.g.rnvimr_ranger_cmd = {"ranger", "--cmd=set vcs_aware true"}
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
