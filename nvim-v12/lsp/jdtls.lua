return {
	cmd = {
		"env",
		"JAVA_HOME=/Users/john.girvan/.local/share/mise/installs/java/21.0.2",
		"PATH=/Users/john.girvan/.local/share/mise/installs/java/21.0.2/bin:" .. vim.env.PATH,
		"/opt/homebrew/opt/jdtls/bin/jdtls"
	},
	filetypes = { "java" },
	root_markers = {
		"settings.gradle",
		"settings.gradle.kts",
		"build.gradle",
		"build.gradle.kts",
		"gradlew",
		"mvnw",
		"pom.xml",
		".git",
		".jj"
	},
	settings = {
		java = {
			import = {
				gradle = {
					enabled = false
				}
			}
		}
	}
}
