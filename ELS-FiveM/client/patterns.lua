els_patterns = {}

function getNumberOfPrimaryPatterns(veh)
    local count = 0
    if getVehicleVCFInfo(veh).priml.type == "leds" then
        for k,v in pairs(led_PrimaryPatterns) do
            if (v ~= nil) then
                count = count + 1
            end
        end
    elseif getVehicleVCFInfo(veh).priml.type == "chp" then
        count = 3
    end

    return count
end

function getNumberOfSecondaryPatterns(veh)
    local count = 0
    if getVehicleVCFInfo(veh).secl.type == "leds" then
        for k,v in pairs(led_SecondaryPatterns) do
            if (v ~= nil) then
                count = count + 1
            end
        end
    end
    if getVehicleVCFInfo(veh).secl.type == "traf" then
        for k,v in pairs(traf_Patterns) do
            if (v ~= nil) then
                count = count + 1
            end
        end
    end
    if getVehicleVCFInfo(veh).secl.type == "chp" then
        count = 3
    end

    return count
end

function getNumberOfAdvisorPatterns(veh)
    local count = 0
    if getVehicleVCFInfo(veh).wrnl.type == "leds" then
        for k,v in pairs(leds_WarningPatterns) do
            if (v ~= nil) then
                count = count + 1
            end
        end
    end
    if getVehicleVCFInfo(veh).secl.type == "chp" then
        count = 1
    end
    
    return count
end

function runEnvironmentLight(k, extra)
    Citizen.CreateThread(function()
        if not IsEntityDead(k) and k ~= nil then
            local vehN = checkCarHash(k)

            if els_Vehicles[vehN].extras[extra] ~= nil then
                if(els_Vehicles[vehN].extras[extra].env_light) then
                    local boneIndex = GetEntityBoneIndexByName(k, "extra_" .. extra)
                    local coords = GetWorldPositionOfEntityBone(k, boneIndex)
                    
                    for i=1,6 do
                        if(IsVehicleExtraTurnedOn(k, extra) == false) then break end
                        DrawLightWithRangeAndShadow(coords.x + els_Vehicles[vehN].extras[extra].env_pos.x, coords.y + els_Vehicles[vehN].extras[extra].env_pos.y, coords.z + els_Vehicles[vehN].extras[extra].env_pos.z, els_Vehicles[vehN].extras[extra].env_color.r, els_Vehicles[vehN].extras[extra].env_color.g, els_Vehicles[vehN].extras[extra].env_color.b, 50.0, environmentLightBrightness, 5.0)
                        --DrawLightWithRange(coords.x + els_Vehicles[vehN].extras[extra].env_pos.x, coords.y + els_Vehicles[vehN].extras[extra].env_pos.y, coords.z + els_Vehicles[vehN].extras[extra].env_pos.z, els_Vehicles[vehN].extras[extra].env_color.r, els_Vehicles[vehN].extras[extra].env_color.g, els_Vehicles[vehN].extras[extra].env_color.b, 150 + 0.0, environmentLightBrightness)
                        Wait(2)
                    end
                end
            end
        end
    end)
end

