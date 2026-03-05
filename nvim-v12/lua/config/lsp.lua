-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("jdtls")
vim.lsp.enable("kotlin_language_server")
vim.lsp.enable("ts_ls")
vim.lsp.enable("csharp_ls")
vim.lsp.enable("terraformls")
vim.lsp.enable("ty")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("zls")

local function trim_empty_lines(lines)
	local first = 1
	while first <= #lines and lines[first] == "" do
		first = first + 1
	end

	local last = #lines
	while last >= first and lines[last] == "" do
		last = last - 1
	end

	if first > last then
		return {}
	end

	return vim.list_slice(lines, first, last)
end

local function hover_lines(result, bufnr)
	if not (result and result.contents) then
		return nil
	end

	local lines
	if type(result.contents) == "table" and result.contents.kind == "plaintext" then
		lines = vim.split(result.contents.value or "", "\n", { trimempty = true })
	else
		lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
		lines = trim_empty_lines(lines)
	end

	if not lines or vim.tbl_isempty(lines) then
		return nil
	end

	if #lines == 1 and not lines[1]:match("^```") then
		local filetype = vim.bo[bufnr].filetype
		local language = filetype ~= "" and filetype or "text"
		return {
			string.format("```%s", language),
			lines[1],
			"```",
		}
	end

	return lines
end

local function hover()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" })
	if vim.tbl_isempty(clients) then
		vim.notify(vim.lsp._unsupported_method("textDocument/hover"), vim.log.levels.WARN)
		return
	end

	local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding)
	local config = { border = "rounded", focus_id = "textDocument/hover" }

	vim.lsp.buf_request_all(bufnr, "textDocument/hover", params, function(results, ctx)
		if vim.api.nvim_get_current_buf() ~= bufnr then
			return
		end

		for _, response in pairs(results) do
			if response.err then
				vim.lsp.log.error(response.err.code, response.err.message)
			elseif response.result and response.result.contents then
				local lines = hover_lines(response.result, ctx.bufnr)
				if lines then
					return vim.lsp.util.open_floating_preview(lines, "markdown", config)
				end
			end
		end

		vim.notify("No information available", vim.log.levels.INFO)
	end)
end

_G.lsp_hover = hover

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "K", hover, opts)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		--vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

-- Diagnostics
vim.diagnostic.config({
	-- Use the default configuration
	-- virtual_lines = true

	-- Alternatively, customize specific options
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})
