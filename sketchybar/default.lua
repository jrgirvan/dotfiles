local settings = require("config.settings")
local sbar = require("sketchybar")

sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.icon,
    },
    color = settings.colors.text,
    padding_left = settings.dimens.padding.icon,
    padding_right = settings.dimens.padding.icon,
  },
  label = {
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.label,
    },
    color = settings.colors.text,
    padding_left = settings.dimens.padding.label,
    padding_right = settings.dimens.padding.label,
  },
  background = {
    padding_left = settings.dimens.padding.label,
    padding_right = settings.dimens.padding.label,
  },
})
