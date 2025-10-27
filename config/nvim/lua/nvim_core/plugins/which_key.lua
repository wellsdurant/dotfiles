-- Useful plugin to show you pending keybinds.
return {
  "folke/which-key.nvim",
  event = "VimEnter",
  opts = {
    -- Document existing key chains
    spec = {
      -- Group
      { "<leader>f", group = "[f]ind" },
    },
  },
}
