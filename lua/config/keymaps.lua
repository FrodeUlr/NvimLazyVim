-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
map("n", "<m-/>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

for i = 1, 9 do
  map(
    "n",
    "<leader>" .. i .. "",
    "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
    { noremap = true, silent = true, desc = "Goto Buffer " .. i }
  )
end

-- Close current buffer
map("n", "<A-c>", "<Cmd>bd<CR>", {
  noremap = true,
  silent = true,
  desc = "Close Current Buffer",
})

map("i", "kj", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode with kj" })
