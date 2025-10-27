return {
  "nvim-mini/mini.files",
  version = "*",
  config = function() require("mini.files").setup() end,
  keys = {
    {
      "<leader>e",
      function()
        local MiniFiles = require("mini.files")
        if not MiniFiles.close() then
          MiniFiles.open()
        else
          MiniFiles.close()
        end
      end,
      desc = "Toggle Explorer"
    },
    {
      "<leader>E",
      function()
        local MiniFiles = require("mini.files")
        if not MiniFiles.close() then
          MiniFiles.open(vim.api.nvim_buf_get_name(0))
        else
          MiniFiles.close()
        end
      end,
      desc = "Toggle Explorer (current file)"
    },
  },
}
