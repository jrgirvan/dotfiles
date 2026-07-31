vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/ts-comments.nvim", -- Enhance Neovim's native comments
	"https://github.com/catppuccin/nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/zbirenbaum/copilot.lua",
	{
		src = "https://github.com/theprimeagen/harpoon",
		version = "harpoon2",
	},
	"https://github.com/folke/snacks.nvim",
	"https://github.com/NickvanDyke/opencode.nvim",
	"https://github.com/julienvincent/hunk.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/mbbill/undotree",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/folke/zen-mode.nvim",
	"https://github.com/jceb/jiejie.nvim",
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/haydenmeade/neotest-jest",
	"https://github.com/Issafalcon/neotest-dotnet",
	"https://github.com/fredrikaverpil/neotest-golang",
	"https://github.com/folke/which-key.nvim",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "PackChanged",
	callback = function(ev)
		if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
			return
		end

		if ev.data.name == "neotest-golang" then
			vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
		end
		-- nvim-treesitter updates are handled in plugins/nvim-treesitter.lua
	end,
})

require("plugins.nvim-treesitter")
require("plugins.snacks")
require("plugins.harpoon")
require("plugins.conform")
require("plugins.copilot")
require("plugins.opencode")
require("plugins.statusline")
require("plugins.telescope")
require("plugins.trouble")
require("plugins.zenmode")
require("plugins.neotest")

vim.cmd([[colorscheme catppuccin]])

-- Lazy-load hunk.nvim the first time :DiffEditor is used
vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = "DiffEditor",
	once = true,
	callback = function()
		require("hunk").setup()
	end,
})

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)
vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "buffer local keymaps (which-key)" })