local chpPatternReady = {}
function runCHPPattern(k, pattern, stage)
    Citizen.CreateThread(function()
        if (not IsEntityDead(k) and DoesEntityExist(k) and (chpPatternReady[k] or chpPatternReady[k] == nil)) then

                chpPatternReady[k] = false

                local done = {}
                for i=1, 10 do
                    done[i] = false
                end

                if stage == 1 then
                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][1]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][1], spot, spot) )
                            setExtraState(k, 1, c)
                            if c == 0 then
                                runEnvironmentLight(k, 1)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[1] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][1]) then
                                done[1] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][2]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][2], spot, spot) )
                            setExtraState(k, 2, c)
                            if c == 0 then
                                runEnvironmentLight(k, 2)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[2] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][2]) then
                                done[2] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][3]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][3], spot, spot) )
                            setExtraState(k, 3, c)
                            if c == 0 then
                                runEnvironmentLight(k, 3)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[3] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][3]) then
                                done[3] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][4]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][4], spot, spot) )
                            setExtraState(k, 4, c)
                            if c == 0 then
                                runEnvironmentLight(k, 4)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[4] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][4]) then
                                done[4] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][5]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][5], spot, spot) )
                            setExtraState(k, 5, c)
                            if c == 0 then
                                runEnvironmentLight(k, 5)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[5] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][5]) then
                                done[5] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][6]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][6], spot, spot) )
                            setExtraState(k, 6, c)
                            if c == 0 then
                                runEnvironmentLight(k, 6)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[6] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][6]) then
                                done[6] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][7]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][7], spot, spot) )
                            setExtraState(k, 7, c)
                            if c == 0 then
                                runEnvironmentLight(k, 7)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[7] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][7]) then
                                done[7] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][8]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][8], spot, spot) )
                            setExtraState(k, 8, c)
                            if c == 0 then
                                runEnvironmentLight(k, 8)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[8] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][8]) then
                                done[8] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][9]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][9], spot, spot) )
                            setExtraState(k, 9, c)
                            if c == 0 then
                                runEnvironmentLight(k, 9)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[9] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][9]) then
                                done[9] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageOne[pattern][10]) do
                            local c = tonumber(string.sub(chp_StageOne[pattern][10], spot, spot) )
                            setExtraState(k, 10, c)
                            if c == 0 then
                                runEnvironmentLight(k, 10)
                            end

                            if elsVehs[k].advisorPattern ~= pattern then
                                done[10] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageOne[pattern][10]) then
                                done[10] = true
                                break
                            end
                        end

                        return
                    end)
                elseif stage == 2 then
                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][1]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][1], spot, spot) )
                            setExtraState(k, 1, c)
                            if c == 0 then
                                runEnvironmentLight(k, 1)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[1] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][1]) then
                                done[1] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][2]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][2], spot, spot) )
                            setExtraState(k, 2, c)
                            if c == 0 then
                                runEnvironmentLight(k, 2)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[2] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][2]) then
                                done[2] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][3]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][3], spot, spot) )
                            setExtraState(k, 3, c)
                            if c == 0 then
                                runEnvironmentLight(k, 3)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[3] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][3]) then
                                done[3] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][4]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][4], spot, spot) )
                            setExtraState(k, 4, c)
                            if c == 0 then
                                runEnvironmentLight(k, 4)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[4] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][4]) then
                                done[4] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][5]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][5], spot, spot) )
                            setExtraState(k, 5, c)
                            if c == 0 then
                                runEnvironmentLight(k, 5)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[5] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][5]) then
                                done[5] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][6]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][6], spot, spot) )
                            setExtraState(k, 6, c)
                            if c == 0 then
                                runEnvironmentLight(k, 6)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[6] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][6]) then
                                done[6] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][7]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][7], spot, spot) )
                            setExtraState(k, 7, c)
                            if c == 0 then
                                runEnvironmentLight(k, 7)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[7] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][7]) then
                                done[7] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][8]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][8], spot, spot) )
                            setExtraState(k, 8, c)
                            if c == 0 then
                                runEnvironmentLight(k, 8)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[8] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][8]) then
                                done[8] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][9]) do
                        local c = tonumber(string.sub(chp_StageTwo[pattern][9], spot, spot) )
                            setExtraState(k, 9, c)
                            if c == 0 then
                                runEnvironmentLight(k, 9)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[9] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][9]) then
                                done[9] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageTwo[pattern][10]) do
                            local c = tonumber(string.sub(chp_StageTwo[pattern][10], spot, spot) )
                            setExtraState(k, 10, c)
                            if c == 0 then
                                runEnvironmentLight(k, 10)
                            end

                            if elsVehs[k].secPattern ~= pattern then
                                done[10] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageTwo[pattern][10]) then
                                done[10] = true
                                break
                            end
                        end

                        return
                    end)
                elseif stage == 3 then
                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][1]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][1], spot, spot) )
                            setExtraState(k, 1, c)
                            if c == 0 then
                                runEnvironmentLight(k, 1)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[1] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][1]) then
                                done[1] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][2]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][2], spot, spot) )
                            setExtraState(k, 2, c)
                            if c == 0 then
                                runEnvironmentLight(k, 2)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[2] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][2]) then
                                done[2] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][3]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][3], spot, spot) )
                            setExtraState(k, 3, c)
                            if c == 0 then
                                runEnvironmentLight(k, 3)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[3] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][3]) then
                                done[3] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][4]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][4], spot, spot) )
                            setExtraState(k, 4, c)
                            if c == 0 then
                                runEnvironmentLight(k, 4)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[4] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][4]) then
                                done[4] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][5]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][5], spot, spot) )
                            setExtraState(k, 5, c)
                            if c == 0 then
                                runEnvironmentLight(k, 5)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[5] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][5]) then
                                done[5] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][6]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][6], spot, spot) )
                            setExtraState(k, 6, c)
                            if c == 0 then
                                runEnvironmentLight(k, 6)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[6] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][6]) then
                                done[6] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][7]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][7], spot, spot) )
                            setExtraState(k, 7, c)
                            if c == 0 then
                                runEnvironmentLight(k, 7)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[7] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][7]) then
                                done[7] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][8]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][8], spot, spot) )
                            setExtraState(k, 8, c)
                            if c == 0 then
                                runEnvironmentLight(k, 8)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[8] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][8]) then
                                done[8] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][9]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][9], spot, spot) )
                            setExtraState(k, 9, c)
                            if c == 0 then
                                runEnvironmentLight(k, 9)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[9] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][9]) then
                                done[9] = true
                                break
                            end
                        end

                        return
                    end)

                    Citizen.CreateThread(function()
                        for spot = 1, string.len(chp_StageThree[pattern][10]) do
                            local c = tonumber(string.sub(chp_StageThree[pattern][10], spot, spot) )
                            setExtraState(k, 10, c)
                            if c == 0 then
                                runEnvironmentLight(k, 10)
                            end

                            if elsVehs[k].primPattern ~= pattern then
                                done[10] = true
                                break
                            end

                            Wait(GetConvarInt("els_lightDelay", 10))

                            if spot == string.len(chp_StageThree[pattern][10]) then
                                done[10] = true
                                break
                            end
                        end

                        return
                    end)
                end

                while (not done[1] or not done[2] or not done[3] or not done[4] or not done[5] or not done[6] or not done[7] or not done[8] or not done[9] or not done[10]) do Wait(0) end
                if done[1] and done[2] and done[3] and done[4] and done[5] and done[6] and done[7] and done[8] and done[9] and done[10] then
                    chpPatternReady[k] = true
                end
        end
    end)
