return {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"uv.lock",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		".python-version",
		".git",
		".jj"
	},
	settings = {
		ty = {
			diagnosticMode = "workspace"
		}
	}
}
