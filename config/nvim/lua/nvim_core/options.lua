-- =========================
-- Clipboard
-- =========================
-- Yank, delete, change, and paste will use the system clipboard
vim.opt.clipboard = "unnamedplus"

-- =========================
-- User interface
-- =========================
-- Enable true color support for terminal
vim.opt.termguicolors = true

-- Always show the sign column (used for Git changes, diagnostics, breakpoints, etc.)
vim.opt.signcolumn = "yes"

-- Enable absolute line numbers
vim.opt.nu = true
-- Enable relative line numbers (relative to the current cursor line) for easier navigation
vim.opt.relativenumber = true

-- Disable line wrapping; long lines will scroll horizontally
vim.opt.wrap = false

-- Highlight column 80 to help visually track line length (common for code style)
vim.opt.colorcolumn = "80"

-- =========================
-- Tabs and indentation
-- =========================
-- Number of spaces that a <Tab> in the file counts for
vim.opt.tabstop = 4
-- Number of spaces that a <Tab> counts for while editing (insert mode)
vim.opt.softtabstop = 4
-- Number of spaces to use for each step of (auto)indent
vim.opt.shiftwidth = 4
-- Convert tabs to spaces
vim.opt.expandtab = true
-- Enable smart indentation (automatically inserts indentation in some contexts)
vim.opt.smartindent = true

-- Use 2 spaces for Lua files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.bo.tabstop = 2       -- Number of spaces a <Tab> counts for
        vim.bo.shiftwidth = 2    -- Number of spaces to use for autoindent
        vim.bo.softtabstop = 2   -- Number of spaces a <Tab> uses while editing
        vim.bo.expandtab = true  -- Use spaces instead of actual tab characters
    end,
})

-- =========================
-- File backups and undo
-- =========================
-- Disable swap files (prevents creation of .swp files)
vim.opt.swapfile = false
-- Disable backup files (prevents creation of ~ files)
vim.opt.backup = false
-- Enable persistent undo so undo history is saved across sessions
vim.opt.undofile = true
-- Set directory to store undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- =========================
-- Search Highlighting
-- =========================
-- Disable highlighting of all search matches after search
vim.opt.hlsearch = false
-- Enable incremental search, showing matches as you type
vim.opt.incsearch = true

-- =========================
-- Scrolling
-- =========================
-- Keep the cursor always in the middle of the screen when scrolling
-- vim.opt.scrolloff = 999

-- =========================
-- Filename behavior
-- =========================
-- Include the '@' character in filenames recognized by Vim commands like gf
vim.opt.isfname:append("@-@")

-- =========================
-- Refresh time
-- =========================
-- Reduce the time Vim waits before triggering CursorHold events (default is 4s)
vim.opt.updatetime = 50


-- Prevent commenting out next line after a comment line
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})

-- Set Python3 host program for Neovim if the venv exists
local python_path = vim.fn.expand("$HOME/.venv/bin/python")
if vim.fn.filereadable(python_path) == 1 then
  vim.g.python3_host_prog = python_path
end
