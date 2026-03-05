vim.opt.nu = true

vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
--vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
--vim.opt.shortmess:append("c")

--vim.opt.colorcolumn = "120"

-- Make line numbers brighter
--vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ffffff', bold = true })
--vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffff00', bold = true })
--
vim.opt.winborder = "rounded"
