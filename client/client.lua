els_Vehicles = {}

k = nil
vehName = nil
lightingStage = 0
fps = 0
prevframes = 0
curframes = 0
prevtime = 0
curtime = 0

advisorPattern = {"Right to left", "Left to Right", "Center out"}
advisorPatternSelectedIndex = 1
advisorPatternIndex = 1

lightPatternPrim = 0
lightPatternsPrim = 1
lightPatternSec = 1

local guiEnabled = true
local lastVeh = nil
local lastVehDmgReset = false
local elsVehs = {}

local m_siren_state = {}
local m_soundID_veh = {}
local dualEnable = {}
local d_siren_state = {}
local d_soundID_veh = {}
local h_horn_state = {}
local h_soundID_veh = {}

local curCleanupTime = 0

RegisterNetEvent("els:updateElsVehicles")
AddEventHandler("els:updateElsVehicles", function(vehicles, patterns)
    els_Vehicles = vehicles
    els_patterns = patterns

    lightPatternPrim = 1
    lightPatternSec = 1
    advisorPatternSelectedIndex = 1
end)

RegisterNetEvent("els:changeLightStage_c")
AddEventHandler("els:changeLightStage_c", function(sender, stage, advisor, prim, sec)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then

            local vehNetID = GetVehiclePedIsUsing(ped_s)

            if elsVehs[vehNetID] ~= nil then
                elsVehs[vehNetID].stage = stage
                if (stage == 1) then
                    elsVehs[vehNetID].advisor = true
                elseif (stage == 2) then
                    elsVehs[vehNetID].secondary = true
                elseif (stage == 3) then
                    elsVehs[vehNetID].primary = true
                else
                    elsVehs[vehNetID].advisor = false
                    elsVehs[vehNetID].secondary = false
                    elsVehs[vehNetID].primary = false
                end
                elsVehs[vehNetID].primPattern = prim
                elsVehs[vehNetID].secPattern = sec
                elsVehs[vehNetID].advisorPattern = advisor
            else
                elsVehs[vehNetID] = {}
                elsVehs[vehNetID].stage = stage
                if (stage == 1) then
                    elsVehs[vehNetID].advisor = true
                elseif (stage == 2) then
                    elsVehs[vehNetID].secondary = true
                elseif (stage == 3) then
                    elsVehs[vehNetID].primary = true
                else
                    elsVehs[vehNetID].advisor = false
                    elsVehs[vehNetID].secondary = false
                    elsVehs[vehNetID].primary = false
                end
                elsVehs[vehNetID].primPattern = prim
                elsVehs[vehNetID].secPattern = sec
                elsVehs[vehNetID].advisorPattern = advisor
            end

            
        end
    end
end)

RegisterNetEvent("els:changePartState_c")
AddEventHandler("els:changePartState_c", function(sender, part, newstate)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then
            local vehNetID = GetVehiclePedIsUsing(ped_s)

            if elsVehs[vehNetID] == nil then
                elsVehs[vehNetID] = {}
                elsVehs[vehNetID].stage = 0
                elsVehs[vehNetID].primPattern = 1
                elsVehs[vehNetID].secPattern = 1
                elsVehs[vehNetID].advisorPattern = 1
            end

            elsVehs[vehNetID][part] = newstate
        end
    end
end)

RegisterNetEvent("els:changeAdvisorPattern_c")
AddEventHandler("els:changeAdvisorPattern_c", function(sender, pat)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then

            local vehNetID = GetVehiclePedIsUsing(ped_s)

            if elsVehs[vehNetID] ~= nil then
                elsVehs[vehNetID].advisorPattern = pat
            else
                elsVehs[vehNetID] = {}
                elsVehs[vehNetID].advisorPattern = pat
            end
        end
    end
end)

RegisterNetEvent("els:changeSecondaryPattern_c")
AddEventHandler("els:changeSecondaryPattern_c", function(sender, pat)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then

            local vehNetID = GetVehiclePedIsUsing(ped_s)

            if elsVehs[vehNetID] ~= nil then
                elsVehs[vehNetID].secPattern = pat
            else
                elsVehs[vehNetID] = {}
                elsVehs[vehNetID].secPattern = pat
            end
        end
    end
end)

RegisterNetEvent("els:changePrimaryPattern_c")
AddEventHandler("els:changePrimaryPattern_c", function(sender, pat)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then

            local vehNetID = GetVehiclePedIsUsing(ped_s)

            if elsVehs[vehNetID] ~= nil then
                elsVehs[vehNetID].primPattern = pat
            else
                elsVehs[vehNetID] = {}
                elsVehs[vehNetID].primPattern = pat
            end
        end
    end
end)


RegisterNetEvent("els:setSirenState_c")
AddEventHandler("els:setSirenState_c", function(sender, newstate)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then
            local veh = GetVehiclePedIsUsing(ped_s)
            setSirenState(veh, newstate)
        end
    end
end)

RegisterNetEvent("els:setDualSiren_c")
AddEventHandler("els:setDualSiren_c", function(sender, newstate)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then
            local veh = GetVehiclePedIsUsing(ped_s)
            dualEnable[veh] = newstate
        end
    end
end)

RegisterNetEvent("els:setDualSirenState_c")
AddEventHandler("els:setDualSirenState_c", function(sender, newstate)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then
            local veh = GetVehiclePedIsUsing(ped_s)
            setDualSirenState(veh, newstate)
        end
    end
end)

RegisterNetEvent("els:setHornState_c")
AddEventHandler("els:setHornState_c", function(sender, newstate)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then
            local veh = GetVehiclePedIsUsing(ped_s)
            setHornState(veh, newstate)
        end
    end
end)

RegisterNetEvent("els:setTakedownState_c")
AddEventHandler("els:setTakedownState_c", function(sender, newstate)
    local player_s = GetPlayerFromServerId(sender)
    local ped_s = GetPlayerPed(player_s)
    if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
        if IsPedInAnyVehicle(ped_s, false) then
            local veh = GetVehiclePedIsUsing(ped_s)
            if(elsVehs[veh] == nil) then
                changeLightStage(0, 1, 1, 1)
            end
            if IsVehicleExtraTurnedOn(veh, 11) then
                setExtraState(veh, 11, 1)
            else
                setExtraState(veh, 11, 0)
            end
        end
    end
end)

function useFiretruckSiren(veh)
    local model = GetEntityModel(veh)
    for i = 1, #modelsWithFireSiren, 1 do
        if model == GetHashKey(modelsWithFireSiren[i]) then
            return true
        end
    end
    return false
end

function toggleSirenMute(veh, toggle)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        DisableVehicleImpactExplosionActivation(veh, toggle)
    end
end

function useAmbWarnSiren(veh)
    local model = GetEntityModel(veh)
    for i = 1, #modelsWithAmbWarnSiren, 1 do
        if model == GetHashKey(modelsWithAmbWarnSiren[i]) then
            return true
        end
    end
    return false
