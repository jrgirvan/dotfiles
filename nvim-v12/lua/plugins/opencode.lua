-- vim.pack.add is in lua/plugins/pack.lua
-- vim.pack.add({ "https://github.com/NickvanDyke/opencode.nvim"})

vim.o.autoread = true

---@type opencode.Opts
vim.g.opencode_opts = {}

vim.keymap.set({ "n", "t" }, "<leader>oo", function()
	require("opencode").toggle()
end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "t" }, vim.keycode("<C-s>"), function()
	require("opencode").toggle()
end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "x" }, "<leader>oa", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask about this" })
vim.keymap.set({ "n", "x" }, "<C-x>", function()
	require("opencode").select()
end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "x" }, "go", function()
	return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })
vim.keymap.set("n", "goo", function()
	return require("opencode").operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })
vim.keymap.set("n", "<s-c-u>", function()
	require("opencode").command("session.half.page.up")
end, { desc = "Scroll opencode up" })
vim.keymap.set("n", "<s-c-d>", function()
	require("opencode").command("session.half.page.down")
end, { desc = "Scroll opencode down" })
