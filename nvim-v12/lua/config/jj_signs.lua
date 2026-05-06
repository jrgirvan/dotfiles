local M = {}

local namespace = "jj_signs"
local group = vim.api.nvim_create_augroup("JjSigns", { clear = true })

local signs = {
	add = { name = "JjSignAdd", text = "│", texthl = "JjSignAdd" },
	change = { name = "JjSignChange", text = "│", texthl = "JjSignChange" },
	delete = { name = "JjSignDelete", text = "_", texthl = "JjSignDelete" },
}

local function define_signs()
	vim.api.nvim_set_hl(0, "JjSignAdd", { fg = "#90e085", default = true })
	vim.api.nvim_set_hl(0, "JjSignChange", { fg = "#e8dfb8", default = true })
	vim.api.nvim_set_hl(0, "JjSignDelete", { fg = "#d46570", default = true })

	vim.fn.sign_define({
		signs.add,
		signs.change,
		signs.delete,
	})
end

local function get_repo_root(path)
	local result = vim.system({ "jj", "root" }, { cwd = path, text = true }):wait()
	if result.code ~= 0 or not result.stdout then
		return nil
	end

	return vim.trim(result.stdout)
end

local function relative_path(root, path)
	local prefix = root .. "/"
	if path:sub(1, #prefix) == prefix then
		return path:sub(#prefix + 1)
	end

	return path
end

function M.parse_diff(diff)
	local parsed_signs = {}
	local new_line = 0
	local pending_deletes = 0

	local function flush_deletes()
		if pending_deletes > 0 then
			table.insert(parsed_signs, { lnum = math.max(new_line, 1), type = "delete" })
			pending_deletes = 0
		end
	end

	for line in (diff .. "\n"):gmatch("([^\n]*)\n") do
		local hunk_start = line:match("^@@ %-%d+,?%d* %+(%d+),?%d* @@")
		if hunk_start then
			flush_deletes()
			new_line = tonumber(hunk_start) - 1
		elseif line:sub(1, 1) == " " then
			flush_deletes()
			new_line = new_line + 1
		elseif line:sub(1, 1) == "-" and line:sub(1, 3) ~= "---" then
			pending_deletes = pending_deletes + 1
		elseif line:sub(1, 1) == "+" and line:sub(1, 3) ~= "+++" then
			new_line = new_line + 1
			if pending_deletes > 0 then
				table.insert(parsed_signs, { lnum = new_line, type = "change" })
				pending_deletes = pending_deletes - 1
			else
				table.insert(parsed_signs, { lnum = new_line, type = "add" })
			end
		end
	end

	flush_deletes()
	return parsed_signs
end

local function clear(buf)
	vim.fn.sign_unplace(namespace, { buffer = buf })
end

local function place(buf, diff_signs)
	for _, sign in ipairs(diff_signs) do
		vim.fn.sign_place(0, namespace, signs[sign.type].name, buf, {
			lnum = sign.lnum,
			priority = 6,
		})
	end
end

function M.refresh(buf)
	buf = buf or vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= "" then
		return
	end

	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" then
		return
	end

	local root = get_repo_root(vim.fs.dirname(file))
	if not root then
		clear(buf)
		return
	end

	local relpath = relative_path(root, file)
	local result = vim.system({ "jj", "diff", "--git", "-r", "@", "--", relpath }, { cwd = root, text = true }):wait()
	if result.code ~= 0 then
		clear(buf)
		return
	end

	clear(buf)
	place(buf, M.parse_diff(result.stdout or ""))
end

function M.setup()
	define_signs()

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "FocusGained" }, {
		group = group,
		callback = function(args)
			M.refresh(args.buf)
		end,
	})
end

return M
