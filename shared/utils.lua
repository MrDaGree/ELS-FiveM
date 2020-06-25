function string_lower(str)
    if not str or type(str) ~= "string" then
        return
    end

    return string.lower(str)
end

function string_upper(str)
    if not str or type(str) ~= "string" then
        return
    end

    return string.upper(str)
end