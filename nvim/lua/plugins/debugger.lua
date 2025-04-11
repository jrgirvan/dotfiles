return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "nvim-telescope/telescope-dap.nvim",
        "mfussenegger/nvim-dap-python",
        "leoluz/nvim-dap-go",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        local daptext = require("nvim-dap-virtual-text")
        dap.set_log_level('TRACE')
        daptext.setup()
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<leader>dt", function()
            dapui.toggle(1)
        end)
        vim.keymap.set("n", "<leader>dy", function()
            dapui.toggle(2)
        end)

        vim.keymap.set("n", "<leader><leader>", function()
            dap.close()
        end)

        vim.keymap.set("n", "<Up>", function()
            dap.continue()
        end)
        vim.keymap.set("n", "<Down>", function()
            dap.step_over()
        end)
        vim.keymap.set("n", "<Right>", function()
            dap.step_into()
        end)
        vim.keymap.set("n", "<Left>", function()
            dap.step_out()
        end)

        vim.keymap.set("n", "<leader>dk", function()
            dap.up()
        end)

        vim.keymap.set("n", "<leader>dj", function()
            dap.down()
        end)

        vim.keymap.set("n", "<leader>dr", function()
            dap.repl.open({}, 'split')
        end)

        vim.keymap.set("n", "<leader>di", function()
            require("dap.ui.widgets").hover()
        end)

        vim.keymap.set("v", "<leader>di", function()
            dap.ui.variables.visual_hover()
        end)

        vim.keymap.set("n", "<leader>d?", function()
            local widgets = require("dap.ui.widgets")
            widgets.centered_float(widgets.scopes)
        end)

        -- nvim-telescope/telescope-dap.nvim
        require('telescope').load_extension('dap')
        vim.keymap.set("n", '<leader>ds', ':Telescope dap frames<CR>')
        vim.keymap.set("n", '<leader>dc', ':Telescope dap commands<CR>')
        vim.keymap.set("n", '<leader>db', ':Telescope dap list_breakpoints<CR>')

        vim.keymap.set("n", "<leader>b", function()
            dap.toggle_breakpoint()
        end)
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end)
        vim.keymap.set("n", "<leader>rc", function()
            dap.run_to_cursor()
        end)
        vim.keymap.set("n", "<leader>ro", function()
            dap.repl.open()
        end)



        dap.adapters.lldb = {
            type = 'executable',
            command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
            name = 'lldb'
        }

        dap.configurations.cpp = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.loop.cwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = true,
                args = {},

                -- 💀
                -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                --
                --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                --
                -- Otherwise you might get the following error:
                --
                --    Error on launch: Failed to attach to the target process
                --
                -- But you should be aware of the implications:
                -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                -- runInTerminal = false,
            }
        }

        -- If you want to use this for Rust and C, add something like this:

        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
        dap.adapters.coreclr = {
            type = 'executable',
            command = os.getenv("HOME") .. '/.local/share/nvim/netcoredbg/netcoredbg',
            args = { '--interpreter=vscode' }
        }

        vim.g.dotnet_build_project = function()
            local default_path = vim.fn.getcwd() .. '/'
            if vim.g['dotnet_last_proj_path'] ~= nil then
                default_path = vim.g['dotnet_last_proj_path']
            end
            local path = vim.fn.input('Path to your *proj file ', default_path, 'file')
            vim.g['dotnet_last_proj_path'] = path
            local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
            print('')
            print('Cmd to execute: ' .. cmd)
            local f = os.execute(cmd)
            if f == 0 then
                print('\nBuild: ✔️ ')
            else
                print('\nBuild: ❌ (code: ' .. f .. ')')
            end
        end

        vim.g.dotnet_get_dll_path = function()
            local request = function()
                return vim.fn.input('Path to dll ', vim.fn.getcwd() .. '/bin/Debug/net6.0', 'file')
            end

            if vim.g['dotnet_last_dll_path'] == nil then
                vim.g['dotnet_last_dll_path'] = request()
            else
                if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
                    vim.g['dotnet_last_dll_path'] = request()
                end
            end

            return vim.g['dotnet_last_dll_path']
        end

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                        vim.g.dotnet_build_project()
                    end
                    return vim.g.dotnet_get_dll_path()
                end,
                stopAtEntry = true,
            },
        }






        require('dap-go').setup {
            -- Additional dap configurations can be added.
            -- dap_configurations accepts a list of tables where each entry
            -- represents a dap configuration. For more details do:
            -- :help dap-configuration
            dap_configurations = {
                {
                    -- Must be "go" or it will be ignored by the plugin
                    type = "go",
                    name = "Attach remote",
                    mode = "remote",
                    request = "attach",
                },
            },
            -- delve configurations
            delve = {
                -- the path to the executable dlv which will be used for debugging.
                -- by default, this is the "dlv" executable on your PATH.
                path = "dlv",
                -- time to wait for delve to initialize the debug session.
                -- default to 20 seconds
                initialize_timeout_sec = 20,
                -- a string that defines the port to start delve debugger.
                -- default to string "${port}" which instructs nvim-dap
                -- to start the process in a random available port
                port = "${port}",
                -- additional args to pass to dlv
                args = {},
                -- the build flags that are passed to delve.
                -- defaults to empty string, but can be used to provide flags
                -- such as "-tags=unit" to make sure the test suite is
                -- compiled during debugging, for example.
                -- passing build flags using args is ineffective, as those are
                -- ignored by delve in dap mode.
                build_flags = "",
            },
        }

        local dap_python = require('dap-python')

        dap_python.setup('~/.virtualenvs/debugpy/bin/python')
        dap_python.test_runner = 'pytest'
        local configurations = dap.configurations.python
        for _, configuration in pairs(configurations) do
            configuration.justmycode = false
            configuration.subprocess = true
        end

        dap.adapters.java = function(callback, config)
            callback({
                type = "server",
                host = "127.0.0.1", -- Adjust if the debug server runs on a different host
                port = config.port or 5005, -- Default JDWP port
            })
        end

        dap.configurations.java = {
            {
                type = "java",
                request = "attach",
                name = "Attach to Remote Java App",
                hostName = "127.0.0.1", -- Change to the remote host if needed
                port = 5005, -- Default JDWP port, adjust if necessary
            },
            {
                type = "java",
                request = "launch",
                name = "Run Java Application",
                mainClass = function()
                    return vim.fn.input("Main class to run: ")
                end,
                projectName = function()
                    return vim.fn.input("Project name (optional): ", "", "file")
                end,
                args = function()
                    return vim.split(vim.fn.input("Program arguments (space-separated): "), " ")
                end,
            },
        }
    end

}
