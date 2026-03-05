return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git", ".jj" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true
			},
			checkOnSave = true
		}
	}
}
