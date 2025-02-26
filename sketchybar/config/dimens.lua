local padding <const> = {
  background = 8,
  icon = 3,
  label = 8,
  bar = 18,
  margin = 10,
  item = 8,
  popup = 8,
}

local graphics <const> = {
  bar = {
    height = 50,
    offset = 10,
  },
  background = {
    height = 24,
    corner_radius = 9,
  },
  slider = {
    height = 20,
  },
  popup = {
    width = 200,
    large_width = 300,
  },
  blur_radius = 20,
}

local text <const> = {
  icon = 14.0,
  label = 14.0,
}

return {
  padding = padding,
  graphics = graphics,
  text = text,
}
