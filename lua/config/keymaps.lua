-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.api.nvim_set_keymap
for i = 1, 9 do
  map(
    "n",
    "<leader>" .. i .. "",
    "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
    { noremap = true, silent = true, desc = "Goto Buffer " .. i }
  )
end
