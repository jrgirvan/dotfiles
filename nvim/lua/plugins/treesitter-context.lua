return {
	"nvim-treesitter/nvim-treesitter-context",
	config = function()
		require("treesitter-context").setup({
			enable = true,
			min_window_height = 10,
			multiline_threshold = 5,
		})
	end,
}
