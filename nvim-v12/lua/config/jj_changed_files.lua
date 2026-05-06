local M = {}

function M.parse_name_only_output(output)
	local entries = {}

	for path in (output or ""):gmatch("[^\r\n]+") do
		table.insert(entries, {
			display = path,
			ordinal = path,
			value = path,
		})
	end

	return entries
end

function M.diff_command(entry)
	return { "jj", "diff", "--git", "-r", "@", "--", entry.value }
end

local function get_repo_root()
	local result = vim.system({ "jj", "root" }, { text = true }):wait()
	if result.code ~= 0 or not result.stdout then
		return nil
	end

	return vim.trim(result.stdout)
end

function M.pick_current_commit_files()
	local root = get_repo_root()
	if not root then
		vim.notify("Not in a jj repository", vim.log.levels.WARN)
		return
	end

	local result = vim.system({ "jj", "diff", "--name-only", "-r", "@" }, { cwd = root, text = true }):wait()
	if result.code ~= 0 then
		vim.notify("Unable to list jj changed files", vim.log.levels.ERROR)
		return
	end

	local entries = M.parse_name_only_output(result.stdout)
	if #entries == 0 then
		vim.notify("No files changed in current jj commit", vim.log.levels.INFO)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local previewers = require("telescope.previewers")
	local previewer_utils = require("telescope.previewers.utils")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "JJ changed files",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return entry
				end,
			}),
			sorter = conf.file_sorter({}),
			previewer = previewers.new_buffer_previewer({
				title = "JJ diff",
				define_preview = function(self, entry)
					previewer_utils.job_maker(M.diff_command(entry), self.state.bufnr, {
						cwd = root,
						value = entry.value,
						bufname = "jj-diff://" .. entry.value,
						callback = function(bufnr)
							vim.bo[bufnr].filetype = "diff"
						end,
					})
				end,
			}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection then
						vim.cmd.edit(vim.fs.joinpath(root, selection.value))
					end
				end)

				return true
			end,
		})
		:find()
end

return M
