-- vim.pack.add is in lua/plugins/pack.lua
-- vim.pack.add({"https://github.com/nvim-neotest/neotest"})

local neotest_golang_config = {
	runner = "gotestsum", -- Optional, but recommended
}
require("neotest").setup({
	adapters = {
		require("neotest-golang")(neotest_golang_config), -- Registration
		require("neotest-python")({
			dap = { justMyCode = false },
		}),
		require("neotest-jest"),
		require("neotest-dotnet"),
	},
})
