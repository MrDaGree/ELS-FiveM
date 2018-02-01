vehicleInfoTable = {}
patternInfoTable = {}

_VERSION = "1.1.1"

PerformHttpRequest("https://git.mrdagree.com/mrdagree/ELS-FiveM/raw/development/VERSION.md", function(err, response, headers)
	print("\nCurrent version: " .. _VERSION)
	print("Updater version: " .. response .. "\n")
	
	if response ~= _VERSION then
		print("\nVersion mismatch, you may be using a different version than recommended. Please update.\n")
	end
end, "GET", "", {})

local function processXml(el)
    local v = {}
    local text

    for _,kid in ipairs(el.kids) do
        if kid.type == 'text' then
            text = kid.value
        elseif kid.type == 'element' then
            if not v[kid.name] then
                v[kid.name] = {}
            end

            table.insert(v[kid.name], processXml(kid))
        end
    end

    v._ = el.attr

    if #el.attr == 0 and #el.el == 0 then
        v = text
    end

    return v
end

function parseVehData(xml, fileName)

    local a = {}
    fileName = string.sub(fileName, 1, -5)

    a = {}
    a.extras = {}

    for i=1,#xml.root.el do
    	if(xml.root.el[i].name == "INTERFACE") then
    		for ex=1,#xml.root.el[i].kids do
    			if(xml.root.el[i].kids[ex].name== "LstgActivationType") then
    				local elem = xml.root.el[i].kids[ex]
    				if elem.kids[1].value == "manual" or elem.kids[1].value == "auto" then
    					a.activateUp = true
    				else
    					a.activateUp = false
    				end
    			end
    		end
    	end
    	if(xml.root.el[i].name == "EOVERRIDE") then
    		a.advisor = false
    		for ex=1,#xml.root.el[i].kids do
    			if(string.upper(string.sub(xml.root.el[i].kids[ex].name, 1, -3)) == "EXTRA") then
    				local elem = xml.root.el[i].kids[ex]
	    			local extra = tonumber(string.sub(elem.name, -2))
	    			a.extras[extra] = {}
	    			if elem.attr['IsElsControlled'] == "true" then
	    				a.extras[extra].enabled = true
	    			else
	    				a.extras[extra].enabled = false
	    			end

	    			if not a.advisor then
	    				if extra == 7 then
	    					if string.upper(elem.attr['Color']) == "AMBER" then
	    						a.advisor = true
	    					end
	    				end
	    			end

	    			if(elem.attr['AllowEnvLight']) then
	    				a.extras[extra].env_light = true
	    				a.extras[extra].env_pos = {}
	    				a.extras[extra].env_pos['x'] = tonumber(elem.attr['OffsetX'])
	    				a.extras[extra].env_pos['y'] = tonumber(elem.attr['OffsetY'])
	    				a.extras[extra].env_pos['z'] = tonumber(elem.attr['OffsetZ'])
	    				a.extras[extra].env_color = {}

	    				if string.upper(elem.attr['Color']) == "RED" then
		                    a.extras[extra].env_color['r'] = 255
		                    a.extras[extra].env_color['g'] = 0
		                    a.extras[extra].env_color['b'] = 0
		                elseif string.upper(elem.attr['Color']) == "BLUE" then
		                    a.extras[extra].env_color['r'] = 0
		                    a.extras[extra].env_color['g'] = 0
		                    a.extras[extra].env_color['b'] = 255
		                elseif string.upper(elem.attr['Color']) == "GREEN" then
		                    a.extras[extra].env_color['r'] = 0
		                    a.extras[extra].env_color['g'] = 255
		                    a.extras[extra].env_color['b'] = 0
		                elseif string.upper(elem.attr['Color']) == "AMBER" then
		                    a.extras[extra].env_color['r'] = 255
		                    a.extras[extra].env_color['g'] = 194
		                    a.extras[extra].env_color['b'] = 0
		                elseif string.upper(elem.attr['Color']) == "WHITE" then
		                    a.extras[extra].env_color['r'] = 255
		                    a.extras[extra].env_color['g'] = 255
		                    a.extras[extra].env_color['b'] = 255
		                end
	    			end
    			end

    		end
    	end
    end

    vehicleInfoTable[fileName] = a

    print("Done with vehicle: " .. fileName)
end

