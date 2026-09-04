return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      model = "gpt-5.6-sol", -- or another model your Copilot account supports
    },
  },
}
