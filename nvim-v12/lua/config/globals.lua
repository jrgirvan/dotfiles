-- globals
--------------------------------------------------------------------------------
-- Set <space> as leader key
-- NOTE: Must happen before loading plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.render_markdown_config = {
	ignore = function(buf)
		return vim.bo[buf].buftype ~= ""
	end,
}

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
