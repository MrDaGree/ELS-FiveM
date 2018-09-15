vehicleInfoTable = {}
patternInfoTable = {}

local verFile = LoadResourceFile(GetCurrentResourceName(), "version.json")
local curVersion = json.decode(verFile).version
Citizen.CreateThread( function()
	local updatePath = "ELS-FiveM"
	local resourceName = "ELS-FiveM ("..GetCurrentResourceName()..")"
	PerformHttpRequest("https://raw.githubusercontent.com/MrDaGree/"..updatePath.."/master/version.json", function(err, response, headers)
		local data = json.decode(response)


		if curVersion ~= data.version and tonumber(curVersion) < tonumber(data.version) then
			print("\n--------------------------------------------------------------------------")
			print("\n"..resourceName.." is outdated.\nCurrent Version: "..data.version.."\nYour Version: "..curVersion.."\nPlease update it from https://github.com/MrDaGree"..updatePath.."")
			print("\nUpdate Changelog:\n"..data.changelog)
			print("\n--------------------------------------------------------------------------")
		elseif tonumber(curVersion) > tonumber(data.version) then
			print("Your version of "..resourceName.." seems to be higher than the current version. Hax bro?")
		else
			print(resourceName.." is up to date!")
		end
	end, "GET", "", {version = 'this'})
end)

