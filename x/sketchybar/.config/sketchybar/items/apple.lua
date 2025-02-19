local settings = require("config.settings")
local sbar = require("sketchybar")

local apple = sbar.add("item", "apple", {
  icon = { string = settings.icons.text.apple },
  label = { drawing = false },
  click_script = "~/.config/sketchybar/bridge/menus/bin/menus -s 0"
})
