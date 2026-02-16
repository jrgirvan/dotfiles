local config_dir = os.getenv("CONFIG_DIR")
local menu_bin = config_dir .. "/helpers/menus/bin/menus"
SBAR.add("item", "control_center", {
	position = "right",
	icon = { string = "󰔡", color = COLORS.icon.control_center, font = { size = DEFAULT_ITEM.icon.font.size * 1.4 } },
	label = { drawing = false },
	click_script = menu_bin .. " -s 'Control Centre,BentoBox-0'",
})