RegisterCommand('_curver', function(source)
	PerformHttpRequest('https://raw.githubusercontent.com/MrDaGree/ELS-FiveM/master/version.json', function(err, response, headers)
		local data = json.decode(response)

		if curVersion ~= data.version and tonumber(curVersion) < tonumber(data.version) then
			TriggerClientEvent('chat:addMessage', source, { args = { "ELS-FiveM", "You are currently an outdated version of [ " .. GetCurrentResourceName() .. " ]. Your version: [ " .. curVersion .. " ]. Newest version: [ " .. data.version .. " ]."}, color = {13, 161, 200}})
		elseif tonumber(curVersion) > tonumber(data.version) then
			TriggerClientEvent('chat:addMessage', source, { args = { "ELS-FiveM", "Um, what? Your version of ELS-FiveM is higher than the current version. What?"}, color = {13, 161, 200}})
		else
			TriggerClientEvent('chat:addMessage', source, { args = { "ELS-FiveM", "Your version of [ " .. GetCurrentResourceName() .. " ] is up to date! Current version: [ " .. curVersion .. " ]."}, color = {13, 161, 200}})
		end
	end, "GET", "", {version = 'this'})
end)

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
    a.interface = {}
    a.extras = {}
    a.misc = {}
    a.cruise = {}
    a.sounds = {}
    a.wrnl = {}
    a.priml = {}
    a.secl = {}

    for i=1,#xml.root.el do
		if(xml.root.el[i].name == "INTERFACE") then
			for ex=1,#xml.root.el[i].kids do
				if(xml.root.el[i].kids[ex].name== "LstgActivationType") then
					local elem = xml.root.el[i].kids[ex]
					a.interface.activationType = elem.kids[1].value

				end
				if(xml.root.el[i].kids[ex].name== "InfoPanelHeaderColor") then
					local elem = xml.root.el[i].kids[ex]
					a.interface.headerColor = {}
					if elem.kids[1].value == string.lower("grey") then
						a.interface.headerColor['r'] = 40
						a.interface.headerColor['g'] = 40
						a.interface.headerColor['b'] = 40
					end
					if elem.kids[1].value == string.lower("white") then
						a.interface.headerColor['r'] = 255
						a.interface.headerColor['g'] = 255
						a.interface.headerColor['b'] = 255
					end
					if elem.kids[1].value == string.lower("yellow") then
						a.interface.headerColor['r'] = 242
						a.interface.headerColor['g'] = 238
						a.interface.headerColor['b'] = 0
					end
				end
				if(xml.root.el[i].kids[ex].name== "InfoPanelButtonLightColor") then
					local elem = xml.root.el[i].kids[ex]
					a.interface.buttonColor = {}
					if elem.kids[1].value == string.lower("green") then
						a.interface.buttonColor['r'] = 0
						a.interface.buttonColor['g'] = 255
						a.interface.buttonColor['b'] = 0
					end
					if elem.kids[1].value == string.lower("red") then
						a.interface.buttonColor['r'] = 255
						a.interface.buttonColor['g'] = 0
						a.interface.buttonColor['b'] = 0
					end
					if elem.kids[1].value == string.lower("blue") then
						a.interface.buttonColor['r'] = 0
						a.interface.buttonColor['g'] = 0
						a.interface.buttonColor['b'] = 255
					end
					if elem.kids[1].value == string.lower("purple") then
						a.interface.buttonColor['r'] = 170
						a.interface.buttonColor['g'] = 0
						a.interface.buttonColor['b'] = 255
					end
					if elem.kids[1].value == string.lower("orange") then
						a.interface.buttonColor['r'] = 255
						a.interface.buttonColor['g'] = 157
						a.interface.buttonColor['b'] = 0
					end
					if elem.kids[1].value == string.lower("yellow") then
						a.interface.buttonColor['r'] = 242
						a.interface.buttonColor['g'] = 238
						a.interface.buttonColor['b'] = 0
					end
				end
			end
		end

		if(xml.root.el[i].name == "EOVERRIDE") then
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
					
					a.extras[extra].env_light = false
					a.extras[extra].env_pos = {}
					a.extras[extra].env_pos['x'] = 0
					a.extras[extra].env_pos['y'] = 0
					a.extras[extra].env_pos['z'] = 0
					a.extras[extra].env_color = {}
					a.extras[extra].env_color['r'] = 255
					a.extras[extra].env_color['g'] = 0
					a.extras[extra].env_color['b'] = 0

	    			if(elem.attr['AllowEnvLight'] == "true") then
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

		if(xml.root.el[i].name == "MISC") then
			for ex=1,#xml.root.el[i].kids do
				if(xml.root.el[i].kids[ex].name == "ArrowboardType") then
					local elem = xml.root.el[i].kids[ex]
					a.misc.arrowboardType = elem.kids[1].value
				end

				if(xml.root.el[i].kids[ex].name == "UseSteadyBurnLights") then
					local elem = xml.root.el[i].kids[ex]
					if elem.kids[1].value == "true" then
						a.misc.usesteadyburnlights = true
					else
						a.misc.usesteadyburnlights = false
					end
				end

				if(xml.root.el[i].kids[ex].name == "DfltSirenLtsActivateAtLstg") then
					local elem = xml.root.el[i].kids[ex]
					a.misc.dfltsirenltsactivateatlstg = tonumber(elem.kids[1].value)
				end
			end
    	end

    	if(xml.root.el[i].name == "CRUISE") then
    		for ex=1,#xml.root.el[i].kids do
    			local elem = xml.root.el[i].kids[ex]
    			if(xml.root.el[i].kids[ex].name== "UseExtras") then
    				if elem.attr['Extra1'] == "true" then a.cruise[1] = 0 else a.cruise[1] = 1 end
    				if elem.attr['Extra2'] == "true" then a.cruise[2] = 0 else a.cruise[2] = 1 end
    				if elem.attr['Extra3'] == "true" then a.cruise[3] = 0 else a.cruise[3] = 1 end
    				if elem.attr['Extra4'] == "true" then a.cruise[4] = 0 else a.cruise[4] = 1 end
    			end

    			if(xml.root.el[i].kids[ex].name== "DisableAtLstg3") then
    				local elem = xml.root.el[i].kids[ex]
    				if elem.kids[1].value == "true" then
    					a.cruise.DisableLstgThree = true
    				else
    					a.cruise.DisableLstgThree = false
    				end
    			end
    		end
    	end

    	if(xml.root.el[i].name == "SOUNDS") then
    		for ex=1,#xml.root.el[i].kids do
    			local elem = xml.root.el[i].kids[ex]
    			if(xml.root.el[i].kids[ex].name== "MainHorn") then
    				a.sounds.mainHorn = {}
    				if elem.attr['InterruptsSiren'] == "true" then a.sounds.mainHorn.interrupt = true else a.sounds.mainHorn.interrupt = false end
    				a.sounds.mainHorn.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "ManTone1") then
    				a.sounds.manTone1 = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.manTone1.allowUse = true else a.sounds.manTone1.allowUse = false end
    				a.sounds.manTone1.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "ManTone2") then
    				a.sounds.manTone2 = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.manTone2.allowUse = true else a.sounds.manTone2.allowUse = false end
    				a.sounds.manTone2.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "SrnTone1") then
    				a.sounds.srnTone1 = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.srnTone1.allowUse = true else a.sounds.srnTone1.allowUse = false end
    				a.sounds.srnTone1.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "SrnTone2") then
    				a.sounds.srnTone2 = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.srnTone2.allowUse = true else a.sounds.srnTone2.allowUse = false end
    				a.sounds.srnTone2.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "SrnTone3") then
    				a.sounds.srnTone3 = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.srnTone3.allowUse = true else a.sounds.srnTone3.allowUse = false end
    				a.sounds.srnTone3.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "SrnTone4") then
    				a.sounds.srnTone4 = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.srnTone4.allowUse = true else a.sounds.srnTone4.allowUse = false end
    				a.sounds.srnTone4.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "AuxSiren") then
    				a.sounds.auxSiren = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.auxSiren.allowUse = true else a.sounds.auxSiren.allowUse = false end
    				a.sounds.auxSiren.audioString = elem.attr['AudioString']
    			end

    			if(xml.root.el[i].kids[ex].name== "PanicMde") then
    				a.sounds.panicMode = {}
    				if elem.attr['AllowUse'] == "true" then a.sounds.panicMode.allowUse = true else a.sounds.panicMode.allowUse = false end
    				a.sounds.panicMode.audioString = elem.attr['AudioString']
    			end
    		end
    	end

    	if(xml.root.el[i].name == "WRNL") then
    		a.wrnl.type = string.lower(xml.root.el[i].attr['LightingFormat'])
    		a.wrnl.PresetPatterns = {}
    		a.wrnl.ForcedPatterns = {}
    		for ex=1,#xml.root.el[i].kids do
				if(xml.root.el[i].kids[ex].name == "PresetPatterns") then
					for inner=1,#xml.root.el[i].kids[ex].el do
						local elem = xml.root.el[i].kids[ex].el[inner]

						a.wrnl.PresetPatterns[string.lower(elem.name)] = {}
						if string.lower(elem.attr['Enabled']) == "true" then a.wrnl.PresetPatterns[string.lower(elem.name)].enabled = true else a.wrnl.PresetPatterns[string.lower(elem.name)].enabled = false end
						a.wrnl.PresetPatterns[string.lower(elem.name)].pattern = tonumber(elem.attr['Pattern'])
					end
				end
				if(xml.root.el[i].kids[ex].name == "ForcedPatterns") then
					for inner=1,#xml.root.el[i].kids[ex].el do
						local elem = xml.root.el[i].kids[ex].el[inner]

						a.wrnl.ForcedPatterns[string.lower(elem.name)] = {}
						if string.lower(elem.attr['Enabled']) == "true" then a.wrnl.ForcedPatterns[string.lower(elem.name)].enabled = true else a.wrnl.ForcedPatterns[string.lower(elem.name)].enabled = false end
						a.wrnl.ForcedPatterns[string.lower(elem.name)].pattern = tonumber(elem.attr['Pattern'])
					end
				end
			end
    	end

    	if(xml.root.el[i].name == "PRML") then
    		a.priml.type = string.lower(xml.root.el[i].attr['LightingFormat'])
    		a.priml.ExtrasActiveAtLstg2 = string.lower(xml.root.el[i].attr['ExtrasActiveAtLstg2'])
    		a.priml.PresetPatterns = {}
    		a.priml.ForcedPatterns = {}
    		for ex=1,#xml.root.el[i].kids do
				if(xml.root.el[i].kids[ex].name == "PresetPatterns") then
					for inner=1,#xml.root.el[i].kids[ex].el do
						local elem = xml.root.el[i].kids[ex].el[inner]

						a.priml.PresetPatterns[string.lower(elem.name)] = {}
						if string.lower(elem.attr['Enabled']) == "true" then a.priml.PresetPatterns[string.lower(elem.name)].enabled = true else a.priml.PresetPatterns[string.lower(elem.name)].enabled = false end
						a.priml.PresetPatterns[string.lower(elem.name)].pattern = tonumber(elem.attr['Pattern'])
					end
				end
				if(xml.root.el[i].kids[ex].name == "ForcedPatterns") then
					for inner=1,#xml.root.el[i].kids[ex].el do
						local elem = xml.root.el[i].kids[ex].el[inner]

						a.priml.ForcedPatterns[string.lower(elem.name)] = {}
						if string.lower(elem.attr['Enabled']) == "true" then a.priml.ForcedPatterns[string.lower(elem.name)].enabled = true else a.priml.ForcedPatterns[string.lower(elem.name)].enabled = false end
						a.priml.ForcedPatterns[string.lower(elem.name)].pattern = tonumber(elem.attr['Pattern'])
					end
				end
			end
    	end

    	if(xml.root.el[i].name == "SECL") then
    		a.secl.type = string.lower(xml.root.el[i].attr['LightingFormat'])
    		a.secl.PresetPatterns = {}
    		a.secl.ForcedPatterns = {}
    		for ex=1,#xml.root.el[i].kids do
				if(xml.root.el[i].kids[ex].name == "PresetPatterns") then
					for inner=1,#xml.root.el[i].kids[ex].el do
						local elem = xml.root.el[i].kids[ex].el[inner]

						a.secl.PresetPatterns[string.lower(elem.name)] = {}
						if string.lower(elem.attr['Enabled']) == "true" then a.secl.PresetPatterns[string.lower(elem.name)].enabled = true else a.secl.PresetPatterns[string.lower(elem.name)].enabled = false end
						a.secl.PresetPatterns[string.lower(elem.name)].pattern = tonumber(elem.attr['Pattern'])
					end
				end
				if(xml.root.el[i].kids[ex].name == "ForcedPatterns") then
					for inner=1,#xml.root.el[i].kids[ex].el do
						local elem = xml.root.el[i].kids[ex].el[inner]

						a.secl.ForcedPatterns[string.lower(elem.name)] = {}
						if string.lower(elem.attr['Enabled']) == "true" then a.secl.ForcedPatterns[string.lower(elem.name)].enabled = true else a.secl.ForcedPatterns[string.lower(elem.name)].enabled = false end
						a.secl.ForcedPatterns[string.lower(elem.name)].pattern = tonumber(elem.attr['Pattern'])
					end
				end
			end
    	end
    	
    end

    vehicleInfoTable[fileName] = a

	if outputLoading and outputLoading ~= nil then
		if printDebugInformation == nil or printDebugInformation == true then
			print("Done with vehicle: " .. fileName)
		end
	end
