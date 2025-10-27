-- =========================
-- Leader Key
-- =========================
-- Set Space key as the leader key
vim.g.mapleader = " "

-- =========================
-- Text Editing Enhancements
-- =========================
vim.keymap.set("n", "J", "mzJ`z")        -- Join lines without moving cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")  -- Scroll half-page down and center
vim.keymap.set("n", "<C-u>", "<C-u>zz")  -- Scroll half-page up and center
vim.keymap.set("n", "n", "nzz")          -- Center search result
vim.keymap.set("n", "N", "Nzz")          -- Center reverse search result

-- =========================
-- Visual Mode Clipboard & Deletion
-- =========================
vim.keymap.set("x", "<leader>p", [["_dP]])          -- Paste over selection without overwriting default register
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])  -- Yank to system clipboard
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")   -- Delete without affecting registers

-- =========================
-- File Permissions
-- =========================
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- =========================
-- Reload Config
-- =========================
-- vim.keymap.set(
--   "n", "<leader><leader>",
--   function() vim.cmd("so ~/.config/nvim/init.lua") end,
--   { desc = "Reload configuration" }
-- )
