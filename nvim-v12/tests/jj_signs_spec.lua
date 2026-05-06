local jj_signs = require("config.jj_signs")

local function assert_same(expected, actual)
	local expected_json = vim.json.encode(expected)
	local actual_json = vim.json.encode(actual)

	if expected_json ~= actual_json then
		error(string.format("expected %s, got %s", expected_json, actual_json), 2)
	end
end

local diff = table.concat({
	"diff --git a/example.lua b/example.lua",
	"--- a/example.lua",
	"+++ b/example.lua",
	"@@ -1,4 +1,5 @@",
	" context",
	"-old value",
	"+new value",
	"+added value",
	" remaining",
	"-deleted value",
	"@@ -10,1 +11,0 @@",
	"-trailing deletion",
}, "\n")

assert_same({
	{ lnum = 2, type = "change" },
	{ lnum = 3, type = "add" },
	{ lnum = 4, type = "delete" },
	{ lnum = 10, type = "delete" },
}, jj_signs.parse_diff(diff))
