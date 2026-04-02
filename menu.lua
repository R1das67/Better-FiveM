local menuOpen = true
local isStandby = false
local selectedIndex = 1
_G.ShootDelay = 50 
_G.WalkSpeedVal = 1.0
_G.SprintSpeedVal = 1.0

_G.Settings = {
    autoShoot = false,
    autoAim = false,
    walkSpeed = false,
    sprintSpeed = false
}

local options = {
    {label = "🔫AutoShoot", type = "toggle", key = "autoShoot"},
    {label = "🎯AutoAim", type = "toggle", key = "autoAim"},
    {label = "AutoShoot Reaktionszeit", type = "slider", key = "shootDelay"},
    {label = "🚶🏻‍♂️WalkSpeed", type = "toggle", key = "walkSpeed"},
    {label = "Walk Geschwindigkeit", type = "slider", key = "walkSpeedVal"},
    {label = "🏃🏻‍♂️SprintSpeed", type = "toggle", key = "sprintSpeed"},
    {label = "Sprint Geschwindigkeit", type = "slider", key = "sprintSpeedVal"}
}

function DrawText2D(x, y, text, scale, r, g, b, font, center)
    SetTextFont(font or 4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, 255)
    if center then SetTextCentre(true) end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function IsMouseInArea(x, y, width, height)
    local mx, my = GetControlNormal(0, 239), GetControlNormal(0, 240)
    return mx >= x - width/2 and mx <= x + width/2 and my >= y - height/2 and my <= y + height/2
end

function DrawMenu()
    if isStandby then
        DrawRect(0.15, 0.15, 0.04, 0.07, 25, 25, 25, 240)
        DrawText2D(0.15, 0.13, "💸", 0.6, 255, 255, 255, 0, true)
        if IsDisabledControlJustPressed(0, 24) and IsMouseInArea(0.15, 0.15, 0.04, 0.07) then
            isStandby = false
            menuOpen = true
        end
        return
    end

    if not menuOpen then return end

    DrawRect(0.15, 0.45, 0.22, 0.65, 25, 25, 25, 240)
    DrawText2D(0.045, 0.13, "💸Better FiveM💸", 0.32, 255, 255, 255, 0)
    DrawText2D(0.23, 0.13, "v", 0.4, 255, 255, 255, 0)
    DrawText2D(0.25, 0.13, "X", 0.4, 255, 0, 0, 0)
    DrawRect(0.15, 0.17, 0.2, 0.001, 255, 255, 255, 150)

    for i, opt in ipairs(options) do
        local yPos = 0.16 + (i * 0.05)
        local isSelected = (i == selectedIndex)
        
        DrawText2D(0.045, yPos, opt.label, 0.4, 255, 255, 255)
        DrawRect(0.19, yPos + 0.02, 0.0005, 0.03, 255, 255, 255, 100)

        if opt.type == "toggle" then
            local status = _G.Settings[opt.key]
            DrawText2D(0.20, yPos, "Status: [", 0.35, 255, 255, 255)
            local onR, onG, onB = 255, 255, 255
            if status then onR, onG, onB = 0, 255, 0 end
            DrawText2D(0.237, yPos, "ON", 0.35, onR, onG, onB)
            DrawText2D(0.252, yPos, "/", 0.35, 255, 255, 255)
            local offR, offG, offB = 255, 255, 255
            if not status then offR, offG, offB = 255, 0, 0 end
            DrawText2D(0.26, yPos, "OFF", 0.35, offR, offG, offB)
            DrawText2D(0.278, yPos, "]", 0.35, 255, 255, 255)
        elseif opt.type == "slider" then
            local val = 0
            if opt.key == "shootDelay" then val = _G.ShootDelay elseif opt.key == "walkSpeedVal" then val = _G.WalkSpeedVal elseif opt.key == "sprintSpeedVal" then val = _G.SprintSpeedVal end
            DrawText2D(0.20, yPos, "[" .. val .. "](km/h)", 0.35, 255, 255, 255)
        end

        if isSelected then
            DrawRect(0.042, yPos + 0.02, 0.002, 0.025, 255, 255, 255, 255)
        end
    end

    if IsDisabledControlJustPressed(0, 24) then
        if IsMouseInArea(0.23, 0.14, 0.02, 0.03) then isStandby = true menuOpen = false
        elseif IsMouseInArea(0.25, 0.14, 0.02, 0.03) then menuOpen = false _G.Settings.autoShoot = false _G.Settings.autoAim = false _G.Settings.walkSpeed = false _G.Settings.sprintSpeed = false end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 166) and not isStandby then menuOpen = not menuOpen end
        if menuOpen or isStandby then
            ShowCursorThisFrame()
            DisableControlAction(0, 24, true) 
            if menuOpen then
                if IsControlJustPressed(0, 172) then selectedIndex = selectedIndex > 1 and selectedIndex - 1 or #options
                elseif IsControlJustPressed(0, 173) then selectedIndex = selectedIndex < #options and selectedIndex + 1 or 1 end
                local current = options[selectedIndex]
                if current.type == "toggle" then
                    if IsControlJustPressed(0, 174) then _G.Settings[current.key] = false
                    elseif IsControlJustPressed(0, 175) or IsControlJustPressed(0, 176) then _G.Settings[current.key] = true end
                elseif current.type == "slider" then
                    if IsControlPressed(0, 174) then 
                        if current.key == "shootDelay" then _G.ShootDelay = math.max(0, _G.ShootDelay - 1)
                        elseif current.key == "walkSpeedVal" then _G.WalkSpeedVal = math.max(1, _G.WalkSpeedVal - 1)
                        elseif current.key == "sprintSpeedVal" then _G.SprintSpeedVal = math.max(1, _G.SprintSpeedVal - 1) end
                        Citizen.Wait(50)
                    elseif IsControlPressed(0, 175) then 
                        if current.key == "shootDelay" then _G.ShootDelay = math.min(100, _G.ShootDelay + 1)
                        elseif current.key == "walkSpeedVal" then _G.WalkSpeedVal = math.min(100, _G.WalkSpeedVal + 1)
                        elseif current.key == "sprintSpeedVal" then _G.SprintSpeedVal = math.min(100, _G.SprintSpeedVal + 1) end
                        Citizen.Wait(50) 
                    end
                end
            end
            DrawMenu()
        end
    end
end)