(function()
  if not vim.env.TMUX then
    return
  end

  vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = vim.api.nvim_create_augroup("tmux_clipboard", { clear = true }),
    pattern = "*",
    callback = function()
      vim.system(
        { "tmux", "loadb", "-w", "-" },
        { stdin = table.concat(vim.v.event.regcontents, "\n") }
      )
    end,
  })
end)()
