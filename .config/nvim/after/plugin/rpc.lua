local function escape_path(path)
  return path:gsub("^%s+", ""):gsub("%s+$", ""):gsub("/", "%%")
end

local function get_socket_dir()
  local xdg = os.getenv("XDG_RUNTIME_DIR")
  if xdg and xdg ~= "" then
    return xdg
  end
  local tmpdir = os.getenv("TMPDIR")
  if tmpdir and tmpdir ~= "" then
    return tmpdir
  end
  return "/tmp"
end

local function get_project_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
    handle:close()
    if result ~= "" then
      return result
    end
  end
  return vim.fn.getcwd()
end

local function rpc_socket_path()
  local root = get_project_root()
  local escaped = escape_path(root)
  local pid = vim.fn.getpid()
  return string.format("%s/nvim-mcp.%s.%d.sock", get_socket_dir(), escaped, pid)
end

local function has_rpc_socket()
  local expected = rpc_socket_path()
  for _, addr in ipairs(vim.fn.serverlist()) do
    if addr == expected then
      return true
    end
  end
  return false
end

-- Expose for lualine / other consumers
_G.rpc_has_socket = has_rpc_socket

vim.api.nvim_create_user_command("RpcStart", function()
  if has_rpc_socket() then
    vim.notify("RPC socket already active", vim.log.levels.WARN)
    return
  end
  local path = rpc_socket_path()
  vim.fn.serverstart(path)
  vim.notify("Listening on " .. path, vim.log.levels.INFO)
end, { desc = "Start Neovim RPC socket for nvim-mcp" })

vim.api.nvim_create_user_command("RpcStop", function()
  local path = rpc_socket_path()
  if not has_rpc_socket() then
    vim.notify("RPC socket not active", vim.log.levels.WARN)
    return
  end
  vim.fn.serverstop(path)
  vim.notify("Stopped listening on " .. path, vim.log.levels.INFO)
end, { desc = "Stop Neovim RPC socket for nvim-mcp" })
