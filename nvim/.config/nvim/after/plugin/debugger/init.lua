local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

daptext.setup()
dapui.setup()
--{
--    layouts = {
--        {
--            elements = {
--                "console",
--            },
--            size = 7,
--            position = "bottom",
--        },
--        {
--            elements = {
--                -- Elements can be strings or table with id and size keys.
--                { id = "scopes", size = 0.25 },
--                "watches",
--            },
--            size = 40,
--            position = "left",
--        }
--    },
--})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.keymap.set("n", "<Home>", function()
    dapui.toggle(1)
end)
vim.keymap.set("n", "<End>", function()
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

vim.keymap.set("n", "<Leader>dk", function()
    dap.up()
end)

vim.keymap.set("n", "<Leader>dj", function()
    dap.down()
end)

vim.keymap.set("n", "<Leader>d_", function()
    dap.run_last()
end)

vim.keymap.set("n", "<Leader>dr", function()
    dap.repl.open({}, 'split')
end)

vim.keymap.set("n", "<Leader>di", function()
    require("dap.ui.widgets").hover()
end)

vim.keymap.set("v", "<Leader>di", function()
    dap.ui.variables.visual_hover()
end)

vim.keymap.set("n", "<Leader>d?", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
end)

-- nvim-telescope/telescope-dap.nvim
require('telescope').load_extension('dap')
vim.keymap.set("n", '<leader>ds', ':Telescope dap frames<CR>')
vim.keymap.set("n", '<leader>dc', ':Telescope dap commands<CR>')
vim.keymap.set("n", '<leader>db', ':Telescope dap list_breakpoints<CR>')

vim.keymap.set("n", "<Leader>b", function()
    dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
vim.keymap.set("n", "<leader>rc", function()
    dap.run_to_cursor()
end)
vim.keymap.set("n", "<leader>ro", function()
    dap.repl.open()
end)
