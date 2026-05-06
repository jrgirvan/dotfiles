local jj_changed_files = require("config.jj_changed_files")

local function assert_same(expected, actual)
	local expected_json = vim.json.encode(expected)
	local actual_json = vim.json.encode(actual)

	if expected_json ~= actual_json then
		error(string.format("expected %s, got %s", expected_json, actual_json), 2)
	end
end

assert_same({
	{ display = "lua/config/jj_signs.lua", ordinal = "lua/config/jj_signs.lua", value = "lua/config/jj_signs.lua" },
	{ display = "tests/jj_signs_spec.lua", ordinal = "tests/jj_signs_spec.lua", value = "tests/jj_signs_spec.lua" },
}, jj_changed_files.parse_name_only_output("lua/config/jj_signs.lua\n\ntests/jj_signs_spec.lua\n"))

assert_same(
	{ "jj", "diff", "--git", "-r", "@", "--", "lua/config/jj_signs.lua" },
	jj_changed_files.diff_command({
		value = "lua/config/jj_signs.lua",
	})
)
