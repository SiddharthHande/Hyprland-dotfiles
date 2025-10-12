-- lua/config/lsp.lua
-- Safe requires
local ok_cmp, cmp = pcall(require, "cmp")
local ok_luasnip, luasnip = pcall(require, "luasnip")
local ok_mason, mason = pcall(require, "mason")
local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")

if not (ok_cmp and ok_luasnip and ok_mason and ok_mason_lsp) then
  return
end

-- ===============================
-- Mason setup
-- ===============================
mason.setup()
mason_lspconfig.setup({
  ensure_installed = { "lua_ls", "pyright", "ts_ls" },
  automatic_installation = true,
})

-- ===============================
-- nvim-cmp (Completion)
-- ===============================
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }),
})

-- ===============================
-- Capabilities
-- ===============================
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ===============================
-- On Attach Function
-- ===============================
local on_attach = function(client, bufnr)
  local buf_map = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
  end
  
  buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
end

-- ===============================
-- LSP Server Configurations
-- ===============================
local servers = {
  lua_ls = {},
  pyright = {},
  ts_ls = {},
}

-- Register each server with vim.lsp.config
for server_name, server_config in pairs(servers) do
  local config = vim.tbl_extend("force", {
    capabilities = capabilities,
    on_attach = on_attach,
  }, server_config)
  
  vim.lsp.config(server_name, config)
end

-- Enable the configured servers
vim.lsp.enable({ "lua_ls", "pyright", "ts_ls" })

-- ===============================
-- Diagnostics
-- ===============================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
