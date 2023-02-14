local noice = require("noice")

noice.setup {
  cmdline = {
    enabled = true,
    view = "cmdline",
    opts = {},
    format = {
      cmdline = {pattern = "^:", icon = ":", lang = "vim"},
      search_down = {kind = "search", pattern = "^/", icon = "/", lang = "regex"},
      search_up = {kind = "search", pattern = "^%?", icon = "?", lang = "regex"},
      filter = {pattern = "^:%s*!", icon = "$", lang = "bash"},
      lua = {pattern = "^:%s*lua%s+", icon = "", lang = "lua"},
      help = {pattern = "^:%s*he?l?p?%s+", icon = ""},
      input = {}
    }
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "virtualtext"
  },
  popupmenu = {
    enabled = false
  },
  notify = {
    enabled = true,
    view = "notify"
  },
  lsp = {
    progress = {
      enabled = false
    },
    hover = {
      enabled = false,
      view = nil,
      opts = {}
    },
    signature = {
      enabled = false,
      auto_open = {
        enabled = false
      }
    },
    message = {
      enabled = true,
      view = "notify",
      opts = {}
    }
  },
  health = {
    checker = true
  },
  smart_move = {
    enabled = true,
    excluded_filetypes = {"cmp_menu", "cmp_docs", "notify"}
  },
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = false, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false -- add a border to hover docs and signature help
  },
  throttle = 1000 / 30
}
