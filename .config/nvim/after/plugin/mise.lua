local mise_file = "./.mise.toml"
vim.api.nvim_create_user_command("Mise", ":edit " .. mise_file, { nargs = 0 })
