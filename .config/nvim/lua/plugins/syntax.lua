return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = "all",
      -- nvim-treesitter master branch is archived as of 2026-04-03.
      -- These grammars fail to compile (tree-sitter CLI --no-bindings incompatibility):
      --   ipkg, latex, mlir, ocamllex, scfg, swift, teal, unison
      -- These use the built-in nvim 0.12 parser instead (plugin's injection queries
      -- use the defunct #set-lang-from-info-string! directive, causing nil node crashes):
      --   markdown, markdown_inline
      ignore_install = {
        "ipkg", "latex", "mlir", "ocamllex", "scfg", "swift", "teal", "unison",
        "markdown", "markdown_inline",
      },
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },
    },
  },
  {
    "davidmh/mdx.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "grafana/vim-alloy"
  }
}
