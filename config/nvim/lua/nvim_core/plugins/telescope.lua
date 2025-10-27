return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Telescope Find Help" },
    { "<leader>fm", "<cmd>Telescope <cr>", desc = "Telescope Find Help" },
    {
      "<leader>fM",
      function()
        require("telescope.builtin").man_pages({ sections = { "ALL" } })
      end,
      desc = "Telescope Man Pages (All Sections)",
    },
    -- {
    --   "<leader>fp",
    --   function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
    --   desc = "Telescopr Find Plugin Files",
    -- },
  },
}