end


trafFR = 0
local trafPatternReady = {}
function runTrafPattern(k, pattern) 
    Citizen.CreateThread(function()
        if (not IsEntityDead(k) and DoesEntityExist(k) and (trafPatternReady[k] or trafPatternReady[k] == nil)) then
            if (GetGameTimer() - trafFR >= GetConvarInt("els_lightDelay", 10)) then

                trafPatternReady[k] = false

                local done = {}
                for i=1, 3 do
                    done[i] = false
                end

                Citizen.CreateThread(function()
                    for spot = 1, string.len(traf_Patterns[pattern][7]) do
                        local c = tonumber(string.sub(traf_Patterns[pattern][7], spot, spot) )
                        setExtraState(k, 7, c)
                        if c == 0 then
                            runEnvironmentLight(k, 7)
                        end

                        if elsVehs[k].secPattern ~= pattern then
                            done[1] = true
                            break
                        end

                        if not elsVehs[k].secondary then
                            done[1] = true
                            break
                        end

                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(traf_Patterns[pattern][7]) then
                            done[1] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(traf_Patterns[pattern][8]) do
                        local c = tonumber(string.sub(traf_Patterns[pattern][8], spot, spot) )
                        setExtraState(k, 8, c)
                        if c == 0 then
                            runEnvironmentLight(k, 8)
                        end

                        if elsVehs[k].secPattern ~= pattern then
                            done[2] = true
                            break
                        end

                        if not elsVehs[k].secondary then
                            done[2] = true
                            break
                        end

                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(traf_Patterns[pattern][8]) then
                            done[2] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(traf_Patterns[pattern][9]) do
                        local c = tonumber(string.sub(traf_Patterns[pattern][9], spot, spot) )
                        setExtraState(k, 9, c)
                        if c == 0 then
                            runEnvironmentLight(k, 9)
                        end

                        if elsVehs[k].secPattern ~= pattern then
                            done[3] = true
                            break
                        end

                        if not elsVehs[k].secondary then
                            done[3] = true
                            break
                        end

                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(traf_Patterns[pattern][9]) then
                            done[3] = true
                            break
                        end
                    end

                    return
                end)

                while (not done[1] or not done[2] or not done[3]) do Wait(0) end
                if done[1] and done[2] and done[3] then
                    trafPatternReady[k] = true
                end

                trafFR = GetGameTimer()
            end
        end
    end)
