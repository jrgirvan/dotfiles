local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

local remap = require("jrgirvan.keymap")
local nnoremap = remap.nnoremap
local vnoremap = remap.vnoremap

daptext.setup()
dapui.setup({
    layouts = {
        {
            elements = {
                "console",
            },
            size = 7,
            position = "bottom",
        },
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "watches",
            },
            size = 40,
            position = "left",
        }
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("jrgirvan.debugger.python");

nnoremap("<Home>", function()
    dapui.toggle(1)
end)
nnoremap("<End>", function()
    dapui.toggle(2)
end)

nnoremap("<leader><leader>", function()
    dap.close()
end)

nnoremap("<Up>", function()
    dap.continue()
end)
nnoremap("<Down>", function()
    dap.step_over()
end)
nnoremap("<Right>", function()
    dap.step_into()
end)
nnoremap("<Left>", function()
    dap.step_out()
end)



nnoremap("<Leader>dk", function()
    dap.up()
end)

nnoremap("<Leader>dj", function()
    dap.down()
end)

nnoremap("<Leader>d_", function()
    dap.run_last()
end)

nnoremap("<Leader>dr", function()
    dap.repl.open({}, 'vsplit')
end)

nnoremap("<Leader>di", function()
    require("dap.ui.widgets").hover()
end)

vnoremap("<Leader>di", function()
    dap.ui.variables.visual_hover()
end)

nnoremap("<Leader>d?", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
end)

-- nvim-telescope/telescope-dap.nvim
require('telescope').load_extension('dap')
nnoremap('<leader>ds', ':Telescope dap frames<CR>')
nnoremap('<leader>dc', ':Telescope dap commands<CR>')
nnoremap('<leader>db', ':Telescope dap list_breakpoints<CR>')











nnoremap("<Leader>b", function()
    dap.toggle_breakpoint()
end)
nnoremap("<Leader>B", function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
nnoremap("<leader>rc", function()
    dap.run_to_cursor()
end)
nnoremap("<leader>ro", function()
    dap.repl.open()
end)