end

function setHornState(veh, newstate)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        if newstate ~= h_horn_state[veh] then
                
            if h_soundID_veh[veh] ~= nil then
                StopSound(h_soundID_veh[veh])
                ReleaseSoundId(h_soundID_veh[veh])
                h_soundID_veh[veh] = nil
            end
                        
            if newstate == 1 then
                h_soundID_veh[veh] = GetSoundId()
                if useFiretruckSiren(veh) then
                    PlaySoundFromEntity(h_soundID_veh[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
                else
                    PlaySoundFromEntity(h_soundID_veh[veh], "SIRENS_AIRHORN", veh, 0, 0, 0)
                end
            end             
                
            h_horn_state[veh] = newstate
        end
    end
end

function setDualSirenState(veh, newstate)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        if newstate ~= d_siren_state[veh] then
                
            if d_soundID_veh[veh] ~= nil then
                StopSound(d_soundID_veh[veh])
                ReleaseSoundId(d_soundID_veh[veh])
                d_soundID_veh[veh] = nil
            end
                        
            if newstate == 1 then

                d_soundID_veh[veh] = GetSoundId()
                PlaySoundFromEntity(d_soundID_veh[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
                toggleSirenMute(veh, true)
                
            elseif newstate == 2 then

                d_soundID_veh[veh] = GetSoundId() 
                PlaySoundFromEntity(d_soundID_veh[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
                toggleSirenMute(veh, true)
                
            elseif newstate == 3 then

                d_soundID_veh[veh] = GetSoundId()
                if useFiretruckSiren(veh) then
                    PlaySoundFromEntity(d_soundID_veh[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
                elseif useAmbWarnSiren(veh) then
                    PlaySoundFromEntity(d_soundID_veh[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
                else
                    PlaySoundFromEntity(d_soundID_veh[veh], "VEHICLES_HORNS_POLICE_WARNING", veh, 0, 0, 0)
                end
                toggleSirenMute(veh, true)
                
            else
                toggleSirenMute(veh, true)
                
            end             
                
            d_siren_state[veh] = newstate
        end
    end
end

function setSirenState(veh, newstate)
    if DoesEntityExist(veh) and not IsEntityDead(veh) then
        if newstate ~= m_siren_state[veh] then
                
            if m_soundID_veh[veh] ~= nil then
                StopSound(m_soundID_veh[veh])
                ReleaseSoundId(m_soundID_veh[veh])
                m_soundID_veh[veh] = nil
            end
                        
            if newstate == 1 then

                m_soundID_veh[veh] = GetSoundId()
                PlaySoundFromEntity(m_soundID_veh[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
                toggleSirenMute(veh, true)
                
            elseif newstate == 2 then

                m_soundID_veh[veh] = GetSoundId() 
                PlaySoundFromEntity(m_soundID_veh[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
                toggleSirenMute(veh, true)
                
            elseif newstate == 3 then

                m_soundID_veh[veh] = GetSoundId()
                if useFiretruckSiren(veh) then
                    PlaySoundFromEntity(m_soundID_veh[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
                elseif useAmbWarnSiren(veh) then
                    PlaySoundFromEntity(m_soundID_veh[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
                else
                    PlaySoundFromEntity(m_soundID_veh[veh], "VEHICLES_HORNS_POLICE_WARNING", veh, 0, 0, 0)
                end
                toggleSirenMute(veh, true)
                
            else
                toggleSirenMute(veh, true)
                
            end             
                
            m_siren_state[veh] = newstate
        end
    end
end

function RotAnglesToVec(rot) -- input vector3
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

function changeLightStage(state, advisor, PatternPrim, PatternSec)
    TriggerServerEvent("els:changeLightStage_s", state, advisor, PatternPrim, PatternSec)
end

function changeAdvisorPattern(pat)
    TriggerServerEvent("els:changeAdvisorPattern_s", pat)
end

function changePrimaryPattern(pat)
    TriggerServerEvent("els:changePrimaryPattern_s", pat)
end

function changeSecondaryPattern(pat)
    TriggerServerEvent("els:changeSecondaryPattern_s", pat)
end

function checkCar(car)
    if car then
        carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)

        return carName
    end
end

function checkCarHash(car)
    if car then
        for k,v in pairs(els_Vehicles) do
            if GetEntityModel(car) == GetHashKey(k) then
                return k
            end
        end
    end
end


function canUseAdvisorStageThree(car)
    if (not IsEntityDead(car) and DoesEntityExist(car)) then 
        for k,v in pairs(vehicleStageThreeAdvisor) do
            if GetEntityModel(car) == GetHashKey(v) then
                return true
            end
        end
    end
end

function vehInTable (tab, val)
    for index in pairs(tab) do
        if index == val then
            return true
        end
    end

    return false
end

function setExtraState(veh, extra, state)
    if (not IsEntityDead(veh) and DoesEntityExist(veh)) then
        if els_Vehicles[checkCarHash(veh)].extras[extra] ~= nil then
            if(els_Vehicles[checkCarHash(veh)].extras[extra].enabled) then
                if DoesExtraExist(veh, extra) then
                    SetVehicleExtra(veh, extra, state)
                end
            end
        end
    end
end

function doesVehicleHaveTrafficAdvisor(veh)
    if (not IsEntityDead(veh) and DoesEntityExist(veh)) then 
        for k,v in pairs(modelsWithTrafficAdvisor) do
            if GetEntityModel(veh) == GetHashKey(v) then
                return true
            end
        end
    end
end

function isVehicleELS(veh)
    return vehInTable(els_Vehicles, checkCarHash(veh))
end

function getVehicleLightStage(veh)

    if (elsVehs[veh] ~= nil) then
        return elsVehs[veh].stage
    end
end

function Draw(text, r, g, b, alpha, x, y, width, height, ya, center, font)
    SetTextColour(r, g, b, alpha)
    SetTextFont(font)
    SetTextScale(width, height)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(center)
    SetTextDropshadow(0, 0, 0, 0, 0)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x61BB1D9B3A95D802, ya)
    DrawText(x, y)
end

function hornCleanup()
    for vehicle, state in pairs(h_horn_state) do
        if state >= 0 then
            if not DoesEntityExist(vehicle) or IsEntityDead(vehicle) then
                if h_soundID_veh[vehicle] ~= nil then
                    StopSound(h_soundID_veh[vehicle])
                    ReleaseSoundId(h_soundID_veh[vehicle])
                    h_soundID_veh[vehicle] = nil
                    h_horn_state[vehicle] = nil
                end
            end
        end
    end
end

function sirenCleanup()
    for vehicle, state in pairs(m_siren_state) do
        if m_soundID_veh[vehicle] ~= nil then
            if not DoesEntityExist(vehicle) or IsEntityDead(vehicle) then
                StopSound(m_soundID_veh[vehicle])
                ReleaseSoundId(m_soundID_veh[vehicle])
                m_soundID_veh[vehicle] = nil
                m_siren_state[vehicle] = nil
            end
        end
    end

    for vehicle, state in pairs(d_siren_state) do
        if d_soundID_veh[vehicle] ~= nil then
            if not DoesEntityExist(vehicle) or IsEntityDead(vehicle) then
                StopSound(d_soundID_veh[vehicle])
                ReleaseSoundId(d_soundID_veh[vehicle])
                d_soundID_veh[vehicle] = nil
                d_siren_state[vehicle] = nil
            end
        end
    end
end

function _DrawRect(x, y, width, height, r, g, b, a, ya)
    Citizen.InvokeNative(0x61BB1D9B3A95D802, ya)
    DrawRect(x, y, width, height, r, g, b, a)
end

function vehicleLightCleanup()
    for vehicle,_ in pairs(elsVehs) do
        if elsVehs[vehicle] then
            if not DoesEntityExist(vehicle) or IsEntityDead(vehicle) then
                if elsVehs[vehicle] ~= nil then
                    elsVehs[vehicle] = nil
                end
            end
        end
    end
end

function LghtSoundCleaner()
    if curCleanupTime > 350 then
        curCleanupTime = 0

        vehicleLightCleanup()
        hornCleanup()
        sirenCleanup()

    else
        curCleanupTime = curCleanupTime + 1
    end
end

function changePrimaryPatternMath(way)
    if playButtonPressSounds then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    local primMax = getNumberOfPrimaryPatterns()
    local primMin = 1
    local temp = lightPatternPrim

    temp = temp + way

    if(temp < primMin) then
        temp = primMax
    end

    if(temp > primMax) then
        temp = primMin
    end

    lightPatternPrim = temp

    if temp ~= 0 then lightPatternsPrim = temp end
    changePrimaryPattern(lightPatternsPrim)
end

function changeSecondaryPatternMath(way)
    if playButtonPressSounds then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    local primMax = getNumberOfSecondaryPatterns()
    local primMin = 1
    local temp = lightPatternSec

    temp = temp + way

    if(temp > primMax) then
        temp = primMin
    end

    if(temp < primMin) then
        temp = primMax
    end

    lightPatternSec = temp
    changeSecondaryPattern(lightPatternSec)
end

function changeAdvisorPatternMath(way)
    if playButtonPressSounds then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    
    local primMax = getNumberOfAdvisorPatterns()

    local primMin = 1
    local temp = advisorPatternSelectedIndex

    temp = temp + way

    if(temp < primMin) then
        temp = primMax
    end

    if(temp > primMax) then
        temp = primMin
    end

    advisorPatternSelectedIndex = temp
    changeAdvisorPattern(advisorPatternSelectedIndex)
end

function setSirenStateButton(state)
    if playButtonPressSounds then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    if m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] ~= state then
        TriggerServerEvent("els:setSirenState_s", state)
    elseif m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == state then
        TriggerServerEvent("els:setSirenState_s", 0)
    end
end

function upOneStage()
    if playButtonPressSounds then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    local vehNetID = GetVehiclePedIsUsing(GetPlayerPed(-1))

    local newStage = 1

    if (elsVehs[vehNetID] ~= nil and elsVehs[vehNetID].stage ~= nil) then
        newStage = elsVehs[vehNetID].stage + 1
    end

    if newStage == 1 then
        if not doesVehicleHaveTrafficAdvisor(GetVehiclePedIsUsing(GetPlayerPed(-1))) then
            newStage = 2
        end
    end

    if newStage == 4 then
        newStage = 0
    end

    changeLightStage(newStage, advisorPatternSelectedIndex, lightPatternPrim, lightPatternSec)

    if GetVehicleClass(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 18 then
        if(newStage == 3) then
            SetVehicleSiren(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
            if stagethreewithsiren then
                TriggerServerEvent("els:setSirenState_s", 1)
            end
        else
            SetVehicleSiren(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
            TriggerServerEvent("els:setSirenState_s", 0)
            TriggerServerEvent("els:setDualSirenState_s", 0)
            TriggerServerEvent("els:setDualSiren_s", false)
        end
    end
end

function downOneStage()
    if playButtonPressSounds then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    local vehNetID = GetVehiclePedIsUsing(GetPlayerPed(-1))

    local newStage = 3

    if(elsVehs[vehNetID] ~= nil and elsVehs[vehNetID].stage ~= nil) then
        newStage = elsVehs[vehNetID].stage - 1
    end

    if newStage == 1 then
        if not doesVehicleHaveTrafficAdvisor(GetVehiclePedIsUsing(GetPlayerPed(-1))) then
            newStage = 0
        end
    end

    if newStage == -1 then
        newStage = 3
    end

    changeLightStage(newStage, advisorPatternSelectedIndex, lightPatternPrim, lightPatternSec)

    if GetVehicleClass(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 18 then
        if(newStage == 3) then
            SetVehicleSiren(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
            if stagethreewithsiren then
                TriggerServerEvent("els:setSirenState_s", 1)
            end
        else
            SetVehicleSiren(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
            TriggerServerEvent("els:setSirenState_s", 0)
            TriggerServerEvent("els:setDualSirenState_s", 0)
            TriggerServerEvent("els:setDualSiren_s", false)
        end
    end
end

Citizen.CreateThread(function() --Count FPS (Thanks To siggyfawn [forum.FiveM.net])
    while not NetworkIsPlayerActive(PlayerId()) or not NetworkIsSessionStarted() do
        Citizen.Wait(0)
        prevframes = GetFrameCount()
        prevtime = GetGameTimer()
    end

    while true do
        curtime = GetGameTimer()
        curframes = GetFrameCount()

        if((curtime - prevtime) > 1000) then
            fps = (curframes - prevframes) - 1              
            prevtime = curtime
            prevframes = curframes
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()

    TriggerServerEvent("els:requestVehiclesUpdate")

    while true do

        if vehInTable(els_Vehicles, checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
            if (GetPedInVehicleSeat(GetVehiclePedIsUsing(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) or
                (GetPedInVehicleSeat(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0) == GetPlayerPed(-1)) then

                if GetVehicleClass(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 18 then
                    DisableControlAction(0, shared.horn, true)
                end
                
                DisableControlAction(0, 84, true) -- INPUT_VEH_PREV_RADIO_TRACK  
                DisableControlAction(0, 83, true) -- INPUT_VEH_NEXT_RADIO_TRACK 
                DisableControlAction(0, 81, true) -- INPUT_VEH_NEXT_RADIO
                DisableControlAction(0, 82, true) -- INPUT_VEH_PREV_RADIO
                DisableControlAction(0, 85, true) -- INPUT_VEH_PREV_RADIO

                SetVehRadioStation(GetVehiclePedIsUsing(GetPlayerPed(-1)), "OFF")
                SetVehicleRadioEnabled(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)

                if(GetLastInputMethod(0)) then
                    DisableControlAction(0, keyboard.stageChange, true)

                    DisableControlAction(0, keyboard.pattern.primary, true)
                    DisableControlAction(0, keyboard.pattern.secondary, true)
                    DisableControlAction(0, keyboard.pattern.advisor, true)
                    DisableControlAction(0, keyboard.modifyKey, true)

                    DisableControlAction(0, keyboard.siren.tone_one, true)
                    DisableControlAction(0, keyboard.siren.tone_two, true)
                    DisableControlAction(0, keyboard.siren.tone_three, true)
                    DisableControlAction(0, keyboard.siren.dual_toggle, true)
                    DisableControlAction(0, keyboard.siren.dual_one, true)
                    DisableControlAction(0, keyboard.siren.dual_two, true)
                    DisableControlAction(0, keyboard.siren.dual_three, true)

                    DisableControlAction(0, 311, true)
                    DisableControlAction(0, 7, true)

                    if IsDisabledControlJustPressed(0, 311) then
                        if playButtonPressSounds then
                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                        end
                        if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))] ~= nil then
                            if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))].primary then
                                TriggerServerEvent("els:changePartState_s", "primary", false)
                            else
                                TriggerServerEvent("els:changePartState_s", "primary", true)
                            end
                        else
                            TriggerServerEvent("els:changePartState_s", "primary", true)
                        end
                    end

                    if IsDisabledControlJustPressed(0, 7) then
                        if playButtonPressSounds then
                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                        end
                        if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))] ~= nil then
                            if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))].secondary then
                                TriggerServerEvent("els:changePartState_s", "secondary", false)
                            else
                                TriggerServerEvent("els:changePartState_s", "secondary", true)
                            end
                        else
                            TriggerServerEvent("els:changePartState_s", "secondary", true)
                        end
                    end

                    if IsDisabledControlPressed(0, keyboard.modifyKey) then
                        if IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.pattern.primary) then
                            changePrimaryPatternMath(-1)
                        end

                        if IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.pattern.secondary) then
                            changeSecondaryPatternMath(-1)
                        end
                    else
                        if IsDisabledControlJustReleased(0, keyboard.pattern.primary) then
                            changePrimaryPatternMath(1)
                        end

                        if IsDisabledControlJustReleased(0, keyboard.pattern.secondary) then
                            changeSecondaryPatternMath(1)
                        end
                    end

                    if (doesVehicleHaveTrafficAdvisor(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
                        if IsDisabledControlPressed(0, keyboard.modifyKey) then
                            if IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.pattern.advisor) then
                                changeAdvisorPatternMath(-1)
                            end
                        else
                            if IsDisabledControlJustReleased(0, keyboard.pattern.advisor) then
                                changeAdvisorPatternMath(1)
                            end
                        end
                    end

                    if GetVehicleClass(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 18 then
                        if (elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))] ~= nil) then
                            if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))].stage == 3 then
                                if IsDisabledControlJustReleased(0, keyboard.siren.tone_one) then
                                    setSirenStateButton(1)
                                end
                                if IsDisabledControlJustReleased(0, keyboard.siren.tone_two) then
                                    setSirenStateButton(2)
                                end
                                if IsDisabledControlJustReleased(0, keyboard.siren.tone_three) then
                                    setSirenStateButton(3)
                                end


                                if IsDisabledControlJustReleased(0, keyboard.siren.dual_toggle) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    if dualEnable[GetVehiclePedIsUsing(GetPlayerPed(-1))] then
                                        TriggerServerEvent("els:setDualSiren_s", false)
                                        TriggerServerEvent("els:setDualSirenState_s", 0)
                                    else
                                        TriggerServerEvent("els:setDualSiren_s", true)
                                    end
                                end
                                if dualEnable[GetVehiclePedIsUsing(GetPlayerPed(-1))] then
                                    if IsDisabledControlJustReleased(0, keyboard.siren.dual_one) then
                                        if playButtonPressSounds then
                                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                        end
                                        TriggerServerEvent("els:setDualSirenState_s", 1)
                                    end

                                    if IsDisabledControlJustReleased(0, keyboard.siren.dual_two) then
                                        if playButtonPressSounds then
                                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                        end
                                        TriggerServerEvent("els:setDualSirenState_s", 2)
                                    end

                                    if IsDisabledControlJustReleased(0, keyboard.siren.dual_three) then
                                        if playButtonPressSounds then
                                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                        end
                                        TriggerServerEvent("els:setDualSirenState_s", 3)
                                    end
                                end

                            end
                            if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))].stage == 2 then
                                if IsDisabledControlJustReleased(0, keyboard.siren.tone_one) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 0)
                                end
                                if IsDisabledControlJustPressed(0, keyboard.siren.tone_one) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 1)
                                end

                                if IsDisabledControlJustReleased(0, keyboard.siren.tone_two) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 0)
                                end
                                if IsDisabledControlJustPressed(0, keyboard.siren.tone_two) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 2)
                                end

                                if IsDisabledControlJustReleased(0, keyboard.siren.tone_three) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 0)
                                end
                                if IsDisabledControlJustPressed(0, keyboard.siren.tone_three) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 3)
                                end
                            end
                        end
                    end

                    if IsDisabledControlPressed(0, keyboard.modifyKey) then
                        DisableControlAction(0, keyboard.takedown, true)
                        DisableControlAction(0, keyboard.guiKey, true)

                        if IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.guiKey) then
                            if playButtonPressSounds then
                                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            end
                            if guiEnabled then
                                guiEnabled = false
                            else
                                guiEnabled = true
                            end
                        end

                        if IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.takedown) then
                            if playButtonPressSounds then
                                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            end
                            TriggerServerEvent("els:setTakedownState_s")
                        end
                    end

                    if els_Vehicles[checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))].activateUp then

                        if IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.stageChange) then
                            downOneStage()
                        elseif IsDisabledControlJustReleased(0, keyboard.stageChange) then
                            upOneStage()
                        end
                    else
                        if IsDisabledControlJustReleased(0, keyboard.stageChange) then
                            downOneStage()
                        elseif IsDisabledControlPressed(0, keyboard.modifyKey) and IsDisabledControlJustReleased(0, keyboard.stageChange) then
                            upOneStage()
                        end
                    end
                else
                    DisableControlAction(0, controller.modifyKey, true)
                    DisableControlAction(0, controller.stageChange, true)
                    DisableControlAction(0, controller.siren.tone_one, true)
                    DisableControlAction(0, controller.siren.tone_two, true)
                    DisableControlAction(0, controller.siren.tone_three, true)

                    if els_Vehicles[checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))].activateUp then
                        if IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, controller.stageChange) then
                            downOneStage()
                        elseif IsDisabledControlJustReleased(0, controller.stageChange) then
                            upOneStage()
                        end
                    else
                        if IsDisabledControlJustReleased(0, controller.stageChange) then
                            downOneStage()
                        elseif IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, controller.stageChange) then
                            upOneStage()
                        end
                    end

                    if IsDisabledControlPressed(0, controller.modifyKey) then
                        DisableControlAction(0, controller.takedown, true)
                        if IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, controller.takedown) then
                            if playButtonPressSounds then
                                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            end
                            TriggerServerEvent("els:setTakedownState_s")
                        end
                    end

                    if GetVehicleClass(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 18 then
                        if (elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))] ~= nil) then
                            if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))].stage == 3 then
                                if not IsDisabledControlPressed(0, controller.modifyKey) then
                                    if IsDisabledControlJustReleased(0, controller.siren.tone_one) then
                                        setSirenStateButton(1)
                                    end
                                    if IsDisabledControlJustReleased(0, controller.siren.tone_two) then
                                        setSirenStateButton(2)
                                    end
                                    if IsDisabledControlJustReleased(0, controller.siren.tone_three) then
                                        setSirenStateButton(3)
                                    end
                                end

                                if IsDisabledControlPressed(0, controller.modifyKey) then

                                    if IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, shared.horn) then
                                        if playButtonPressSounds then
                                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                        end
                                        if dualEnable[GetVehiclePedIsUsing(GetPlayerPed(-1))] then
                                            TriggerServerEvent("els:setDualSiren_s", false)
                                            TriggerServerEvent("els:setDualSirenState_s", 0)
                                        else
                                            TriggerServerEvent("els:setDualSiren_s", true)
                                        end
                                    end
                                    if dualEnable[GetVehiclePedIsUsing(GetPlayerPed(-1))] then
                                        if IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, controller.siren.tone_one) then
                                            if playButtonPressSounds then
                                                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                            end
                                            TriggerServerEvent("els:setDualSirenState_s", 1)
                                        end

                                        if IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, controller.siren.tone_two) then
                                            if playButtonPressSounds then
                                                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                            end
                                            TriggerServerEvent("els:setDualSirenState_s", 2)
                                        end

                                        if IsDisabledControlPressed(0, controller.modifyKey) and IsDisabledControlJustReleased(0, controller.siren.tone_three) then
                                            if playButtonPressSounds then
                                                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                            end
                                            TriggerServerEvent("els:setDualSirenState_s", 3)
                                        end
                                    end
                                end

                            end
                            if elsVehs[GetVehiclePedIsUsing(GetPlayerPed(-1))].stage == 2 then
                                if IsDisabledControlJustReleased(0, controller.siren.tone_one) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 0)
                                end
                                if IsDisabledControlJustPressed(0, controller.siren.tone_one) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 1)
                                end

                                if IsDisabledControlJustReleased(0, controller.siren.tone_two) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 0)
                                end
                                if IsDisabledControlJustPressed(0, controller.siren.tone_two) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 2)
                                end

                                if IsDisabledControlJustReleased(0, controller.siren.tone_three) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 0)
                                end
                                if IsDisabledControlJustPressed(0, controller.siren.tone_three) then
                                    if playButtonPressSounds then
                                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    end
                                    TriggerServerEvent("els:setSirenState_s", 3)
                                end
                            end
                        end
                    end
                end

                if GetVehicleClass(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 18 then
                    if not IsDisabledControlPressed(0, controller.modifyKey) then
                        if (IsDisabledControlJustPressed(0, shared.horn)) then
                            TriggerServerEvent("els:setHornState_s", 1)
                        end

                        if (IsDisabledControlJustReleased(0, shared.horn)) then
                            TriggerServerEvent("els:setHornState_s", 0)
                        end
                    end
                end
            end
        else
            lastVeh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if panelOffsetX ~= nil and panelOffsetY ~= nil then
            if guiEnabled and vehInTable(els_Vehicles, checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
                if (GetPedInVehicleSeat(GetVehiclePedIsUsing(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) or
                    (GetPedInVehicleSeat(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0) == GetPlayerPed(-1)) then
                    local vehN = checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))

                    _DrawRect(0.85 + panelOffsetX, 0.91 + panelOffsetY, 0.24, 0.11, 0, 0, 0, 200, 0)

                    if (getVehicleLightStage(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 1) then
                        _DrawRect(0.75 + panelOffsetX, 0.88 + panelOffsetY, 0.03, 0.02, 173, 0, 0, 225, 0)
                        Draw("1", 0, 0, 0, 255, 0.75 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.75 + panelOffsetX, 0.88 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("1", 0, 0, 0, 255, 0.75 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    if (getVehicleLightStage(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 2) then
                        _DrawRect(0.784 + panelOffsetX, 0.88 + panelOffsetY, 0.03, 0.02, 173, 0, 0, 225, 0)
                        Draw("2", 0, 0, 0, 255, 0.784 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.784 + panelOffsetX, 0.88 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("2", 0, 0, 0, 255, 0.784 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    if (getVehicleLightStage(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 3) then
                        _DrawRect(0.817 + panelOffsetX, 0.88 + panelOffsetY, 0.03, 0.02, 173, 0, 0, 225, 0)
                        Draw("3", 0, 0, 0, 255, 0.817 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.817 + panelOffsetX, 0.88 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("3", 0, 0, 0, 255, 0.817 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    _DrawRect(0.854 + panelOffsetX, 0.88 + panelOffsetY, 0.035, 0.02, 186, 186, 186, 225, 0)
                    Draw("PRIM " .. tostring(lightPatternPrim), 0, 0, 0, 255, 0.854 + panelOffsetX, 0.87 + panelOffsetY, 0.25, 0.25, 1, true, 0)

                    _DrawRect(0.854 + panelOffsetX, 0.91 + panelOffsetY, 0.035, 0.02, 186, 186, 186, 225, 0)
                    Draw("SEC " .. tostring(lightPatternSec), 0, 0, 0, 255, 0.854 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)

                    if (doesVehicleHaveTrafficAdvisor(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
                        _DrawRect(0.854 + panelOffsetX, 0.94 + panelOffsetY, 0.035, 0.02, 186, 186, 186, 225, 0)
                        Draw("ADV " .. tostring(advisorPatternSelectedIndex), 0, 0, 0, 255, 0.854 + panelOffsetX, 0.93 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    if (h_horn_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                        _DrawRect(0.75 + panelOffsetX, 0.91 + panelOffsetY, 0.03, 0.02, 0, 173, 0, 225, 0)
                        Draw("HORN", 0, 0, 0, 255, 0.75 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.75 + panelOffsetX, 0.91 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("HORN", 0, 0, 0, 255, 0.75 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    if (dualEnable[GetVehiclePedIsUsing(GetPlayerPed(-1))]) then
                        _DrawRect(0.784 + panelOffsetX, 0.91 + panelOffsetY, 0.03, 0.02, 0, 213, 255, 225, 0)
                        Draw("DUAL", 0, 0, 0, 255, 0.784 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.784 + panelOffsetX, 0.91 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("DUAL", 0, 0, 0, 255, 0.784 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    if (IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 11)) then
                        _DrawRect(0.817 + panelOffsetX, 0.91 + panelOffsetY, 0.03, 0.02, 255, 0, 0, 255, 0)
                        Draw("TKD", 0, 0, 0, 255, 0.817 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.817 + panelOffsetX, 0.91 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("TKD", 0, 0, 0, 255, 0.817 + panelOffsetX, 0.9 + panelOffsetY, 0.25, 0.25, 1, true, 0)
                    end

                    if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                        if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                            _DrawRect(0.743 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.02, 0, 173, 0, 225, 0)
                        else
                            _DrawRect(0.75 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 0, 173, 0, 225, 0)
                        end
                    else
                        _DrawRect(0.75 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                    end

                    if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                        if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                            _DrawRect(0.758 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.02, 0, 213, 255, 225, 2)
                        else
                            _DrawRect(0.75 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 0, 213, 255, 225, 0)
                        end
                    end
                    
                    Draw("MAIN", 0, 0, 0, 255, 0.75 + panelOffsetX, 0.93 + panelOffsetY, 0.25, 0.25, 3, true, 0)

                    if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                        if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                            _DrawRect(0.777 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.02, 0, 173, 0, 225, 0)
                        else
                            _DrawRect(0.784 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 0, 173, 0, 225, 0)
                        end
                    else
                        _DrawRect(0.784 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                    end

                    if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                        if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                            _DrawRect(0.792 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.02, 0, 213, 255, 225, 2)
                        else
                            _DrawRect(0.784 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 0, 213, 255, 255, 0)
                        end
                    end

                    Draw("SEC", 0, 0, 0, 255, 0.784 + panelOffsetX, 0.93 + panelOffsetY, 0.25, 0.25, 3, true, 0)

                    if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                        if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                            _DrawRect(0.81 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.02, 0, 173, 0, 225, 0)
                        else
                            _DrawRect(0.817 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 0, 173, 0, 225, 0)
                        end
                    else
                        _DrawRect(0.817 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 186, 186, 186, 225, 0)
                    end

                    if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                        if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                            _DrawRect(0.823 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.02, 0, 213, 255, 225, 2)
                        else
                            _DrawRect(0.817 + panelOffsetX, 0.94 + panelOffsetY, 0.03, 0.02, 0, 213, 255, 255, 0)
                        end
                    end

                    Draw("AUX", 0, 0, 0, 255, 0.817 + panelOffsetX, 0.93 + panelOffsetY, 0.25, 0.25, 3, true, 0)

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 7)) then
                        _DrawRect(0.9 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[7].env_color.r, els_Vehicles[vehN].extras[7].env_color.g, els_Vehicles[vehN].extras[7].env_color.b, 225, 0)
                    else
                        _DrawRect(0.9 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 8)) then
                        _DrawRect(0.92 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[8].env_color.r, els_Vehicles[vehN].extras[8].env_color.g, els_Vehicles[vehN].extras[8].env_color.b, 225, 0)
                    else
                        _DrawRect(0.92 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 9)) then
                        _DrawRect(0.94 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[9].env_color.r, els_Vehicles[vehN].extras[9].env_color.g, els_Vehicles[vehN].extras[9].env_color.b, 225, 0)
                    else
                        _DrawRect(0.94 + panelOffsetX, 0.94 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1)) then
                        _DrawRect(0.89 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[1].env_color.r, els_Vehicles[vehN].extras[1].env_color.g, els_Vehicles[vehN].extras[1].env_color.b, 225, 0)
                    else
                        _DrawRect(0.89 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 2)) then
                        _DrawRect(0.91 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[2].env_color.r, els_Vehicles[vehN].extras[2].env_color.g, els_Vehicles[vehN].extras[2].env_color.b, 225, 0)
                    else
                        _DrawRect(0.91 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 3)) then
                        _DrawRect(0.93 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[3].env_color.r, els_Vehicles[vehN].extras[3].env_color.g, els_Vehicles[vehN].extras[3].env_color.b, 225, 0)
                    else
                        _DrawRect(0.93 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4)) then
                        _DrawRect(0.95 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[4].env_color.r, els_Vehicles[vehN].extras[4].env_color.g, els_Vehicles[vehN].extras[4].env_color.b, 225, 0)
                    else
                        _DrawRect(0.95 + panelOffsetX, 0.92 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 5)) then
                        _DrawRect(0.91 + panelOffsetX, 0.885 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[5].env_color.r, els_Vehicles[vehN].extras[5].env_color.g, els_Vehicles[vehN].extras[5].env_color.b, 225, 0)
                    else
                        _DrawRect(0.91 + panelOffsetX, 0.885 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 6)) then
                        _DrawRect(0.93 + panelOffsetX, 0.885 + panelOffsetY, 0.015, 0.015, els_Vehicles[vehN].extras[6].env_color.r, els_Vehicles[vehN].extras[6].env_color.g, els_Vehicles[vehN].extras[6].env_color.b, 225, 0)
                    else
                        _DrawRect(0.93 + panelOffsetX, 0.885 + panelOffsetY, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end
                end
            end
        else
            if guiEnabled and vehInTable(els_Vehicles, checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
                if (GetPedInVehicleSeat(GetVehiclePedIsUsing(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) or
                    (GetPedInVehicleSeat(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0) == GetPlayerPed(-1)) then
                    local vehN = checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))

                    _DrawRect(0.85, 0.91, 0.24, 0.11, 0, 0, 0, 200, 0)

                    if (getVehicleLightStage(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 1) then
                        _DrawRect(0.75, 0.88, 0.03, 0.02, 173, 0, 0, 225, 0)
                        Draw("1", 0, 0, 0, 255, 0.75, 0.87, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.75, 0.88, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("1", 0, 0, 0, 255, 0.75, 0.87, 0.25, 0.25, 1, true, 0)
                    end

                    if (getVehicleLightStage(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 2) then
                        _DrawRect(0.784, 0.88, 0.03, 0.02, 173, 0, 0, 225, 0)
                        Draw("2", 0, 0, 0, 255, 0.784, 0.87, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.784, 0.88, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("2", 0, 0, 0, 255, 0.784, 0.87, 0.25, 0.25, 1, true, 0)
                    end

                    if (getVehicleLightStage(GetVehiclePedIsUsing(GetPlayerPed(-1))) == 3) then
                        _DrawRect(0.817, 0.88, 0.03, 0.02, 173, 0, 0, 225, 0)
                        Draw("3", 0, 0, 0, 255, 0.817, 0.87, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.817, 0.88, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("3", 0, 0, 0, 255, 0.817, 0.87, 0.25, 0.25, 1, true, 0)
                    end

                    _DrawRect(0.854, 0.88, 0.035, 0.02, 186, 186, 186, 225, 0)
                    Draw("PRIM " .. tostring(lightPatternPrim), 0, 0, 0, 255, 0.854, 0.87, 0.25, 0.25, 1, true, 0)

                    _DrawRect(0.854, 0.91, 0.035, 0.02, 186, 186, 186, 225, 0)
                    Draw("SEC " .. tostring(lightPatternSec), 0, 0, 0, 255, 0.854, 0.9, 0.25, 0.25, 1, true, 0)

                    if (doesVehicleHaveTrafficAdvisor(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
                        _DrawRect(0.854, 0.94, 0.035, 0.02, 186, 186, 186, 225, 0)
                        Draw("ADV " .. tostring(advisorPatternSelectedIndex), 0, 0, 0, 255, 0.854, 0.93, 0.25, 0.25, 1, true, 0)
                    end

                    if (h_horn_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                        _DrawRect(0.75, 0.91, 0.03, 0.02, 0, 173, 0, 225, 0)
                        Draw("HORN", 0, 0, 0, 255, 0.75, 0.9, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.75, 0.91, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("HORN", 0, 0, 0, 255, 0.75, 0.9, 0.25, 0.25, 1, true, 0)
                    end

                    if (dualEnable[GetVehiclePedIsUsing(GetPlayerPed(-1))]) then
                        _DrawRect(0.784, 0.91, 0.03, 0.02, 0, 213, 255, 225, 0)
                        Draw("DUAL", 0, 0, 0, 255, 0.784, 0.9, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.784, 0.91, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("DUAL", 0, 0, 0, 255, 0.784, 0.9, 0.25, 0.25, 1, true, 0)
                    end

                    if (IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 11)) then
                        _DrawRect(0.817, 0.91, 0.03, 0.02, 255, 0, 0, 255, 0)
                        Draw("TKD", 0, 0, 0, 255, 0.817, 0.9, 0.25, 0.25, 1, true, 0)
                    else
                        _DrawRect(0.817, 0.91, 0.03, 0.02, 186, 186, 186, 225, 0)
                        Draw("TKD", 0, 0, 0, 255, 0.817, 0.9, 0.25, 0.25, 1, true, 0)
                    end

                    if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                        if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                            _DrawRect(0.743, 0.94, 0.015, 0.02, 0, 173, 0, 225, 0)
                        else
                            _DrawRect(0.75, 0.94, 0.03, 0.02, 0, 173, 0, 225, 0)
                        end
                    else
                        _DrawRect(0.75, 0.94, 0.03, 0.02, 186, 186, 186, 225, 0)
                    end

                    if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                        if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 1) then
                            _DrawRect(0.758, 0.94, 0.015, 0.02, 0, 213, 255, 225, 2)
                        else
                            _DrawRect(0.75, 0.94, 0.03, 0.02, 0, 213, 255, 225, 0)
                        end
                    end
                    
                    Draw("MAIN", 0, 0, 0, 255, 0.75, 0.93, 0.25, 0.25, 3, true, 0)

                    if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                        if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                            _DrawRect(0.777, 0.94, 0.015, 0.02, 0, 173, 0, 225, 0)
                        else
                            _DrawRect(0.784, 0.94, 0.03, 0.02, 0, 173, 0, 225, 0)
                        end
                    else
                        _DrawRect(0.784, 0.94, 0.03, 0.02, 186, 186, 186, 225, 0)
                    end

                    if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                        if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 2) then
                            _DrawRect(0.792, 0.94, 0.015, 0.02, 0, 213, 255, 225, 2)
                        else
                            _DrawRect(0.784, 0.94, 0.03, 0.02, 0, 213, 255, 255, 0)
                        end
                    end

                    Draw("SEC", 0, 0, 0, 255, 0.784, 0.93, 0.25, 0.25, 3, true, 0)

                    if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                        if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                            _DrawRect(0.81, 0.94, 0.015, 0.02, 0, 173, 0, 225, 0)
                        else
                            _DrawRect(0.817, 0.94, 0.03, 0.02, 0, 173, 0, 225, 0)
                        end
                    else
                        _DrawRect(0.817, 0.94, 0.03, 0.02, 186, 186, 186, 225, 0)
                    end

                    if (d_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                        if (m_siren_state[GetVehiclePedIsUsing(GetPlayerPed(-1))] == 3) then
                            _DrawRect(0.823, 0.94, 0.015, 0.02, 0, 213, 255, 225, 2)
                        else
                            _DrawRect(0.817, 0.94, 0.03, 0.02, 0, 213, 255, 255, 0)
                        end
                    end

                    Draw("AUX", 0, 0, 0, 255, 0.817, 0.93, 0.25, 0.25, 3, true, 0)

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 7)) then
                        _DrawRect(0.9, 0.94, 0.015, 0.015, els_Vehicles[vehN].extras[7].env_color.r, els_Vehicles[vehN].extras[7].env_color.g, els_Vehicles[vehN].extras[7].env_color.b, 225, 0)
                    else
                        _DrawRect(0.9, 0.94, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 8)) then
                        _DrawRect(0.92, 0.94, 0.015, 0.015, els_Vehicles[vehN].extras[8].env_color.r, els_Vehicles[vehN].extras[8].env_color.g, els_Vehicles[vehN].extras[8].env_color.b, 225, 0)
                    else
                        _DrawRect(0.92, 0.94, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 9)) then
                        _DrawRect(0.94, 0.94, 0.015, 0.015, els_Vehicles[vehN].extras[9].env_color.r, els_Vehicles[vehN].extras[9].env_color.g, els_Vehicles[vehN].extras[9].env_color.b, 225, 0)
                    else
                        _DrawRect(0.94, 0.94, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1)) then
                        _DrawRect(0.89, 0.92, 0.015, 0.015, els_Vehicles[vehN].extras[1].env_color.r, els_Vehicles[vehN].extras[1].env_color.g, els_Vehicles[vehN].extras[1].env_color.b, 225, 0)
                    else
                        _DrawRect(0.89, 0.92, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 2)) then
                        _DrawRect(0.91, 0.92, 0.015, 0.015, els_Vehicles[vehN].extras[2].env_color.r, els_Vehicles[vehN].extras[2].env_color.g, els_Vehicles[vehN].extras[2].env_color.b, 225, 0)
                    else
                        _DrawRect(0.91, 0.92, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 3)) then
                        _DrawRect(0.93, 0.92, 0.015, 0.015, els_Vehicles[vehN].extras[3].env_color.r, els_Vehicles[vehN].extras[3].env_color.g, els_Vehicles[vehN].extras[3].env_color.b, 225, 0)
                    else
                        _DrawRect(0.93, 0.92, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4)) then
                        _DrawRect(0.95, 0.92, 0.015, 0.015, els_Vehicles[vehN].extras[4].env_color.r, els_Vehicles[vehN].extras[4].env_color.g, els_Vehicles[vehN].extras[4].env_color.b, 225, 0)
                    else
                        _DrawRect(0.95, 0.92, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 5)) then
                        _DrawRect(0.91, 0.885, 0.015, 0.015, els_Vehicles[vehN].extras[5].env_color.r, els_Vehicles[vehN].extras[5].env_color.g, els_Vehicles[vehN].extras[5].env_color.b, 225, 0)
                    else
                        _DrawRect(0.91, 0.885, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end

                    if(IsVehicleExtraTurnedOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), 6)) then
                        _DrawRect(0.93, 0.885, 0.015, 0.015, els_Vehicles[vehN].extras[6].env_color.r, els_Vehicles[vehN].extras[6].env_color.g, els_Vehicles[vehN].extras[6].env_color.b, 225, 0)
                    else
                        _DrawRect(0.93, 0.885, 0.015, 0.015, 186, 186, 186, 225, 0)
                    end
                end
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()

    if vehInTable(els_Vehicles, checkCarHash(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then
        SetVehicleSiren(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
        TriggerServerEvent("els:setSirenState_s", 0)
    end

    while true do
        if vehInTable(els_Vehicles, checkCarHash(GetVehiclePedIsIn(GetPlayerPed(-1, true)))) then
            if getVehicleLightStage(GetVehiclePedIsIn(GetPlayerPed(-1, true))) ~= 0 then
                SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1, true)), true, true, false)
            end
        end

        LghtSoundCleaner()

        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(elsVehs) do
            if(v ~= nil or DoesEntityExist(k)) then
                if (GetDistanceBetweenCoords(GetEntityCoords(k, true), GetEntityCoords(GetPlayerPed(-1), true), true) <= vehicleSyncDistance) then
                    local vehN = checkCarHash(k)

                    for i=1,12 do
                        if (not IsEntityDead(k) and DoesEntityExist(k)) then
                            if(els_Vehicles[vehN].extras[i] ~= nil) then
                                if(IsVehicleExtraTurnedOn(k, i)) then
                                    local boneIndex = GetEntityBoneIndexByName(k, "extra_" .. i)
                                    local coords = GetWorldPositionOfEntityBone(k, boneIndex)
                                    local rotX, rotY, rotZ = table.unpack(RotAnglesToVec(GetEntityRotation(k, 2)))

                                    if els_Vehicles[vehN].extras[i].env_light then
                                        if i == 11 then
                                            DrawSpotLightWithShadow(coords.x + els_Vehicles[vehN].extras[11].env_pos.x, coords.y + els_Vehicles[vehN].extras[11].env_pos.y, coords.z + els_Vehicles[vehN].extras[11].env_pos.z, rotX, rotY, rotZ, 255, 255, 255, 75.0, 2.0, 10.0, 20.0, 0.0, true)
                                        end
                                    else
                                        if i == 11 then
                                            DrawSpotLightWithShadow(coords.x, coords.y, coords.z + 0.2, rotX, rotY, rotZ, 255, 255, 255, 75.0, 2.0, 10.0, 20.0, 0.0, true)
                                        end
                                    end

                                    if doesVehicleHaveTrafficAdvisor(k) then
                                        if (i ~= 7 and i ~= 8 and i ~= 9) then
                                            runEnvirementLightWithBrightness(k, i, 0.01)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(4)
    end
end)

Citizen.CreateThread(function()
    local vehIsReady = {}

    while true do
        for k,v in pairs(elsVehs) do
            if not DoesEntityExist(k) then
                vehIsReady[k] = true
            end
            if (v ~= nil or DoesEntityExist(k)) then
                if doesVehicleHaveTrafficAdvisor(k) then
                    if v.advisor then
                        if (GetDistanceBetweenCoords(GetEntityCoords(k, true), GetEntityCoords(GetPlayerPed(-1), true), true) <= vehicleSyncDistance) then

                            if(vehIsReady[k] == nil) then
                                vehIsReady[k] = true
                            end
                            if vehIsReady[k] then
                                runPatternAdvisor(k, v.advisorPattern, function(cb) vehIsReady[k] = cb end)
                            end
                        end
                    else
                        setExtraState(elsVehicle, 7, 1)
                        setExtraState(elsVehicle, 8, 1)
                        setExtraState(elsVehicle, 9, 1)
                    end
                end
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    local vehIsReady = {}

    while true do
        for k,v in pairs(elsVehs) do
            local elsVehicle = k
            if not DoesEntityExist(k) then
                vehIsReady[k] = true
            end
            if (v ~= nil or DoesEntityExist(k)) then
                if(v.secondary) then
                    if (GetDistanceBetweenCoords(GetEntityCoords(k, true), GetEntityCoords(GetPlayerPed(-1), true), true) <= vehicleSyncDistance) then

                        if(vehIsReady[k] == nil) then
                            vehIsReady[k] = true
                        end
                        if vehIsReady[k] then
                            runPatternStageTwo(k, v.secPattern, function(cb) vehIsReady[k] = cb end)
                        end
                    end
                else
                    setExtraState(elsVehicle, 5, 1)
                    setExtraState(elsVehicle, 6, 1)
                    if not doesVehicleHaveTrafficAdvisor(k) and not v.advisor then
                        setExtraState(elsVehicle, 7, 1)
                        setExtraState(elsVehicle, 8, 1)
                        setExtraState(elsVehicle, 9, 1)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local vehIsReady = {}

    while true do
        for k,v in pairs(elsVehs) do
            if not DoesEntityExist(k) then
                vehIsReady[k] = true
            end
            if (v ~= nil or DoesEntityExist(k)) then
                if (v.primary) then
                    if (GetDistanceBetweenCoords(GetEntityCoords(k, true), GetEntityCoords(GetPlayerPed(-1), true), true) <= vehicleSyncDistance) then

                        if(vehIsReady[k] == nil) then
                            vehIsReady[k] = true
                        end
                        if vehIsReady[k] then
                            runPatternStageThree(k, v.primPattern, function(cb) vehIsReady[k] = cb end)
                        end
                    end
                else
                    setExtraState(k, 1, 1)
                    setExtraState(k, 2, 1)
                    setExtraState(k, 3, 1)
                    setExtraState(k, 4, 1)
                end
            end
        end
        Citizen.Wait(0)
    end
end)