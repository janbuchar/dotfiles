-- Returns true if the current working directory contains git-tracked files.
local git_worktree_cache = {}
local function in_git_worktree()
  local cwd = vim.fn.getcwd()
  local cached = git_worktree_cache[cwd]
  if cached ~= nil then
    return cached
  end
  local result = vim.fn.systemlist({ "git", "ls-files", "." })
  local in_worktree = vim.v.shell_error == 0 and #result > 0
  git_worktree_cache[cwd] = in_worktree
  return in_worktree
end

-- True when auto-session has loaded/created a session for the current dir.
local function has_active_session()
  local ok, lib = pcall(require, "auto-session.lib")
  return ok and lib.current_session_name ~= nil
end

return {
  {
    "EdenEast/nightfox.nvim",
    enabled = not vim.g.vscode,
  },
  {
    "rmagatti/auto-session",
    enabled = not vim.g.vscode,
    opts = {
      auto_create = function()
        return in_git_worktree()
      end,
    },
  },
  {
    "okuuva/auto-save.nvim",
    enabled = not vim.g.vscode,
    version = "^1.0.0",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      condition = function()
        return in_git_worktree() or has_active_session()
      end,
    },
  },
  {
    "stevearc/aerial.nvim",
    enabled = not vim.g.vscode,
    opts = {
      layout = { min_width = 30 },
      on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>o", function()
          local aerial_window = require("aerial.window")
          if
            aerial_window.is_open({ winid = vim.api.nvim_get_current_win() })
          then
            aerial_window.focus()
          else
            aerial_window.open(true, "right")
          end
        end, { buffer = bufnr })
        vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
      end,
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>t",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager",
      },
    },
    ---@type YaziConfig
    opts = {
      open_for_directories = false,
      floating_window_scaling_factor = 0.75,
      yazi_floating_window_winblend = 10,
      integrations = {
        grep_in_directory = "fzf-lua",
        grep_in_selected_files = "fzf-lua",
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = not vim.g.vscode,
    init = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = function(
          virtText,
          lnum,
          endLnum,
          width,
          truncate
        )
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
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix
                  .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end,
      })
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    enabled = not vim.g.vscode,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
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
        },
      },
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { pattern = "^:", icon = ":", lang = "vim" },
          search_down = {
            kind = "search",
            pattern = "^/",
            icon = "/",
            lang = "regex",
          },
          search_up = {
            kind = "search",
            pattern = "^%?",
            icon = "?",
            lang = "regex",
          },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = "^:%s*lua%s+", icon = "☾", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "??" },
        },
      },
      popupmenu = {
        backend = "nui",
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
  },
}
