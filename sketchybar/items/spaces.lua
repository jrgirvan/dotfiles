local constants = require("constants")
local settings = require("config.settings")
local sbar = require("sketchybar")

local spaces = {}

local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local currentWorkspaceWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaceConfigs <const> = {
  ["1"] = { icon = "󰒱", name = "Slack", display = 1 },
  ["2"] = { icon = "", name = "Coding", display = 1 },
  ["3"] = { icon = "", name = "Web", display = 1 },
  ["4"] = { icon = "", name = "Personal Web", display = 1 },
  ["5"] = { icon = "", name = "Obsidian", display = 1 },
  ["6"] = { icon = "󰌢", name = "Retina", display = 2 }
}

local function selectCurrentWorkspace(focusedWorkspaceName)
  for sid, item in pairs(spaces) do
    if item ~= nil then
      local isSelected = sid == constants.items.SPACES .. "." .. focusedWorkspaceName
      item:set({
        icon = { color = isSelected and settings.colors.base or settings.colors.text },
        label = { color = isSelected and settings.colors.base or settings.colors.text },
        background = { color = isSelected and settings.colors.peach or settings.colors.base },
      })
    end
  end

  sbar.trigger(constants.events.UPDATE_WINDOWS)
end

local function findAndSelectCurrentWorkspace()
  sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(focusedWorkspaceOutput)
    local focusedWorkspaceName = focusedWorkspaceOutput:match("[^\r\n]+")
    selectCurrentWorkspace(focusedWorkspaceName)
  end)
end

local function addWorkspaceItem(workspaceName)
  local spaceName = constants.items.SPACES .. "." .. workspaceName
  local spaceConfig = spaceConfigs[workspaceName]

  spaces[spaceName] = sbar.add("item", spaceName, {
    display = spaceConfig.display,
    icon = {
      string = workspaceName,
      color = settings.colors.text,
    },
    background = {
      color = settings.colors.base,
    },
    click_script = "aerospace workspace " .. workspaceName,
  })

  --[[
  sbar.add("item", spaceName .. ".padding", {
    display = spaceConfig.display,
    width = settings.dimens.padding.label
  })
    --]]
end

local function createWorkspaces()
  sbar.exec(constants.aerospace.LIST_ALL_WORKSPACES, function(workspacesOutput)
    for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
      addWorkspaceItem(workspaceName)
    end

    findAndSelectCurrentWorkspace()
  end)
end

currentWorkspaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
  selectCurrentWorkspace(env.FOCUSED_WORKSPACE)
  sbar.trigger(constants.events.UPDATE_WINDOWS)
end)

createWorkspaces()
