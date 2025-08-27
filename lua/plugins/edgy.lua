-- In your LazyVim config
return {
  "folke/edgy.nvim",
  opts = {
    right = {
      -- Remove or comment out the DBUI entry
      { title = "Database", ft = "dbui", width = 0.3 },
      -- Or set it to not open by default:
    },
  },
}
