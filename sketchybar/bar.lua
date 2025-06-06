local settings = require("config.settings")
local sbar = require("sketchybar")

sbar.bar({
	position = "right",
	height = settings.dimens.graphics.bar.height,
	color = settings.colors.bar.transparent,
	padding_right = settings.dimens.padding.bar,
	padding_left = settings.dimens.padding.bar,
	margin = settings.dimens.padding.margin,
	corner_radius = settings.dimens.graphics.background.corner_radius,
	y_offset = settings.dimens.graphics.bar.offset,
	blur_radius = settings.dimens.graphics.blur_radius,
	--border_width = 0,
})
