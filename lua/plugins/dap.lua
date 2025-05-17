return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-dap-virtual-text",
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "codelldb" },
      },
    },
  },
  config = function()
    local dap = require("dap")
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = mason_path .. "adapter/codelldb"

    dap.adapters.codelldb = function(on_adapter)
      local stdout = vim.loop.new_pipe(false)
      local stderr = vim.loop.new_pipe(false)
      local handle
      local port = 13000

      local opts = {
        stdio = { nil, stdout, stderr },
        args = { "--port", tostring(port) },
        detached = true,
      }
      handle, _ = vim.loop.spawn(codelldb_path, opts, function(code)
        stdout:close()
        stderr:close()
        handle:close()
        if code ~= 0 then
          print("codelldb exited with code", code)
        end
      end)

      vim.defer_fn(function()
        on_adapter({
          type = "server",
          host = "127.0.0.1",
          port = port,
        })
      end, 100)
    end

    dap.configurations.rust = {
      {
        name = "Launch",
        type = "codelldb", -- Matches the adapter name
        request = "launch",
        program = function()
          vim.fn.jobstart({ "cargo", "build" }, { cwd = vim.fn.getcwd() })
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {}, -- Additional arguments to pass to the program
      },
      {
        name = "Launch with arguments",
        type = "codelldb",
        request = "launch",
        program = function()
          vim.fn.jobstart({ "cargo", "build" }, { cwd = vim.fn.getcwd() })
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local user_inputs = vim.fn.input("Enter agruments:")
          return vim.split(user_inputs, " ")
        end,
      },
    }
  end,
}
