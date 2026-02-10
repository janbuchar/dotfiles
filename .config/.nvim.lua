local shared = require("nvim_shared")
local fzf = require("fzf-lua")
local map = vim.keymap.set

local git_dirs = {
  git_dir = "~/.local/share/yadm/repo.git",
  git_worktree = "~",
}

map("n", "<leader>m", function()
  fzf.git_status(
    vim.tbl_deep_extend("keep", { cmd = "git status -s -uno" }, git_dirs)
  )
end, { silent = true })

map("n", "<leader>n", function()
  fzf.git_files(git_dirs)
end, { silent = true })

map("n", "<leader>l", function()
  fzf.git_commits(git_dirs)
end, { silent = true })

require("formatter").setup({
  filetype = {
    typescript = { shared.formatters.npx_prettier },
    json = { shared.formatters.npx_prettier },
    html = { shared.formatters.npx_prettier },
    scss = { shared.formatters.npx_prettier },
    css = { shared.formatters.npx_prettier },
  },
})
