return {
  -- 1. Tell gopls to use gofumpt internally
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
            },
          },
        },
      },
    },
  },
  -- 2. Tell conform.nvim to skip gofumpt entirely
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = {}, -- Emptying this forces LazyVim to use LSP formatting
      },
    },
  },
}
