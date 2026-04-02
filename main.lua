Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if _G.Settings.autoAim or _G.Settings.autoShoot then
            local handle, ped = FindFirstPed()
            local success
            local target = nil
            repeat
                if ped ~= playerPed and not IsPedDeadOrDying(ped, 1) then
                    local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(ped))
                    if dist < 50.0 and HasEntityClearLoSToEntity(playerPed, ped, 17) then
                        target = ped
                        break
                    end
                end
                success, ped = FindNextPed(handle)
            until not success
            EndFindPed(handle)

            if target then
                local head = GetPedBoneCoords(target, 31086, 0.0, 0.0, 0.0)
                if _G.Settings.autoAim then
                    TaskAimGunAtCoord(playerPed, head, -1, true, true)
                end
                if _G.Settings.autoShoot and IsPlayerFreeAimingAtEntity(PlayerId(), target) then
                    if _G.ShootDelay and _G.ShootDelay > 0 then
                        Citizen.Wait(_G.ShootDelay)
                    end
                    SetControlValueNextFrame(0, 24, 1.0)
                end
            end
        end

        if _G.Settings.walkSpeed then
            SetPedMoveRateOverride(playerPed, _G.WalkSpeedVal / 10.0)
        end

        if _G.Settings.sprintSpeed then
            if IsPedSprinting(playerPed) then
                SetRunSprintMultiplierForPlayer(PlayerId(), math.min(1.49, _G.SprintSpeedVal / 10.0))
            else
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            end
        end
    end
end)