end

function parsePatternData(xml, fileName)

    local primary = {}
    local secondary = {}
    local advisor = {}
    local patternError = false

    fileName = string.sub(fileName, 1, -5)

    for i=1,#xml.root.el do
    	if(xml.root.el[i].name == "PRIMARY") then
    		primary.stages = {}
    		primary.speed = tonumber(xml.root.el[i].attr["speed"])
    		for ex=1,#xml.root.el[i].kids do
    			if(string.upper(string.sub(xml.root.el[i].kids[ex].name, 1, -3)) == "STATE") then
    				local spot = tonumber(string.sub(xml.root.el[i].kids[ex].name, 6))
    				local elem = xml.root.el[i].kids[ex]
    				primary.stages[spot] = {}
	    			if elem.attr['Extra1'] == "true" then
	    				primary.stages[spot][1] = 0
	    			elseif elem.attr['Extra1'] == "false" then
	    				primary.stages[spot][1] = 1
	    			end
	    			if elem.attr['Extra2'] == "true" then
	    				primary.stages[spot][2] = 0
	    			elseif elem.attr['Extra2'] == "false" then
	    				primary.stages[spot][2] = 1
	    			end
	    			if elem.attr['Extra3'] == "true" then
	    				primary.stages[spot][3] = 0
	    			elseif elem.attr['Extra3'] == "false" then
	    				primary.stages[spot][3] = 1
	    			end
	    			if elem.attr['Extra4'] == "true" then
	    				primary.stages[spot][4] = 0
	    			elseif elem.attr['Extra4'] == "false" then
	    				primary.stages[spot][4] = 1
	    			end
	    			if elem.attr['Extra5'] == "true" then
	    				primary.stages[spot][5] = 0
	    			elseif elem.attr['Extra5'] == "false" then
	    				primary.stages[spot][5] = 1
	    			end
	    			if elem.attr['Extra6'] == "true" then
	    				primary.stages[spot][6] = 0
	    			elseif elem.attr['Extra6'] == "false" then
	    				primary.stages[spot][6] = 1
	    			end
	    			if elem.attr['Extra7'] == "true" then
	    				primary.stages[spot][7] = 0
	    			elseif elem.attr['Extra7'] == "false" then
	    				primary.stages[spot][7] = 1
	    			end
	    			if elem.attr['Extra8'] == "true" then
	    				primary.stages[spot][8] = 0
	    			elseif elem.attr['Extra8'] == "false" then
	    				primary.stages[spot][8] = 1
	    			end
	    			if elem.attr['Extra9'] == "true" then
	    				primary.stages[spot][9] = 0
	    			elseif elem.attr['Extra9'] == "false" then
	    				primary.stages[spot][9] = 1
	    			end
	    			if elem.attr['Extra10'] == "true" then
	    				primary.stages[spot][10] = 0
	    			elseif elem.attr['Extra10'] == "false" then
	    				primary.stages[spot][10] = 1
	    			end
	    			if elem.attr['Extra11'] == "true" then
	    				primary.stages[spot][11] = 0
	    			elseif elem.attr['Extra11'] == "false" then
	    				primary.stages[spot][11] = 1
	    			end
	    			if elem.attr['Extra12'] == "true" then
	    				primary.stages[spot][12] = 0
	    			elseif elem.attr['Extra12'] == "false" then
	    				primary.stages[spot][12] = 1
	    			end

	    			if elem.attr['Speed'] ~= nil then
	    				primary.stages[spot].speed = tonumber(elem.attr['Speed'])
	    			end
    			end
    		end
    	end
    	if(xml.root.el[i].name == "SECONDARY") then
    		secondary.stages = {}
    		secondary.speed = tonumber(xml.root.el[i].attr["speed"])
    		for ex=1,#xml.root.el[i].kids do
    			if(string.upper(string.sub(xml.root.el[i].kids[ex].name, 1, -3)) == "STATE") then
    				local spot = tonumber(string.sub(xml.root.el[i].kids[ex].name, 6))
    				local elem = xml.root.el[i].kids[ex]
    				secondary.stages[spot] = {}
    				if elem.attr['Extra1'] == "true" then
	    				secondary.stages[spot][1] = 0
	    			elseif elem.attr['Extra1'] == "false" then
	    				secondary.stages[spot][1] = 1
	    			end
	    			if elem.attr['Extra2'] == "true" then
	    				secondary.stages[spot][2] = 0
	    			elseif elem.attr['Extra2'] == "false" then
	    				secondary.stages[spot][2] = 1
	    			end
	    			if elem.attr['Extra3'] == "true" then
	    				secondary.stages[spot][3] = 0
	    			elseif elem.attr['Extra3'] == "false" then
	    				secondary.stages[spot][3] = 1
	    			end
	    			if elem.attr['Extra4'] == "true" then
	    				secondary.stages[spot][4] = 0
	    			elseif elem.attr['Extra4'] == "false" then
	    				secondary.stages[spot][4] = 1
	    			end
	    			if elem.attr['Extra5'] == "true" then
	    				secondary.stages[spot][5] = 0
	    			elseif elem.attr['Extra5'] == "false" then
	    				secondary.stages[spot][5] = 1
	    			end
	    			if elem.attr['Extra6'] == "true" then
	    				secondary.stages[spot][6] = 0
	    			elseif elem.attr['Extra6'] == "false" then
	    				secondary.stages[spot][6] = 1
	    			end
	    			if elem.attr['Extra7'] == "true" then
	    				secondary.stages[spot][7] = 0
	    			elseif elem.attr['Extra7'] == "false" then
	    				secondary.stages[spot][7] = 1
	    			end
	    			if elem.attr['Extra8'] == "true" then
	    				secondary.stages[spot][8] = 0
	    			elseif elem.attr['Extra8'] == "false" then
	    				secondary.stages[spot][8] = 1
	    			end
	    			if elem.attr['Extra9'] == "true" then
	    				secondary.stages[spot][9] = 0
	    			elseif elem.attr['Extra9'] == "false" then
	    				secondary.stages[spot][9] = 1
	    			end
	    			if elem.attr['Extra10'] == "true" then
	    				secondary.stages[spot][10] = 0
	    			elseif elem.attr['Extra10'] == "false" then
	    				secondary.stages[spot][10] = 1
	    			end
	    			if elem.attr['Extra11'] == "true" then
	    				secondary.stages[spot][11] = 0
	    			elseif elem.attr['Extra11'] == "false" then
	    				secondary.stages[spot][11] = 1
	    			end
	    			if elem.attr['Extra12'] == "true" then
	    				secondary.stages[spot][12] = 0
	    			elseif elem.attr['Extra12'] == "false" then
	    				secondary.stages[spot][12] = 1
	    			end

	    			if elem.attr['Speed'] ~= nil then
	    				secondary.stages[spot].speed = tonumber(elem.attr['Speed'])
	    			end
    			end
    		end
    	end
    	if(xml.root.el[i].name == "ADVISOR") then
    		advisor = {}
    		advisor.stages = {}
    		advisor.speed = tonumber(xml.root.el[i].attr["speed"])
    		for ex=1,#xml.root.el[i].kids do
    			if(string.upper(string.sub(xml.root.el[i].kids[ex].name, 1, -3)) == "STATE") then
    				local spot = tonumber(string.sub(xml.root.el[i].kids[ex].name, 6))
    				local elem = xml.root.el[i].kids[ex]

    				advisor.stages[spot] = {}
    				if elem.attr['Extra1'] == "true" then
	    				advisor.stages[spot][1] = 0
	    			elseif elem.attr['Extra1'] == "false" then
	    				advisor.stages[spot][1] = 1
	    			end
	    			if elem.attr['Extra2'] == "true" then
	    				advisor.stages[spot][2] = 0
	    			elseif elem.attr['Extra2'] == "false" then
	    				advisor.stages[spot][2] = 1
	    			end
	    			if elem.attr['Extra3'] == "true" then
	    				advisor.stages[spot][3] = 0
	    			elseif elem.attr['Extra3'] == "false" then
	    				advisor.stages[spot][3] = 1
	    			end
	    			if elem.attr['Extra4'] == "true" then
	    				advisor.stages[spot][4] = 0
	    			elseif elem.attr['Extra4'] == "false" then
	    				advisor.stages[spot][4] = 1
	    			end
	    			if elem.attr['Extra5'] == "true" then
	    				advisor.stages[spot][5] = 0
	    			elseif elem.attr['Extra5'] == "false" then
	    				advisor.stages[spot][5] = 1
	    			end
	    			if elem.attr['Extra6'] == "true" then
	    				advisor.stages[spot][6] = 0
	    			elseif elem.attr['Extra6'] == "false" then
	    				advisor.stages[spot][6] = 1
	    			end
	    			if elem.attr['Extra7'] == "true" then
	    				advisor.stages[spot][7] = 0
	    			elseif elem.attr['Extra7'] == "false" then
	    				advisor.stages[spot][7] = 1
	    			end
	    			if elem.attr['Extra8'] == "true" then
	    				advisor.stages[spot][8] = 0
	    			elseif elem.attr['Extra8'] == "false" then
	    				advisor.stages[spot][8] = 1
	    			end
	    			if elem.attr['Extra9'] == "true" then
	    				advisor.stages[spot][9] = 0
	    			elseif elem.attr['Extra9'] == "false" then
	    				advisor.stages[spot][9] = 1
	    			end
	    			if elem.attr['Extra10'] == "true" then
	    				advisor.stages[spot][10] = 0
	    			elseif elem.attr['Extra10'] == "false" then
	    				advisor.stages[spot][10] = 1
	    			end
	    			if elem.attr['Extra11'] == "true" then
	    				advisor.stages[spot][11] = 0
	    			elseif elem.attr['Extra11'] == "false" then
	    				advisor.stages[spot][11] = 1
	    			end
	    			if elem.attr['Extra12'] == "true" then
	    				advisor.stages[spot][12] = 0
	    			elseif elem.attr['Extra12'] == "false" then
	    				advisor.stages[spot][12] = 1
	    			end

	    			if elem.attr['Speed'] ~= nil then
	    				advisor.stages[spot].speed = tonumber(elem.attr['Speed'])
	    			end
	    		end
    		end
    	end
    end

    if primary.stages ~= nil then
    	patternInfoTable.primarys[#patternInfoTable.primarys + 1] = primary
    end
    if secondary.stages ~= nil then
    	patternInfoTable.secondarys[#patternInfoTable.secondarys + 1] = secondary
    end
    if advisor.stages ~= nil then
    	patternInfoTable.advisors[#patternInfoTable.advisors + 1] = advisor
    end
    patternInfoTable[#patternInfoTable + 1] = a

	if outputLoading and outputLoading ~= nil then
		if printDebugInformation == nil or printDebugInformation == true then
			print("Done with pattern: " .. fileName)
		end
	end
end

function parseObjSet(data, fileName)
    local xml = SLAXML:dom(data, fileName)
    if xml and xml.root then
        if xml.root.name == "vcfroot" then
            parseVehData(xml, fileName)
        elseif xml.root.name == "pattern" then
        	parsePatternData(xml, fileName)
        end
    end
end

function configCheck()
	if (panelOffsetX == nil) then
		print("\n\n[ERROR] Please add 'panelOffsetX = 0.0' to your config or you will not get a panel.\n\n")
	end
	if (panelOffsetY == nil) then
		print("\n\n[ERROR] Please add 'panelOffsetY = 0.0' to your config or you will not get a panel.\n\n")
	end
end

AddEventHandler('onResourceStart', function(name)
	if name:lower() == GetCurrentResourceName():lower() then
		patternInfoTable.primarys = {}
		patternInfoTable.secondarys = {}
		patternInfoTable.advisors = {}
	    for i=1,#vcf_files do
	    	local data = LoadResourceFile(GetCurrentResourceName(), "vcf/" .. vcf_files[i])

		    if data then
		        parseObjSet(data, vcf_files[i])
		    end
	    end

	    -- for i=1,#pattern_files do
	    -- 	local data = LoadResourceFile(GetCurrentResourceName(), "patterns/" .. pattern_files[i])

		   --  if data then
		   --      parseObjSet(data, pattern_files[i])
		   --  end
	    -- end
	    configCheck()
	end
end)

RegisterServerEvent("els:requestVehiclesUpdate")
AddEventHandler('els:requestVehiclesUpdate', function()
	if printDebugInformation == nil or printDebugInformation == true then
		print("Sending player (" .. source .. ") ELS data")
	end

	TriggerClientEvent("els:updateElsVehicles", source, vehicleInfoTable, patternInfoTable)
end)

RegisterServerEvent("els:changeLightStage_s")
AddEventHandler("els:changeLightStage_s", function(state, advisor, prim, sec)
	TriggerClientEvent("els:changeLightStage_c", -1, source, state, advisor, prim, sec)
end)

RegisterServerEvent("els:changePartState_s")
AddEventHandler("els:changePartState_s", function(part, state)
	TriggerClientEvent("els:changePartState_c", -1, source, part, state)
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
	TriggerClientEvent("els:setTakedownState_c", -1, source)
end)

RegisterServerEvent("els:setSceneLightState_s")
AddEventHandler("els:setSceneLightState_s", function(state)
	TriggerClientEvent("els:setSceneLightState_c", -1, source)
end)

RegisterServerEvent("els:setCruiseLights_s")
AddEventHandler("els:setCruiseLights_s", function(state)
	TriggerClientEvent("els:setCruiseLights_c", -1, source)
end)