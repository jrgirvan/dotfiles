return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	keys = {
		{
			"<C-a>",
			function()
				require("copilot.suggestion").accept()
			end,
			desc = "Copilot: Accept suggestion",
			mode = { "i" },
		},
		{
			"<C-x>",
			function()
				require("copilot.suggestion").dismiss()
			end,
			desc = "Copilot: Dismiss suggestion",
			mode = { "i" },
		},
		{
			"<C-\\>",
			function()
				require("copilot.panel").open()
			end,
			desc = "Copilot: Show panel",
			mode = { "n", "i" },
		},
	},
	init = function()
		jg.create_user_command("Copilot", "Toggle Copilot suggestions", function()
			require("copilot.suggestion").toggle_auto_trigger()
		end, {})
	end,
	opts = {
		panel = { enabled = false },
		suggestion = {
			auto_trigger = true, -- Suggest as we start typing
			keymap = {
				accept_word = "<C-l>",
				accept_line = "<C-j>",
			},
		},
	},
}
