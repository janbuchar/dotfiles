if !exists('g:lspconfig')
  finish
endif

lua << EOF
local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
local cmp_nvim = require('cmp_nvim_lsp')

local rt = require("rust-tools")

local capabilities = cmp_nvim.default_capabilities()

local on_attach = function(client, bufnr)
  client.server_capabilities.document_formatting = false
end

local config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

rt.setup({
  server = {
    on_attach = on_attach,
  },
})

nvim_lsp.tsserver.setup(config)
nvim_lsp.pyright.setup(config)
nvim_lsp.jsonls.setup(config)
nvim_lsp.cssls.setup(config)
nvim_lsp.dockerls.setup(config)

EOF
