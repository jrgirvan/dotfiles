-- Weather item for Rolleston, NZ using wttr.in
local location = "Rolleston,NZ"
local update_interval = 900 -- 15 minutes

-- Manual UTF-8 encoder (no dependency on utf8 lib)
local function uchar(cp)
  if cp < 0x80 then
    return string.char(cp)
  elseif cp < 0x800 then
    return string.char(
      0xC0 + math.floor(cp / 64),
      0x80 + (cp % 64)
    )
  elseif cp < 0x10000 then
    return string.char(
      0xE0 + math.floor(cp / 4096),
      0x80 + math.floor((cp % 4096) / 64),
      0x80 + (cp % 64)
    )
  end
end

-- Nerd Font weather icons mapped from wttr.in weather codes
-- https://www.worldweatheronline.com/weather-api/api/docs/weather-icons.aspx
-- stylua: ignore
local weather_icons = {
  [113] = uchar(0xe30d), -- Sunny / Clear
  [116] = uchar(0xe302), -- Partly cloudy
  [119] = uchar(0xe312), -- Cloudy
  [122] = uchar(0xe312), -- Overcast
  [143] = uchar(0xe313), -- Mist
  [176] = uchar(0xe308), -- Patchy rain possible
  [179] = uchar(0xe30a), -- Patchy snow possible
  [182] = uchar(0xe3aa), -- Patchy sleet possible
  [185] = uchar(0xe3aa), -- Patchy freezing drizzle
  [200] = uchar(0xe31d), -- Thundery outbreaks possible
  [227] = uchar(0xe30a), -- Blowing snow
  [230] = uchar(0xe30a), -- Blizzard
  [248] = uchar(0xe313), -- Fog
  [260] = uchar(0xe313), -- Freezing fog
  [263] = uchar(0xe309), -- Patchy light drizzle
  [266] = uchar(0xe309), -- Light drizzle
  [281] = uchar(0xe309), -- Freezing drizzle
  [284] = uchar(0xe309), -- Heavy freezing drizzle
  [293] = uchar(0xe308), -- Patchy light rain
  [296] = uchar(0xe308), -- Light rain
  [299] = uchar(0xe318), -- Moderate rain at times
  [302] = uchar(0xe318), -- Moderate rain
  [305] = uchar(0xe318), -- Heavy rain at times
  [308] = uchar(0xe318), -- Heavy rain
  [311] = uchar(0xe309), -- Light freezing rain
  [314] = uchar(0xe318), -- Moderate/heavy freezing rain
  [317] = uchar(0xe3aa), -- Light sleet
  [320] = uchar(0xe3aa), -- Moderate/heavy sleet
  [323] = uchar(0xe30a), -- Patchy light snow
  [326] = uchar(0xe30a), -- Light snow
  [329] = uchar(0xe30a), -- Patchy moderate snow
  [332] = uchar(0xe30a), -- Moderate snow
  [335] = uchar(0xe30a), -- Patchy heavy snow
  [338] = uchar(0xe30a), -- Heavy snow
  [350] = uchar(0xe3aa), -- Ice pellets
  [353] = uchar(0xe308), -- Light rain shower
  [356] = uchar(0xe318), -- Moderate/heavy rain shower
  [359] = uchar(0xe318), -- Torrential rain shower
  [362] = uchar(0xe3aa), -- Light sleet showers
  [365] = uchar(0xe3aa), -- Moderate/heavy sleet showers
  [368] = uchar(0xe30a), -- Light snow showers
  [371] = uchar(0xe30a), -- Moderate/heavy snow showers
  [374] = uchar(0xe3aa), -- Light showers of ice pellets
  [377] = uchar(0xe3aa), -- Moderate/heavy showers of ice pellets
  [386] = uchar(0xe31d), -- Patchy light rain with thunder
  [389] = uchar(0xe31d), -- Moderate/heavy rain with thunder
  [392] = uchar(0xe31d), -- Patchy light snow with thunder
  [395] = uchar(0xe31d), -- Moderate/heavy snow with thunder
}

local default_icon = uchar(0xe302)
local degree = uchar(0x00b0)

-- Wind direction arrows (reversed: wind FROM direction, arrow points TO)
-- stylua: ignore
local wind_arrows = {
  N = uchar(0x2193), S = uchar(0x2191), E = uchar(0x2190), W = uchar(0x2192),
  NE = uchar(0x2199), NW = uchar(0x2198), SE = uchar(0x2196), SW = uchar(0x2197),
  NNE = uchar(0x2199), ENE = uchar(0x2199), NNW = uchar(0x2198), WNW = uchar(0x2198),
  SSE = uchar(0x2196), ESE = uchar(0x2196), SSW = uchar(0x2197), WSW = uchar(0x2197),
}

local weather = SBAR.add("item", "weather", {
  position = "right",
  icon = { string = default_icon, color = COLORS.icon.weather, font = { size = 16.0 } },
  label = { drawing = false },
  update_freq = update_interval,
})

local function update_weather()
  SBAR.exec(
    '/usr/bin/curl -s "wttr.in/' .. location .. '?format=j1"',
    function(result, exit_code)
      -- SbarLua auto-parses JSON into a Lua table
      if type(result) ~= "table" or not result.current_condition then
        return
      end

      local current = result.current_condition[1]
      if not current then
        return
      end

      local temp = current.temp_C
      local wind_speed = current.windspeedKmph
      local wind_dir = current.winddir16Point
      local code = tonumber(current.weatherCode) or 113

      local wicon = weather_icons[code] or default_icon
      local arrow = wind_arrows[wind_dir] or ""
      local tight_padding = DEFAULT_ITEM.icon.padding_right * 0.5

      weather:set({
        icon = { string = wicon, padding_right = tight_padding },
        label = {
          string = temp .. degree .. "C " .. arrow .. wind_speed .. " km/h",
          drawing = true,
        },
      })
    end
  )
end

weather:subscribe({ "routine", "system_woke" }, update_weather)
weather:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    SBAR.exec('open "https://wttr.in/' .. location .. '"')
  else
    update_weather()
  end
end)

SBAR.add("bracket", "weather.bracket", { "weather" }, {
  background = { drawing = true },
})

update_weather()
