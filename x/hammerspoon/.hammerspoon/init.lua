--[[ Move current window to a specific space
function moveWindowToSpace(spaceNumber)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No window focused")
        return
    end

    -- Get all spaces
    local spaces = hs.spaces.spacesForScreen()

    -- Ensure the requested space exists
    if spaceNumber > #spaces then
        hs.alert.show("Space " .. spaceNumber .. " does not exist")
        return
    end

    -- Move the window to the specified space
    local targetSpace = spaces[spaceNumber]
    local ok, err = hs.spaces.moveWindowToSpace(win, targetSpace, true)
    hs.alert.show("move window to Space " .. spaceNumber .. ": " .. tostring(ok))
    -- Optional: move to the new space
    --hs.spaces.gotoSpace(targetSpace)

    hs.alert.show("Moved to Space " .. spaceNumber)
end

-- Bind Alt+Shift+[Number] to move windows
for i = 1, 9 do
    hs.hotkey.bind({ "alt", "shift" }, tostring(i), function()
        moveWindowToSpace(i)
    end)
end
]]
