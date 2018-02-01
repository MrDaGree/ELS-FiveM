els_patterns = {}

function trafficAdvisor(elsVehicle, stage, pattern)
	Citizen.CreateThread(function()
		if (not IsEntityDead(elsVehicle) and DoesEntityExist(elsVehicle)) then
			if (GetDistanceBetweenCoords(GetEntityCoords(k, true), GetEntityCoords(GetPlayerPed(-1), true), true) <= vehicleSyncDistance) then
				if (doesVehicleHaveTrafficAdvisor(elsVehicle)) then
			        if(stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
			            if stage == 1 then
			                setExtraState(elsVehicle, 5, 1)
			                setExtraState(elsVehicle, 6, 1)
			            end

			            setExtraState(elsVehicle, 7, 1)
	                    setExtraState(elsVehicle, 8, 1)
	                    setExtraState(elsVehicle, 9, 1)

			            if (pattern == 1) then
		            		local count = 1
		                    while count <= 4 do
		                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                            break
		                        end
		                        if count == 1 then
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 2 then
		                            setExtraState(elsVehicle, 8, 0)
		                        end
		                        if count == 3 then
		                            setExtraState(elsVehicle, 9, 0)
		                        end
		                        if count == 4 then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        Wait(200)
		                        count = count + 1
		                    end
			            end
			            if (pattern == 2) then
		                	local count = 1
		                    while count <= 4 do
		                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                            break
		                        end
		                        if count == 1 then
		                            setExtraState(elsVehicle, 9, 0)
		                        end
		                        if count == 2 then
		                            setExtraState(elsVehicle, 8, 0)
		                        end
		                        if count == 3 then
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 4 then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        Wait(200)
		                        count = count + 1
		                    end
			            end
			            if (pattern == 3) then
		                	local count = 1
		                    while count <= 4 do
		                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                            break
		                        end
		                        if count == 1 then
		                            setExtraState(elsVehicle, 8, 0)
		                        end
		                        if count == 2 then
		                            setExtraState(elsVehicle, 9, 0)
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 3 then
		                            setExtraState(elsVehicle, 8, 1)
		                        end
		                        if count == 4 then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        Wait(200)
		                        count = count + 1
		                    end
			            end
			            if (pattern == 4) then
		            		local count = 1
		                    while count <= 6 do
		                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                            break
		                        end
		                        if count == 1 then
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 2 then
		                            setExtraState(elsVehicle, 8, 0)
		                        end
		                        if count == 3 then
		                            setExtraState(elsVehicle, 9, 0)
		                        end
		                        if count == 4 then
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        if count == 5 then
		                            setExtraState(elsVehicle, 9, 0)
		                        end
		                        if count == 6 then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        Wait(300)
		                        count = count + 1
		                    end
			            end
			            if (pattern == 5) then
		            		local count = 1
		                    while count <= 6 do
		                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                            break
		                        end
		                        if count == 1 then
		                            setExtraState(elsVehicle, 9, 0)
		                        end
		                        if count == 2 then
		                            setExtraState(elsVehicle, 8, 0)
		                        end
		                        if count == 3 then
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 4 then
		                            setExtraState(elsVehicle, 7, 1)
		                        end
		                        if count == 5 then
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 6 then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        Wait(300)
		                        count = count + 1
		                    end
			            end
			            if (pattern == 6) then
		            		local count = 1
		                    while count <= 6 do
		                        if not (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then
		                            setExtraState(elsVehicle, 7, 1)
		                            setExtraState(elsVehicle, 8, 1)
		                            setExtraState(elsVehicle, 9, 1)
		                            break
		                        end
		                        if count == 1 then
		                            setExtraState(elsVehicle, 9, 0)
		                        end
		                        if count == 2 then
		                        	setExtraState(elsVehicle, 9, 1)
		                            setExtraState(elsVehicle, 7, 0)
		                        end
		                        if count == 3 then
		                            setExtraState(elsVehicle, 9, 0)
		                            setExtraState(elsVehicle, 7, 1)
		                        end
		                        if count == 4 then
		                            setExtraState(elsVehicle, 7, 0)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        if count == 5 then
		                            setExtraState(elsVehicle, 9, 0)
		                            setExtraState(elsVehicle, 7, 1)
		                        end
		                        if count == 6 then
		                            setExtraState(elsVehicle, 7, 0)
		                            setExtraState(elsVehicle, 9, 1)
		                        end
		                        Wait(300)
		                        count = count + 1
		                    end
			            end
			        end
			    end
			end
		end
	end)
end

function getNumberOfPrimaryPatterns()
	local count = 0
	for k,v in pairs(els_patterns) do
		if (v.primary ~= nil) then
			count = count + 1
		end
	end

	return count
end

function getNumberOfSecondaryPatterns()
	local count = 0
	for k,v in pairs(els_patterns) do
		if (v.secondary ~= nil) then
			count = count + 1
		end
	end

	return count
end

function runEnvirementLight(k, extra)
	Citizen.CreateThread(function()
		local vehN = checkCarHash(k)

		if(els_Vehicles[vehN].extras[extra].env_light) then
	        local boneIndex = GetEntityBoneIndexByName(k, "extra_" .. extra)
	        local coords = GetWorldPositionOfEntityBone(k, boneIndex)
			
			for i=1,5 do
				 if(IsVehicleExtraTurnedOn(k, extra) == false) then break end
				--DrawLightWithRangeAndShadow(coords.x + els_Vehicles[vehN].extras[extra].env_pos.x, coords.y + els_Vehicles[vehN].extras[extra].env_pos.y, coords.z + els_Vehicles[vehN].extras[extra].env_pos.z, els_Vehicles[vehN].extras[extra].env_color.r, els_Vehicles[vehN].extras[extra].env_color.g, els_Vehicles[vehN].extras[extra].env_color.b, 50.0, 0.26, 1.0)
				DrawLightWithRange(coords.x + els_Vehicles[vehN].extras[extra].env_pos.x, coords.y + els_Vehicles[vehN].extras[extra].env_pos.y, coords.z + els_Vehicles[vehN].extras[extra].env_pos.z, els_Vehicles[vehN].extras[extra].env_color.r, els_Vehicles[vehN].extras[extra].env_color.g, els_Vehicles[vehN].extras[extra].env_color.b, 50.0, envirementLightBrightness)
				Wait(2)
			end
	    end
	end)
end

local stageThreeAllow = 1
function runPatternStageThree(k, pattern, cb) 
	Citizen.CreateThread(function()
		if (not IsEntityDead(k) and DoesEntityExist(k)) then

			local max = 0
			local count = 1

			for k,v in pairs(els_patterns[pattern].primary.stages) do
				max = max + 1
			end

			local lastSpeed = els_patterns[pattern].primary.speed
			local rate = math.floor(fps / (fps * 60 / lastSpeed))

			if (rate == stageThreeAllow) then
				stageThreeAllow = 1

				cb(false)
				while count <= max do

					for i=1,12 do
						if els_patterns[pattern].primary.stages[count][i] ~= nil then
							setExtraState(k, i, els_patterns[pattern].primary.stages[count][i])
							if els_patterns[pattern].primary.stages[count][i] == 0 then
								runEnvirementLight(k, i)
							end
						end
					end

					if els_patterns[pattern].primary.stages[count].speed ~= nil then
						lastSpeed = els_patterns[pattern].primary.stages[count].speed
					end
					
					if(count == max) then break end

					Wait(lastSpeed)
					count = count + 1
				end

				cb(true)
			elseif (stageThreeAllow > rate) then
				stageThreeAllow = 1
			else
				stageThreeAllow = stageThreeAllow + 1
			end
		end
	end)
end

local stageTwoAllow = 1
function runPatternStageTwo(k, pattern, cb) 
	Citizen.CreateThread(function()
		if (not IsEntityDead(k) and DoesEntityExist(k)) then
			local max = 0
			local count = 1

			for k,v in pairs(els_patterns[pattern].secondary.stages) do
				max = max + 1
			end

			local lastSpeed = els_patterns[pattern].secondary.speed
			local rate = math.floor(fps / (fps * 60 / lastSpeed))

			if (rate == stageTwoAllow) then
				stageTwoAllow = 1

				cb(false)
				while count <= max do

					for i=1,12 do
						if els_patterns[pattern].secondary.stages[count][i] ~= nil then
							setExtraState(k, i, els_patterns[pattern].secondary.stages[count][i])
							if els_patterns[pattern].secondary.stages[count][i] == 0 then
								runEnvirementLight(k, i)
							end
						end
					end

					if els_patterns[pattern].secondary.stages[count].speed ~= nil then
						lastSpeed = els_patterns[pattern].secondary.stages[count].speed
					end
					
					if(count == max) then break end

					Wait(lastSpeed)
					count = count + 1
				end

				cb(true)
			elseif (stageTwoAllow > rate) then
				stageTwoAllow = 1
			else
				stageTwoAllow = stageTwoAllow + 1
			end
		end
	end)
end