end

secdFR = 0
local ledSecondaryReady = {}
function runLedPatternSecondary(k, pattern)
    Citizen.CreateThread(function()
        if (not IsEntityDead(k) and DoesEntityExist(k) and (ledSecondaryReady[k] or ledSecondaryReady[k] == nil)) then
            if (GetGameTimer() - trafFR >= GetConvarInt("els_lightDelay", 10)) then

                ledSecondaryReady[k] = false

                local done = {}
                for i=1, 3 do
                    done[i] = false
                end

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_SecondaryPatterns[pattern][7]) do
                        local c = tonumber(string.sub(led_SecondaryPatterns[pattern][7], spot, spot) )

                        setExtraState(k, 7, c)
                        if c == 0 then
                            runEnvironmentLight(k, 7)
                        end

                        if elsVehs[k] ~= nil then
                            if elsVehs[k].secPattern ~= pattern then
                                done[1] = true
                                ledSecondary = 1
                                break
                            end
                        end

                        if not elsVehs[k].secondary then
                            done[1] = true
                            break
                        end


                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_SecondaryPatterns[pattern][7]) then
                            done[1] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_SecondaryPatterns[pattern][8]) do
                        local c = tonumber(string.sub(led_SecondaryPatterns[pattern][8], spot, spot) )

                        setExtraState(k, 8, c)
                        if c == 0 then
                            runEnvironmentLight(k, 8)
                        end

                        if elsVehs[k] ~= nil then
                            if elsVehs[k].secPattern ~= pattern then
                                done[2] = true
                                ledSecondary = 1
                                break
                            end
                        end

                        if not elsVehs[k].secondary then
                            done[2] = true
                            break
                        end


                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_SecondaryPatterns[pattern][8]) then
                            done[2] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_SecondaryPatterns[pattern][9]) do
                        local c = tonumber(string.sub(led_SecondaryPatterns[pattern][9], spot, spot) )
                        setExtraState(k, 9, c)
                        if c == 0 then
                            runEnvironmentLight(k, 9)
                        end

                        if elsVehs[k] ~= nil then
                            if elsVehs[k].secPattern ~= pattern then
                                done[3] = true
                                ledSecondary = 1
                                break
                            end
                        end

                        if not elsVehs[k].secondary then
                            done[3] = true
                            break
                        end


                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_SecondaryPatterns[pattern][9]) then
                            done[3] = true
                            break
                        end
                    end

                    return
                end)

                while (not done[1] or not done[2] or not done[3]) do Wait(0) end
                if done[1] and done[2] and done[3] then
                    ledSecondaryReady[k] = true
                end
                secdFR = GetGameTimer()
            end
        end
    end)
end

