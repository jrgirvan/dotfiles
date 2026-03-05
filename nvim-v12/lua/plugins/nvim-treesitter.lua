local languages = {
	"vimdoc",
	"c_sharp",
	"terraform",
	"javascript",
	"typescript",
	"go",
	"lua",
	"rust",
	"python",
	"java",
	"zig",
}

local indent_languages = {
	"c_sharp",
	"terraform",
	"javascript",
	"typescript",
	"go",
	"lua",
	"rust",
	"python",
	"java",
	"zig",
}

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install(languages)

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("nvim-treesitter-enable-highlight", { clear = true }),
	pattern = languages,
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("nvim-treesitter-enable-indent", { clear = true }),
	pattern = indent_languages,
	callback = function(args)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if
			(event.data.kind == "install" or event.data.kind == "update")
			and event.data.spec.name == "nvim-treesitter"
		then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

require("treesitter-context").setup({
	enable = true,
	min_window_height = 10,
	multiline_threshold = 5,
})
