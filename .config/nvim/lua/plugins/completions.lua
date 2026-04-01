return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "barrettruth/blink-cmp-tmux",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
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
      },
      signature = {
        enabled = true,
      },
      cmdline = {
        enabled = true,
      },
    },
  },
}
