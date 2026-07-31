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

-- Keymaps
-- <leader>n group label (which-key v3)
require("which-key").add({ { "<leader>n", group = "🧪 test", nowait = true, remap = false } })
vim.keymap.set("n", "<leader>nr", "<cmd>lua require('neotest').run.run()<cr>", { desc = "run nearest test" })
vim.keymap.set(
	"n",
	"<leader>nf",
	"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
	{ desc = "run current file" }
)
vim.keymap.set(
	"n",
	"<leader>na",
	"<cmd>lua require('neotest').run.run({ suite = true })<cr>",
	{ desc = "run all tests" }
)
vim.keymap.set(
	"n",
	"<leader>nd",
	"<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
	{ desc = "debug nearest test" }
)
vim.keymap.set("n", "<leader>ns", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "stop test" })
vim.keymap.set("n", "<leader>nn", "<cmd>lua require('neotest').run.attach()<cr>", { desc = "attach to nearest test" })
vim.keymap.set("n", "<leader>no", "<cmd>lua require('neotest').output.open()<cr>", { desc = "show test output" })
vim.keymap.set(
	"n",
	"<leader>np",
	"<cmd>lua require('neotest').output_panel.toggle()<cr>",
	{ desc = "toggle output panel" }
)
vim.keymap.set("n", "<leader>nv", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "toggle summary" })
vim.keymap.set(
	"n",
	"<leader>nc",
	"<cmd>lua require('neotest').run.run({ suite = true, env = { ci = true } })<cr>",
	{ desc = "run all tests with ci" }
)
