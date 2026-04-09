return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "mgalliou/blink-cmp-tmux",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "select_and_accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<Tab>"] = { "insert_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "insert_prev", "snippet_backward", "fallback" },
        ["<Down>"] = { "select_next", "snippet_forward", "fallback" },
        ["<Up>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "hide", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji", "tmux" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = -1,
          },
          tmux = {
            module = "blink-cmp-tmux",
            name = "Tmux",
            score_offset = -2,
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
      signature = {
        enabled = true,
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "inherit",
          ["<CR>"] = { "fallback" },
          ["<C-Space>"] = { "select_accept_and_enter", "fallback" },
        },
        completion = {
          menu = { auto_show = true },
        },
      },
    },
  },
}
