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
