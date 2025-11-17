return {
	"tpope/vim-fugitive",
	dependencies = {
		"rbong/vim-flog",
	},
	init = function()
		vim.g.flog_enable_extended_chars = 1
	end,
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		local JRGirvan_Fugitive = vim.api.nvim_create_augroup("JRGirvan_Fugitive", {})

		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = JRGirvan_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git("push")
				end, opts)

				-- rebase always
				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git("pull --rebase")
				end, opts)

				-- NOTE: It allows me to easily set the branch i am pushing and any tracking
				-- needed if i did not set the branch up correctly
				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
			end,
		})

		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
		vim.keymap.set("n", "<leader>gl", vim.cmd.Flog)
		-- Branch operations
		vim.keymap.set("n", "<leader>gb", function()
			vim.cmd.Git("branch")
		end, { desc = "List branches" })

	end,
}