function parsePatternData(xml, fileName)

    local a = {}
    fileName = string.sub(fileName, 1, -5)

    for i=1,#xml.root.el do
    	if(xml.root.el[i].name == "PRIMARY") then
    		a.primary = {}
    		a.primary.stages = {}
    		a.primary.speed = tonumber(xml.root.el[i].attr["speed"])
    		for ex=1,#xml.root.el[i].kids do
    			if(string.upper(string.sub(xml.root.el[i].kids[ex].name, 1, -3)) == "STATE") then
    				local spot = tonumber(string.sub(xml.root.el[i].kids[ex].name, 6))
    				local elem = xml.root.el[i].kids[ex]
    				a.primary.stages[spot] = {}
	    			if elem.attr['Extra1'] == "true" then
	    				a.primary.stages[spot][1] = 0
	    			elseif elem.attr['Extra1'] == "false" then
	    				a.primary.stages[spot][1] = 1
	    			end
	    			if elem.attr['Extra2'] == "true" then
	    				a.primary.stages[spot][2] = 0
	    			elseif elem.attr['Extra2'] == "false" then
	    				a.primary.stages[spot][2] = 1
	    			end
	    			if elem.attr['Extra3'] == "true" then
	    				a.primary.stages[spot][3] = 0
	    			elseif elem.attr['Extra3'] == "false" then
	    				a.primary.stages[spot][3] = 1
	    			end
	    			if elem.attr['Extra4'] == "true" then
	    				a.primary.stages[spot][4] = 0
	    			elseif elem.attr['Extra4'] == "false" then
	    				a.primary.stages[spot][4] = 1
	    			end
	    			if elem.attr['Extra5'] == "true" then
	    				a.primary.stages[spot][5] = 0
	    			elseif elem.attr['Extra5'] == "false" then
	    				a.primary.stages[spot][5] = 1
	    			end
	    			if elem.attr['Extra6'] == "true" then
	    				a.primary.stages[spot][6] = 0
	    			elseif elem.attr['Extra6'] == "false" then
	    				a.primary.stages[spot][6] = 1
	    			end
	    			if elem.attr['Extra7'] == "true" then
	    				a.primary.stages[spot][7] = 0
	    			elseif elem.attr['Extra7'] == "false" then
	    				a.primary.stages[spot][7] = 1
	    			end
	    			if elem.attr['Extra9'] == "true" then
	    				a.primary.stages[spot][9] = 0
	    			elseif elem.attr['Extra9'] == "false" then
	    				a.primary.stages[spot][9] = 1
	    			end
	    			if elem.attr['Extra10'] == "true" then
	    				a.primary.stages[spot][10] = 0
	    			elseif elem.attr['Extra10'] == "false" then
	    				a.primary.stages[spot][10] = 1
	    			end
	    			if elem.attr['Extra11'] == "true" then
	    				a.primary.stages[spot][11] = 0
	    			elseif elem.attr['Extra11'] == "false" then
	    				a.primary.stages[spot][11] = 1
	    			end
	    			if elem.attr['Extra12'] == "true" then
	    				a.primary.stages[spot][12] = 0
	    			elseif elem.attr['Extra12'] == "false" then
	    				a.primary.stages[spot][12] = 1
	    			end

	    			if elem.attr['Speed'] ~= nil then
	    				a.primary.stages[spot].speed = tonumber(elem.attr['Speed'])
	    			end
    			end
    		end
    	end
    	if(xml.root.el[i].name == "SECONDARY") then
    		a.secondary = {}
    		a.secondary.stages = {}
    		a.secondary.speed = tonumber(xml.root.el[i].attr["speed"])
    		for ex=1,#xml.root.el[i].kids do
    			if(string.upper(string.sub(xml.root.el[i].kids[ex].name, 1, -3)) == "STATE") then
    				local spot = tonumber(string.sub(xml.root.el[i].kids[ex].name, 6))
    				local elem = xml.root.el[i].kids[ex]
    				a.secondary.stages[spot] = {}
    				if elem.attr['Extra1'] == "true" then
	    				a.secondary.stages[spot][1] = 0
	    			elseif elem.attr['Extra1'] == "false" then
	    				a.secondary.stages[spot][1] = 1
	    			end
	    			if elem.attr['Extra2'] == "true" then
	    				a.secondary.stages[spot][2] = 0
	    			elseif elem.attr['Extra2'] == "false" then
	    				a.secondary.stages[spot][2] = 1
	    			end
	    			if elem.attr['Extra3'] == "true" then
	    				a.secondary.stages[spot][3] = 0
	    			elseif elem.attr['Extra3'] == "false" then
	    				a.secondary.stages[spot][3] = 1
	    			end
	    			if elem.attr['Extra4'] == "true" then
	    				a.secondary.stages[spot][4] = 0
	    			elseif elem.attr['Extra4'] == "false" then
	    				a.secondary.stages[spot][4] = 1
	    			end
	    			if elem.attr['Extra5'] == "true" then
	    				a.secondary.stages[spot][5] = 0
	    			elseif elem.attr['Extra5'] == "false" then
	    				a.secondary.stages[spot][5] = 1
	    			end
	    			if elem.attr['Extra6'] == "true" then
	    				a.secondary.stages[spot][6] = 0
	    			elseif elem.attr['Extra6'] == "false" then
	    				a.secondary.stages[spot][6] = 1
	    			end
	    			if elem.attr['Extra7'] == "true" then
	    				a.secondary.stages[spot][7] = 0
	    			elseif elem.attr['Extra7'] == "false" then
	    				a.secondary.stages[spot][7] = 1
	    			end
	    			if elem.attr['Extra9'] == "true" then
	    				a.secondary.stages[spot][9] = 0
	    			elseif elem.attr['Extra9'] == "false" then
	    				a.secondary.stages[spot][9] = 1
	    			end
	    			if elem.attr['Extra10'] == "true" then
	    				a.secondary.stages[spot][10] = 0
	    			elseif elem.attr['Extra10'] == "false" then
	    				a.secondary.stages[spot][10] = 1
	    			end
	    			if elem.attr['Extra11'] == "true" then
	    				a.secondary.stages[spot][11] = 0
	    			elseif elem.attr['Extra11'] == "false" then
	    				a.secondary.stages[spot][11] = 1
	    			end
	    			if elem.attr['Extra12'] == "true" then
	    				a.secondary.stages[spot][12] = 0
	    			elseif elem.attr['Extra12'] == "false" then
	    				a.secondary.stages[spot][12] = 1
	    			end

	    			if elem.attr['Speed'] ~= nil then
	    				a.secondary.stages[spot].speed = tonumber(elem.attr['Speed'])
	    			end
    			end
    		end
    	end
    end

    patternInfoTable[#patternInfoTable + 1] = a

    print("Done with pattern: " .. fileName)
end

function parseObjSet(data, fileName)
    local xml = SLAXML:dom(data)

    if xml and xml.root then
        if xml.root.name == "vcfroot" then
            parseVehData(xml, fileName)
        elseif xml.root.name == "pattern" then
        	parsePatternData(xml, fileName)
        end

    end
end

AddEventHandler('onResourceStart', function(name)
	if name == GetCurrentResourceName() then
	    for i=1,#vcf_files do
	    	local data = LoadResourceFile(GetCurrentResourceName(), "vcf/" .. vcf_files[i])

		    if data then
		        parseObjSet(data, vcf_files[i])
		    end
	    end

	    for i=1,#pattern_files do
	    	local data = LoadResourceFile(GetCurrentResourceName(), "patterns/" .. pattern_files[i])

		    if data then
		        parseObjSet(data, pattern_files[i])
		    end
	    end
	end
end)

RegisterServerEvent("els:requestVehiclesUpdate")
AddEventHandler('els:requestVehiclesUpdate', function()
	print("Sending player (" .. source .. ") ELS data")
	TriggerClientEvent("els:updateElsVehicles", source, vehicleInfoTable, patternInfoTable)
end)

RegisterServerEvent("els:changeLightStage_s")
AddEventHandler("els:changeLightStage_s", function(state, advisor, prim, sec)
	TriggerClientEvent("els:changeLightStage_c", -1, source, state, advisor, prim, sec)
end)

RegisterServerEvent("els:changeAdvisorPattern_s")
AddEventHandler("els:changeAdvisorPattern_s", function(pat)
	TriggerClientEvent("els:changeAdvisorPattern_c", -1, source, pat)
end)

RegisterServerEvent("els:changeSecondaryPattern_s")
AddEventHandler("els:changeSecondaryPattern_s", function(pat)
	TriggerClientEvent("els:changeSecondaryPattern_c", -1, source, pat)
end)

RegisterServerEvent("els:changePrimaryPattern_s")
AddEventHandler("els:changePrimaryPattern_s", function(pat)
	TriggerClientEvent("els:changePrimaryPattern_c", -1, source, pat)
end)

RegisterServerEvent("els:toggleDfltSirenMute_s")
AddEventHandler("els:toggleDfltSirenMute_s", function(toggle)
	TriggerClientEvent("els:toggleDfltSirenMute_s", -1, source, toggle)
end)

RegisterServerEvent("els:setSirenState_s")
AddEventHandler("els:setSirenState_s", function(newstate)
	TriggerClientEvent("els:setSirenState_c", -1, source, newstate)
end)

RegisterServerEvent("els:setDualSirenState_s")
AddEventHandler("els:setDualSirenState_s", function(newstate)
	TriggerClientEvent("els:setDualSirenState_c", -1, source, newstate)
end)

RegisterServerEvent("els:setDualSiren_s")
AddEventHandler("els:setDualSiren_s", function(newstate)
	TriggerClientEvent("els:setDualSiren_c", -1, source, newstate)
end)

RegisterServerEvent("els:setHornState_s")
AddEventHandler("els:setHornState_s", function(state)
	TriggerClientEvent("els:setHornState_c", -1, source, state)
end)

RegisterServerEvent("els:setTakedownState_s")
AddEventHandler("els:setTakedownState_s", function(state)
	TriggerClientEvent("els:setTakedownState_c", -1, source, state)
end)