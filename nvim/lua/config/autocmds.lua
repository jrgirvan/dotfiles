local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local JRGirvanGroup = augroup('JRGirvan', {})
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
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    end
})
local group = vim.api.nvim_create_augroup('MarkdownSettings', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = {'*.md'},
    group = group,
    command = 'setlocal wrap'
})

local yank_group = augroup('HighlightYank', {})
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

local jdtls_lsp_group = augroup('jdtls_lsp', { clear = true }) -- '{ clear = true }' replaces 'autocmd!'
autocmd('FileType', {
    group = jdtls_lsp_group,
    pattern = 'java', -- Specify the file type
    callback = function()
        require('config.jdtls').setup_jdtls() -- The command is now a Lua function
    end,
})
