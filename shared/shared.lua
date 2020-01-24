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