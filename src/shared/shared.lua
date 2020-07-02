function debugPrint(msg, force, inLoop)
    local prefix = IsDuplicityVersion() and '(server)' or '(client)'
    if EGetConvarBool("els_debug") or force then
        print(prefix .. ' ELS-FiveM: ' .. msg)
        if inLoop then
            Citizen.Wait(500)
        end
    end
end

function EGetConvarBool(convar)
    return GetConvar(tostring(convar), "false") == "true"
end

function table.includes(tbl, val)
    assert(type(tbl) == "table", "Expected type 'table', got " .. type(tbl) .. ".")

    if type(val) == "string" and tbl[val] then
        return true
    end

    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end

    return false
end