warnFR = 0
local ledWarningReady = {}
function runLedPatternWarning(k, pattern) 
    Citizen.CreateThread(function()
        if (not IsEntityDead(k) and DoesEntityExist(k) and (ledWarningReady[k] or ledWarningReady[k] == nil)) then
            if (GetGameTimer() - warnFR >= GetConvarInt("els_lightDelay", 10)) then

                ledWarningReady[k] = false

                local done = {}
                for i=1, 3 do
                    done[i] = false
                end

                Citizen.CreateThread(function()
                    for spot = 1, string.len(leds_WarningPatterns[pattern][5]) do
                        local c = tonumber(string.sub(leds_WarningPatterns[pattern][5], spot, spot) )
                        setExtraState(k, 5, c)
                        if c == 0 then
                            runEnvironmentLight(k, 5)
                        end

                        if elsVehs[k].advisorPattern ~= pattern then
                            done[1] = true
                            break
                        end

                        if not elsVehs[k].warning then
                            done[1] = true
                            break
                        end


                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(leds_WarningPatterns[pattern][5]) then
                            done[1] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(leds_WarningPatterns[pattern][6]) do
                        local c = tonumber(string.sub(leds_WarningPatterns[pattern][6], spot, spot) )
                        setExtraState(k, 6, c)
                        if c == 0 then
                            runEnvironmentLight(k, 6)
                        end

                        if elsVehs[k].advisorPattern ~= pattern then
                            done[2] = true
                            break
                        end

                        if not elsVehs[k].warning then
                            done[2] = true
                            break
                        end


                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(leds_WarningPatterns[pattern][6]) then
                            done[2] = true
                            break
                        end
                    end

                    return
                end)

                while (not done[1] or not done[2]) do Wait(0) end
                if done[1] and done[2] then
                    ledWarningReady[k] = true
                end
                warnFR = GetGameTimer()
            end
        end
    end)
end

primFR = 0
local ledPrimaryReady = {}
function runLedPatternPrimary(k, pattern) 
    Citizen.CreateThread(function()
        if (not IsEntityDead(k) and DoesEntityExist(k) and (ledPrimaryReady[k] or ledPrimaryReady[k] == nil)) then
            if (GetGameTimer() - primFR >= GetConvarInt("els_lightDelay", 10)) then
                ledPrimaryReady[k] = false

                local done = {}
                for i=1, 4 do
                    done[i] = false
                end

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_PrimaryPatterns[pattern][1]) do
                        local c = tonumber(string.sub(led_PrimaryPatterns[pattern][1], spot, spot) )
                        setExtraState(k, 1, c)
                        if c == 0 then
                            runEnvironmentLight(k, 1)
                        end

                        if elsVehs[k].primPattern ~= pattern then
                            done[1] = true
                            break
                        end

                        if not elsVehs[k].primary then
                            done[1] = true
                            break
                        end


                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_PrimaryPatterns[pattern][1]) then
                            done[1] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_PrimaryPatterns[pattern][2]) do
                        local c = tonumber(string.sub(led_PrimaryPatterns[pattern][2], spot, spot) )
                        setExtraState(k, 2, c)
                        if c == 0 then
                            runEnvironmentLight(k, 2)
                        end

                        if elsVehs[k].primPattern ~= pattern then
                            done[2] = true
                            break
                        end

                        if not elsVehs[k].primary then
                            done[2] = true
                            break
                        end

                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_PrimaryPatterns[pattern][2]) then
                            done[2] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_PrimaryPatterns[pattern][3]) do
                        local c = tonumber(string.sub(led_PrimaryPatterns[pattern][3], spot, spot) )
                        setExtraState(k, 3, c)
                        if c == 0 then
                            runEnvironmentLight(k, 3)
                        end

                        if elsVehs[k].primPattern ~= pattern then
                            done[3] = true
                            break
                        end
                        
                        if not elsVehs[k].primary then
                            done[3] = true
                            break
                        end

                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_PrimaryPatterns[pattern][3]) then
                            done[3] = true
                            break
                        end
                    end

                    return
                end)

                Citizen.CreateThread(function()
                    for spot = 1, string.len(led_PrimaryPatterns[pattern][4]) do
                        local c = tonumber(string.sub(led_PrimaryPatterns[pattern][4], spot, spot) )
                        setExtraState(k, 4, c)
                        if c == 0 then
                            runEnvironmentLight(k, 4)
                        end

                        if elsVehs[k].primPattern ~= pattern then
                            done[4] = true
                            break
                        end

                        if not elsVehs[k].primary then
                            done[4] = true
                            break
                        end

                        Wait(GetConvarInt("els_flashDelay", 15))

                        if spot == string.len(led_PrimaryPatterns[pattern][4]) then
                            done[4] = true
                            break
                        end
                    end

                    return
                end)
                
                while (not done[1] or not done[2] or not done[3] or not done[4]) do Wait(0) end
                if done[1] and done[2] and done[3] and done[4] then
                    ledPrimaryReady[k] = true
                end
                primFR = GetGameTimer()
            end
        end
    end)
end