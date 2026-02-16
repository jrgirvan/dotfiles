local calendar = SBAR.add("item", "calendar", {
  position = "right",
  icon = { drawing = false },
  label = { color = COLORS.icon.calendar },
  update_freq = 30,
})

local function update_calendar()
  calendar:set({ label = { string = os.date("%e %b  %H:%M"):gsub("^%s+", "") } })
end

calendar:subscribe({ "routine", "system_woke" }, update_calendar)
calendar:subscribe("mouse.clicked", function()
  SBAR.exec("open -a Calendar")
end)

update_calendar()
