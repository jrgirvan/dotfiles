return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git", ".jj" },
	settings = {
		gopls = {
			directoryFilters = {
				"-**/node_modules",
				"-**/.git",
				"-**/vendor",
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = false,
			},
		},
	},
}
