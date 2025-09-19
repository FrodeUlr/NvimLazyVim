return {
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPost",
    config = function()
      require("persistent-breakpoints").setup({
        save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
        load_breakpoints_event = { "BufReadPost" },
        perf_record = false,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "Weissle/persistent-breakpoints.nvim",
      "mason-org/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
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
      local dapui = require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
      local codelldb_path = mason_path .. "adapter/codelldb"

      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
              source_filetype = "python",
            },
          })
        else
          cb({
            type = "executable",
            command = vim.fn.exepath("debugpy-adapter"),
            options = {
              source_filetype = "python",
            },
          })
        end
      end

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
          if stdout ~= nil then
            stdout:close()
          end
          if stderr ~= nil then
            stderr:close()
          end
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

      dap.configurations.python = {
        {
          type = "python",
          request = "attach",
          name = "Attach to Jupyter",
          connect = {
            port = 5678,
            host = "127.0.0.1",
          },
          mode = "remote",
          cwd = vim.fn.getcwd(),
          pathMappings = {
            {
              localRoot = vim.fn.getcwd(),
              remoteRoot = vim.fn.getcwd(),
            },
          },
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return "/usr/bin/python3"
          end,
        },
      }
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
      vim.keymap.set("n", "<leader>db", function()
        require("persistent-breakpoints.api").toggle_breakpoint()
      end, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        require("persistent-breakpoints.api").set_conditional_breakpoint()
      end, { desc = "Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dD", function()
        require("persistent-breakpoints.api").clear_all_breakpoints()
      end, { desc = "Clear All Breakpoints" })
      -- Optional: Auto-open DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
