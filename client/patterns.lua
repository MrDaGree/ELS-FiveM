els_patterns = {}
canaryClient = true

function getNumberOfPrimaryPatterns()
	local count = 0
	for k,v in pairs(els_patterns.primarys) do
		if (v ~= nil) then
			count = count + 1
		end
	end

	return count
end

function getNumberOfSecondaryPatterns()
	local count = 0
	for k,v in pairs(els_patterns.secondarys) do
		if (v ~= nil) then
			count = count + 1
		end
	end

	return count
end

function getNumberOfAdvisorPatterns()
	local count = 0
	for k,v in pairs(els_patterns.advisors) do
		if (v ~= nil) then
			count = count + 1
		end
	end

	return count
end

function runEnvirementLightWithBrightness(k, extra, brightness)
	Citizen.CreateThread(function()
		local vehN = checkCarHash(k)

		if(els_Vehicles[vehN].extras[extra].env_light) then
	        local boneIndex = GetEntityBoneIndexByName(k, "extra_" .. extra)
	        local coords = GetWorldPositionOfEntityBone(k, boneIndex)
			
			for i=1,5 do
				 if(IsVehicleExtraTurnedOn(k, extra) == false) then break end
				--DrawLightWithRangeAndShadow(coords.x + els_Vehicles[vehN].extras[extra].env_pos.x, coords.y + els_Vehicles[vehN].extras[extra].env_pos.y, coords.z + els_Vehicles[vehN].extras[extra].env_pos.z, els_Vehicles[vehN].extras[extra].env_color.r, els_Vehicles[vehN].extras[extra].env_color.g, els_Vehicles[vehN].extras[extra].env_color.b, 50.0, 0.26, 1.0)
				DrawLightWithRange(coords.x + els_Vehicles[vehN].extras[extra].env_pos.x, coords.y + els_Vehicles[vehN].extras[extra].env_pos.y, coords.z + els_Vehicles[vehN].extras[extra].env_pos.z, els_Vehicles[vehN].extras[extra].env_color.r, els_Vehicles[vehN].extras[extra].env_color.g, els_Vehicles[vehN].extras[extra].env_color.b, 50.0, brightness)
				Wait(2)
			end
	    end
	end)
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

local advisorAllow = 1
function runPatternAdvisor(k, stage, pattern, cb) 
	Citizen.CreateThread(function()
		if (not IsEntityDead(k) and DoesEntityExist(k)) then
			if (stage == 1 or stage == 2 or (canUseAdvisorStageThree(elsVehicle) and stage == 3)) then

				if canaryClient then
	        		SetVehicleAutoRepairDisabled(elsVehicle, true)
	        	end

				local max = 0
				local count = 1

				for k,v in pairs(els_patterns.advisors[pattern].stages) do
					max = max + 1
				end

				local lastSpeed = els_patterns.advisors[pattern].speed
				local rate = fps / (fps * 60 / lastSpeed)

				if (rate < 1) then rate = Ceil(rate) else rate = Floor(rate) end

				if (rate == advisorAllow) then
					advisorAllow = 1

					cb(false)
					while count <= max do

						for i=1,12 do
							if els_patterns.advisors[pattern].stages[count][i] ~= nil then
								setExtraState(k, i, els_patterns.advisors[pattern].stages[count][i])
							end
						end

						if els_patterns.advisors[pattern].stages[count].speed ~= nil then
							lastSpeed = els_patterns.advisors[pattern].stages[count].speed
						end
						
						if(count == max) then break end

						Wait(lastSpeed)
						count = count + 1
					end

					cb(true)
				elseif (advisorAllow > rate) then
					advisorAllow = 1
				else
					advisorAllow = advisorAllow + 1
				end
			end
		end
	end)
end

local stageThreeAllow = 1
function runPatternStageThree(k, pattern, cb) 
	Citizen.CreateThread(function()
		if (not IsEntityDead(k) and DoesEntityExist(k)) then

			if canaryClient then
        		SetVehicleAutoRepairDisabled(elsVehicle, true)
        	end

			local max = 0
			local count = 1

			for k,v in pairs(els_patterns.primarys[pattern].stages) do
				max = max + 1
			end

			local lastSpeed = els_patterns.primarys[pattern].speed

			local rate = fps / (fps * 60 / lastSpeed)

			if (rate < 1) then rate = Ceil(rate) else rate = Floor(rate) end

			if (rate == stageThreeAllow) then
				stageThreeAllow = 1

				cb(false)
				while count <= max do

					for i=1,12 do
						if els_patterns.primarys[pattern].stages[count][i] ~= nil then
							setExtraState(k, i, els_patterns.primarys[pattern].stages[count][i])
							if els_patterns.primarys[pattern].stages[count][i] == 0 then
								runEnvirementLight(k, i)
							end
						end
					end

					if els_patterns.primarys[pattern].stages[count].speed ~= nil then
						lastSpeed = els_patterns.primarys[pattern].stages[count].speed
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

			if canaryClient then
        		SetVehicleAutoRepairDisabled(elsVehicle, true)
        	end

			local max = 0
			local count = 1

			for k,v in pairs(els_patterns.secondarys[pattern].stages) do
				max = max + 1
			end

			local lastSpeed = els_patterns.secondarys[pattern].speed

			local rate = fps / (fps * 60 / lastSpeed)

			if (rate < 1) then rate = Ceil(rate) else rate = Floor(rate) end

			if (rate == stageTwoAllow) then
				stageTwoAllow = 1

				cb(false)
				while count <= max do

					for i=1,12 do
						if doesVehicleHaveTrafficAdvisor(k) then
							if (i ~= 7 and i ~= 8 and i ~= 9) then
								Citizen.Trace(i)
								if els_patterns.secondarys[pattern].stages[count][i] ~= nil then
									setExtraState(k, i, els_patterns.secondarys[pattern].stages[count][i])
									if els_patterns.secondarys[pattern].stages[count][i] == 0 then
										runEnvirementLight(k, i)
									end
								end
							end
						else
							if els_patterns.secondarys[pattern].stages[count][i] ~= nil then
								setExtraState(k, i, els_patterns.secondarys[pattern].stages[count][i])
								if els_patterns.secondarys[pattern].stages[count][i] == 0 then
									runEnvirementLight(k, i)
								end
							end
						end
					end

					if els_patterns.secondarys[pattern].stages[count].speed ~= nil then
						lastSpeed = els_patterns.secondarys[pattern].stages[count].speed
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