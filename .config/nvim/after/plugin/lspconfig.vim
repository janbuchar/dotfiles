if !exists('g:lspconfig')
  finish
endif

lua << EOF
local nvim_lsp = require('lspconfig')
local protocol = require'vim.lsp.protocol'

local on_attach = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
end

nvim_lsp.tsserver.setup {on_attach = on_attach}
nvim_lsp.pyright.setup {on_attach = on_attach}
nvim_lsp.jsonls.setup {on_attach = on_attach}
nvim_lsp.cssls.setup {on_attach = on_attach}
nvim_lsp.dockerls.setup {on_attach = on_attach}

EOF
