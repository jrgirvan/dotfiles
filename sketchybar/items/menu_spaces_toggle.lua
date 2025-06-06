local constants = require("constants")
local settings = require("config.settings")
local sbar = require("sketchybar")

sbar.add("event", constants.events.SWAP_MENU_AND_SPACES)

local function switchToggle(menuToggle)
  local isShowingMenu = menuToggle:query().icon.value == settings.icons.text.switch.on

  menuToggle:set({
    icon = isShowingMenu and settings.icons.text.switch.off or settings.icons.text.switch.on,
    label = isShowingMenu and "Menus" or "Spaces",
  })

  sbar.trigger(constants.events.SWAP_MENU_AND_SPACES, { isShowingMenu = isShowingMenu })
end

local function addToggle()
  local menuToggle = sbar.add("item", constants.items.MENU_TOGGLE, {
    icon = {
      string = settings.icons.text.switch.on
    },
    label = {
      width = 0,
      color = settings.colors.base,
      string = "Spaces",
    },
    background = {
      color = settings.colors.with_alpha(settings.colors.subtext0, 0.0),
    }
  })

  sbar.add("item", constants.items.MENU_TOGGLE .. ".padding", {
    width = settings.dimens.padding.label
  })

  menuToggle:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
      menuToggle:set({
        background = {
          color = { alpha = 1.0 },
          border_color = { alpha = 0.5 },
        },
        icon = { color = settings.colors.base },
        label = { width = "dynamic" }
      })
    end)
  end)

  menuToggle:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
      menuToggle:set({
        background = {
          color = { alpha = 0.0 },
          border_color = { alpha = 0.0 },
        },
        icon = { color = settings.colors.text },
        label = { width = 0 }
      })
    end)
  end)

  menuToggle:subscribe("mouse.clicked", function(env)
    switchToggle(menuToggle)
  end)

  menuToggle:subscribe(constants.events.AEROSPACE_SWITCH, function(env)
    switchToggle(menuToggle)
  end)
end

addToggle()
