-- lua/config/keymaps.lua

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shorter alias for mapping
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =============================
-- 🌙  Telescope Keymaps
-- =============================
local ok, builtin = pcall(require, "telescope.builtin")
if ok then
  map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
  map("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
  map("n", "<leader>fb", builtin.buffers, { desc = "List Buffers" })
  map("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
  map("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
  map("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
  map("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Search Current Buffer" })
else
  vim.notify("Telescope not found — skipping Telescope keymaps", vim.log.levels.WARN)
end

-- =============================
-- 🧭  General Keymaps
-- =============================
map("n", "<leader>w", ":w<CR>", vim.tbl_extend("force", opts, { desc = "Save File" }))
map("n", "<leader>q", ":q<CR>", vim.tbl_extend("force", opts, { desc = "Quit Window" }))
map("n", "<leader>h", ":nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "Clear Highlights" }))
map("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true })



-- =============================
-- 💻  Terminal Keymaps
-- =============================
map("n", "<leader>th", ":split | terminal<CR>", vim.tbl_extend("force", opts, { desc = "Horizontal Terminal" }))
map("n", "<leader>tv", ":vsplit | terminal<CR>", vim.tbl_extend("force", opts, { desc = "Vertical Terminal" }))
map("t", "<Esc>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Exit Terminal Mode" }))
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })


-- =============================
-- 🪟  Window & Buffer Management
-- =============================
map("n", "<leader>sv", ":vsplit<CR>", vim.tbl_extend("force", opts, { desc = "Vertical Split" }))
map("n", "<leader>sh", ":split<CR>", vim.tbl_extend("force", opts, { desc = "Horizontal Split" }))
map("n", "<leader>bd", ":bdelete<CR>", vim.tbl_extend("force", opts, { desc = "Close Buffer" }))

