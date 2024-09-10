local util = require "lspconfig/util"
local lspconfig = require("lspconfig")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  local lsp = vim.lsp
  if lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { 0 })
    vim.keymap.set("n", "<C-t>",
    function() if vim.lsp.inlay_hint.is_enabled() then vim.lsp.inlay_hint.enable(false, { bufnr }) else vim.lsp.inlay_hint.enable(true, { bufnr }) end end, {})
  end
  vim.keymap.set("n" ,"<leader>rn", lsp.buf.rename, {})
  vim.keymap.set("n" ,"<leader>ca", lsp.buf.code_action, {})
  vim.keymap.set("n" ,"gd", lsp.buf.definition, {})
  vim.keymap.set("n" ,"gi", lsp.buf.implementation, {})
  vim.keymap.set("n" ,"gr", require("telescope.builtin").lsp_references, {})
  vim.keymap.set("n" ,"K", lsp.buf.hover, {})
end
--
-- require'lspconfig'.lua_ls.setup{
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
--
for _, server in pairs(require("shared.lsp_server_list")) do
  lspconfig[server].setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.denols.setup {
  on_attach = on_attach,
  -- root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = true
}

lspconfig.hls.setup({
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml"),
  setting = {
    ["rust_analyzer"] = {
      diagnostics = {
        enable = true,
      },
      cargo = {
        allFeatures = true,
      }
    }
  }
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if vim.tbl_contains({ 'null-ls' }, client.name) then  -- blacklist lsp
      return
    end
    require("lsp_signature").on_attach({
    }, bufnr)
  end,
})
