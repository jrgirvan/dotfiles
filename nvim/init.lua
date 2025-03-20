require("config.remap")
require("config.set")
require("config.lazy")
require("config.autocmds")
--vim.lsp.set_log_level("debug")
local augroup = vim.api.nvim_create_augroup
local JRGirvanGroup = augroup('JRGirvan', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

vim.filetype.add({
    extension = {
        templ = "templ",
    }
})
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})


autocmd({ "BufWritePre" }, {
    group = JRGirvanGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd({ "LspAttach" }, {
    group = JRGirvanGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        if vim.bo.filetype == "cs" then
            vim.keymap.set("n", "gd", "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>", opts)
            vim.keymap.set("n", "gt", "<cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>", opts)
            vim.keymap.set("n", "gr", "<cmd>lua require('omnisharp_extended').lsp_references()<cr>", opts)
            vim.keymap.set("n", "gi", "<cmd>lua require('omnisharp_extended').lsp_implementation()<cr>", opts)
        else
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        end
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        --vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        --vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end
})
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.xdc set filetype=xdc
]], false)

