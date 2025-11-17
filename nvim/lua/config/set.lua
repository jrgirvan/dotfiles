vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = true
vim.opt.directory = os.getenv("HOME") .. "/.vim/swap"
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

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
