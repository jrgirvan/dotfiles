-- vim.pack.add is in lua/plugins/pack.lua
-- vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

-- init = function() equivalent
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		java = { "google-java-format" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		nix = { "nixfmt" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
})

-- Keymap
vim.keymap.set("n", "ff", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })
