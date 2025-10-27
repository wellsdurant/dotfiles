return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Make sure to load this before all the other start plugins.

  opts = {
    flavour = "mocha",
    term_colors = true,
    transparent_background = true,
  },

  config = function(_, opts)
    vim.g.catppuccin_debug = true
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin"
  end,
}
