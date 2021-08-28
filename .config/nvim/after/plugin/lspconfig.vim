if !exists('g:lspconfig')
  finish
endif

lua << EOF
local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
end

local config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.tsserver.setup(config)
nvim_lsp.pyright.setup(config)
nvim_lsp.jsonls.setup(config)
nvim_lsp.cssls.setup(config)
nvim_lsp.dockerls.setup(config)

EOF
