outputLoading = false
playButtonPressSounds = true
printDebugInformation = false

vehicleSyncDistance = 150
environmentLightBrightness = 0.006
lightDelay = 10 -- Time in MS
flashDelay = 15

panelEnabled = true
panelType = "original"
panelOffsetX = 0.0
panelOffsetY = 0.0

allowedPanelTypes = {
    "original",
    "old"
}

-- https://docs.fivem.net/game-references/controls

shared = {
    horn = 86,
}

keyboard = {
    modifyKey = 132,
    stageChange = 85, -- E
    guiKey = 199, -- P
    takedown = 83, -- =
    siren = {
        tone_one = 157, -- 1
        tone_two = 158, -- 2
        tone_three = 160, -- 3
    },
    pattern = {
        primary = 163, -- 9
        secondary = 162, -- 8
        advisor = 161, -- 7
    },
    warning = 246, -- Y
    secondary = 303, -- U
    primary = 7, -- ?? 
}

controller = {
    modifyKey = 73,
    stageChange = 80,
    takedown = 74,
    siren = {
        tone_one = 173,
        tone_two = 85,
        tone_three = 172,
    },
}