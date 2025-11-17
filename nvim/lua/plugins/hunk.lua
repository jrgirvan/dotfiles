return {
	"julienvincent/hunk.nvim",
	dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons"
    },
	cmd = { "DiffEditor" },
	config = function()
		require("hunk").setup()
	end,
}
