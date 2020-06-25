local function getTypeMessage(val, expectedType)
    return "Expected type " .. expectedType .. ", got " .. type(val)
end

function string_lower(str)
    assert(type(str) == "string", getTypeMessage(str, "string"))

    return string.lower(str)
end

function string_upper(str)
    assert(type(str) == "string", getTypeMessage(str, "string"))

    return string.upper(str)
end