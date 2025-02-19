local dimens <const> = require("config.dimens")

return {
  text = "BerkeleyMono Nerd Font",
  numbers = "BerkeleySpaceMono Nerd Font",
  icons = function(size)
    local font = "sketchybar-app-font:Regular:"
    return size and font .. size or font .. dimens.text.icon
  end,
  styles = {
    regular = "Regular",
    bold = "Bold",
  }
}
