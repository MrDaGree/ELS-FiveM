function debugPrint(msg, force, inLoop)
    local prefix = IsDuplicityVersion() and '(server)' or '(client)'
    if printDebugInformation == nil or printDebugInformation == true or force then
        print(prefix .. ' ELS-FiveM: ' .. msg)
        if inLoop then
            Citizen.Wait(500)
        end
    end
end