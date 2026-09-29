local ADDON_NAME, addonTable = ...

-- Expose internal caching nodes safely across separate files [1.32]
addonTable.activeWidgets = addonTable.activeWidgets or {}
addonTable.widgetPool = addonTable.widgetPool or {}
addonTable.soundCooldowns = addonTable.soundCooldowns or {}

-- Core database lookup profile routing (Global node vs character-locked profile)
function addonTable.GetDB()
    local charKey = UnitName("player") .. " - " .. GetRealmName()
    if ThreatBuddyForeverDB and ThreatBuddyForeverDB.useCharProfile then
        ThreatBuddyForeverDB.charProfiles = ThreatBuddyForeverDB.charProfiles or {}
        ThreatBuddyForeverDB.charProfiles[charKey] = ThreatBuddyForeverDB.charProfiles[charKey] or {}
        return ThreatBuddyForeverDB.charProfiles[charKey]
    end
    return ThreatBuddyForeverDB or {}
end

-- Fallback localization string module
function addonTable.SafeGetText(key)
    if addonTable.GetText then return addonTable.GetText(key)
    elseif addonTable.L and addonTable.L[key] then return addonTable.L[key] end
    if key == "STATUS_AGRO" then return "AGRO"
    elseif key == "STATUS_WARN" then return "WARN"
    elseif key == "STATUS_OK" then return "SAFE"
    elseif key == "STATUS_TAUNT" then return "TAUNT" end
    return ""
end

-- Fixed Event bootstrapper frame
local bootFrame = CreateFrame("Frame")
bootFrame:RegisterEvent("ADDON_LOADED")
bootFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        _G.ThreatBuddyForeverDB = _G.ThreatBuddyForeverDB or {}
        local db = _G.ThreatBuddyForeverDB
        
        -- Establish resilient system defaults
        db.widgetScale = db.widgetScale or 1.0
        db.xOffset = db.xOffset or 10
        db.enableGlow = (db.enableGlow ~= false)
        db.hideWhileSolo = (db.hideWhileSolo == true)
        db.showSoloWithPet = (db.showSoloWithPet ~= false)
        db.updateThrottle = db.updateThrottle or 0.08
        db.enableSound = (db.enableSound == true)
        db.highlightTarget = (db.highlightTarget ~= false)
        db.filterTrivial = (db.filterTrivial ~= false)
        db.targetScale = db.targetScale or 1.35
        db.useCharProfile = (db.useCharProfile == true)
        db.visualStyle = db.visualStyle or "SIGNAL_LIGHT"
        db.widgetAlpha = db.widgetAlpha or 1.0
        db.colorAlpha = db.colorAlpha or 1.0
        db.cutIconEdges = (db.cutIconEdges == true) 
        db.showBackgroundFrame = (db.showBackgroundFrame ~= false)

        
        local currentDB = addonTable.GetDB()
        for _, frame in pairs(addonTable.activeWidgets) do 
            if frame and frame.SetScale then frame:SetScale(currentDB.widgetScale or 1.0) end 
        end
    end
end)
local ADDON_NAME, addonTable = ...

-- Expose internal caching nodes safely across separate files [1.32]
addonTable.activeWidgets = addonTable.activeWidgets or {}
addonTable.widgetPool = addonTable.widgetPool or {}
addonTable.soundCooldowns = addonTable.soundCooldowns or {}

-- Core database lookup profile routing (Global node vs character-locked profile)
function addonTable.GetDB()
    local charKey = UnitName("player") .. " - " .. GetRealmName()
    if ThreatBuddyForeverDB and ThreatBuddyForeverDB.useCharProfile then
        ThreatBuddyForeverDB.charProfiles = ThreatBuddyForeverDB.charProfiles or {}
        ThreatBuddyForeverDB.charProfiles[charKey] = ThreatBuddyForeverDB.charProfiles[charKey] or {}
        return ThreatBuddyForeverDB.charProfiles[charKey]
    end
    return ThreatBuddyForeverDB or {}
end

-- Fallback localization string module
function addonTable.SafeGetText(key)
    if addonTable.GetText then return addonTable.GetText(key)
    elseif addonTable.L and addonTable.L[key] then return addonTable.L[key] end
    if key == "STATUS_AGRO" then return "AGRO"
    elseif key == "STATUS_WARN" then return "WARN"
    elseif key == "STATUS_OK" then return "SAFE"
    elseif key == "STATUS_TAUNT" then return "TAUNT" end
    return ""
end

-- Fixed Event bootstrapper frame
local bootFrame = CreateFrame("Frame")
bootFrame:RegisterEvent("ADDON_LOADED")
bootFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        _G.ThreatBuddyForeverDB = _G.ThreatBuddyForeverDB or {}
        local db = _G.ThreatBuddyForeverDB
        
        -- Establish resilient system defaults
        db.widgetScale = db.widgetScale or 1.0
        db.xOffset = db.xOffset or 10
        db.enableGlow = (db.enableGlow ~= false)
        db.hideWhileSolo = (db.hideWhileSolo == true)
        db.showSoloWithPet = (db.showSoloWithPet ~= false)
        db.updateThrottle = db.updateThrottle or 0.08
        db.enableSound = (db.enableSound == true)
        db.highlightTarget = (db.highlightTarget ~= false)
        db.filterTrivial = (db.filterTrivial ~= false)
        db.targetScale = db.targetScale or 1.35
        db.useCharProfile = (db.useCharProfile == true)
        db.visualStyle = db.visualStyle or "SIGNAL_LIGHT"
        
        local currentDB = addonTable.GetDB()
        for _, frame in pairs(addonTable.activeWidgets) do 
            if frame and frame.SetScale then frame:SetScale(currentDB.widgetScale or 1.0) end 
        end
    end
end)
