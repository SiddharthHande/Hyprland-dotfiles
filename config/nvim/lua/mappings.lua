local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

-- nvimtree
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")
map("n", "<C-h>", "<cmd> NvimTreeFocus <CR>")

-- telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>")
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
map("n", "gr", "<cmd>Telescope lsp_references<cr>")

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>")
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")
map("n", "<C-q>", "<cmd> bd <CR>")

-- comment.nvim
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- LSP specific
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

-- format
map("n", "<leader>fm", function()
  require("conform").format()
end)

map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

-- 🧠 Apply the first available code action automatically
map("n", "<leader>cq", function()
  vim.lsp.buf.code_action { apply = true }
end, opts)

-- 🪄 Organize imports (if LSP supports it)
map("n", "<leader>oi", function()
  vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
end, opts)

-- 🧹 Format + organize imports like VSCode
map("n", "<leader>cf", function()
  vim.lsp.buf.format()
  vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
end, opts)

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- ToggleTerm keymap
map("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
