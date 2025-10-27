-- Highlight, edit, and navigate code
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts

  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "diff",
      "html",
      "json5",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
      "typescript",
      "python",
    },
    auto_install = true, -- Autoinstall languages that are not installed
    highlight = {
      enable = true,
      disable = { "tmux" },
      -- additional_vim_regex_highlighting = false,
    },
    -- indent = {
    --   enable = true,
    -- },
  },
}

