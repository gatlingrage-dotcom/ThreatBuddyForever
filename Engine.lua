local ADDON_NAME, addonTable = ...

-- HOT PATH CACHING: Cache local engine pointers to boost frame rendering speeds
local UnitExists, UnitIsDead, UnitCanAttack = UnitExists, UnitIsDead, UnitCanAttack
local UnitThreatSituation, UnitDetailedThreatSituation = UnitThreatSituation, UnitDetailedThreatSituation
local UnitClass, UnitIsUnit = UnitClass, UnitIsUnit
local GetTime, math_max, math_min, math_floor, math_sin, type, pairs, next = GetTime, math.max, math.min, math.floor, math.sin, type, pairs, next
local IsInGroup, IsInRaid, InCombatLockdown, PlaySound = IsInGroup, IsInRaid, InCombatLockdown, PlaySound
local string_find, type = string.find, type

local UpdateSingleWidgetData
-- Minimum distance from the nameplate; the Lateral Distance slider adds to it
addonTable.BaseOffset = 50

local function ReadThreatNumber(value)
    if issecretvalue and issecretvalue(value) then return nil end
    if type(value) == "number" then return value end
end

local function IsPlayerTank()
    if addonTable.IsPlayerTank and addonTable.IsPlayerTank() then return true end
    return UnitGroupRolesAssigned and UnitGroupRolesAssigned("player") == "TANK" or false
end

-- HIGH-SPEED TEXTURE & COLOR INTERPOLATOR (V8.1.0 - AGGRO LOSS SCALING)
UpdateSingleWidgetData = function(frame, unit, context)
    local isTestFrame = (unit == "test")
    if not isTestFrame then
        if not UnitExists(unit) or UnitIsDead(unit) or not UnitCanAttack("player", unit) then 
            frame:Hide() return 
        end
    end
    
    local currentDB = context and context.db or addonTable.GetDB()
    local activeTexture
    local playerIsTank
    if context then
        activeTexture = context.texture
        playerIsTank = context.playerIsTank
    else
        activeTexture = addonTable.GetActiveTexture()
        playerIsTank = IsPlayerTank()
    end
    
    local status
    local rawThreatPercentage
    local protectedThreatPercentage
    local hasProtectedThreatPercentage = false
    if not isTestFrame then
        if UnitDetailedThreatSituation then
            local _, detailedStatus, scaledPercent = UnitDetailedThreatSituation("player", unit)
            status = ReadThreatNumber(detailedStatus)
            if issecretvalue and issecretvalue(scaledPercent) then
                protectedThreatPercentage = scaledPercent
                hasProtectedThreatPercentage = true
            else
                rawThreatPercentage = ReadThreatNumber(scaledPercent)
            end
            if status == nil then
                status = ReadThreatNumber(UnitThreatSituation("player", unit))
            end
        else
            status = ReadThreatNumber(UnitThreatSituation("player", unit))
        end
    else
        status = 1
        rawThreatPercentage = 50
    end
    
    -- Establish native threat color values directly
    local displayColor = { 1.00, 0.55, 0.00 } -- Default Warning Amber

    local isTargetingGroupMember = false
    if playerIsTank and not isTestFrame then
        local targetToken = unit .. "target"
        if UnitExists(targetToken) then
            local success, isTargetingGroup = pcall(addonTable.IsUnitTargetingGroupMember, unit)
            if success and isTargetingGroup then isTargetingGroupMember = true end
        end
    end

    local isCurrentTarget = isTestFrame
    if not isTestFrame then isCurrentTarget = UnitIsUnit(unit, "target") end

    -- Emphasize mobs attacking teammates when the player is a tank but lacks top threat.
    local tankLostAggro = playerIsTank and isTargetingGroupMember and status ~= nil and (status < 3)

    -- DYNAMIC SIZE SCALE LAYER: Automatically grows 40% larger if you lose aggro!
    local currentScale = currentDB.widgetScale or 1.0
    if tankLostAggro then
        frame:SetScale(currentScale * (currentDB.targetScale or 1.35) * 1.40) -- Extra 40% size boost to find the mob!
        frame.text:SetFont(STANDARD_TEXT_FONT, 14, "THICKOUTLINE")
    elseif isCurrentTarget and currentDB.highlightTarget then
        frame:SetScale(currentScale * (currentDB.targetScale or 1.35))
        frame.text:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE")
    else
        frame:SetScale(currentScale) 
        frame.text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    end

    local finalDisplayValue
    if rawThreatPercentage ~= nil then
        local targetPercent = math_max(0, math_min(100, rawThreatPercentage))
        if frame.currentThreatDisplayValue == nil then frame.currentThreatDisplayValue = targetPercent end
        local diff = targetPercent - frame.currentThreatDisplayValue
        if (diff > 0.5 or diff < -0.5) then
            frame.currentThreatDisplayValue = frame.currentThreatDisplayValue + (diff * 0.40)
        else
            frame.currentThreatDisplayValue = targetPercent
        end
        finalDisplayValue = math_floor(frame.currentThreatDisplayValue)
    else
        frame.currentThreatDisplayValue = nil
        displayColor = { 0.75, 0.75, 0.75 }
    end

    -- Assign direct colors arrays cleanly with persistence overrides
    if not isTestFrame and finalDisplayValue ~= nil then
        if playerIsTank then
            if status == 3 or finalDisplayValue >= 100 then displayColor = { 0.10, 0.85, 0.10 } -- Good Green
            elseif status == 1 or status == 2 or finalDisplayValue >= 75 then displayColor = { 1.00, 0.55, 0.00 } -- Warn Amber
            else displayColor = { 1.00, 0.10, 0.10 } end -- Bad Red
        else
            if status == 3 or finalDisplayValue >= 100 then displayColor = { 1.00, 0.10, 0.10 } -- Bad Red
            elseif status == 1 or status == 2 or finalDisplayValue >= 75 then displayColor = { 1.00, 0.55, 0.00 } -- Warn Amber
            else displayColor = { 0.10, 0.85, 0.10 } end -- Good Green
        end
    end

    if finalDisplayValue ~= nil then
        frame.text:SetText(finalDisplayValue .. "%")
    elseif hasProtectedThreatPercentage then
        frame.text:SetFormattedText("%.0f%%", protectedThreatPercentage)
    else
        frame.text:SetText("--")
    end

    if not isTestFrame and status and addonTable.TriggerThreatAudioAlert then
        addonTable.TriggerThreatAudioAlert(unit, status, currentDB, playerIsTank)
    end

    -- ===========================================================================
    -- SEPARATE OPACITY COUPLING ENGINES HOOK
    -- ===========================================================================
    local masterTextAlpha = currentDB.widgetAlpha or 1.0
    local iconAlphaSliderValue = currentDB.colorAlpha or 1.0

    -- Extract numerical parameters cleanly to secure indexing
    local r, g, b = 1, 1, 1
    if type(displayColor) == "table" and #displayColor >= 3 then
        r = displayColor[1]
        g = displayColor[2]
        b = displayColor[3]
    else
        local fallbackColor = playerIsTank and {1, 0.1, 0.1} or {0.1, 0.85, 0.1}
        r = fallbackColor[1]
        g = fallbackColor[2]
        b = fallbackColor[3]
    end

    -- A protected percentage can still use an accessible threat status for text color.
    local textR, textG, textB = r, g, b
    if hasProtectedThreatPercentage and status ~= nil then
        if status == 3 then
            if playerIsTank then textR, textG, textB = 0.10, 0.85, 0.10
            else textR, textG, textB = 1.00, 0.10, 0.10 end
        elseif status == 1 or status == 2 then
            textR, textG, textB = 1.00, 0.55, 0.00
        elseif status == 0 then
            if playerIsTank then textR, textG, textB = 1.00, 0.10, 0.10
            else textR, textG, textB = 0.10, 0.85, 0.10 end
        end
    end
    frame.text:SetTextColor(textR, textG, textB, 1.0)
    frame.text:SetAlpha(masterTextAlpha)
    if frame.wisp then
        if currentDB.enableGlow then
            local now = GetTime()
            local threatStrength = 0.48 + 0.32 * ((finalDisplayValue or 0) / 100)
            local pulse = 0.85 + 0.15 * math_sin(now * 2.1)
            if finalDisplayValue == nil then
                frame.wisp:SetVertexColor(0.25, 0.8, 1)
            else
                frame.wisp:SetVertexColor(r, g, b)
            end
            frame.wisp:SetAlpha(threatStrength * pulse)
            frame.wisp:SetRotation(math_sin(now * 0.8) * 0.12)
            frame.wisp:Show()
            if frame.wispModel then frame.wispModel:Show() end
        else
            frame.wisp:Hide()
            if frame.wispModel then frame.wispModel:Hide() end
        end
    end

    -- 2. DUAL-CHANNEL ICON LAYER MATRIX RESOLVER
    if activeTexture then
        local correctedTexture = tonumber(activeTexture) or activeTexture
        
        local activeLayer = currentDB.cutIconEdges and frame.signalMasked or frame.signal
        local inactiveLayer = currentDB.cutIconEdges and frame.signal or frame.signalMasked
        
        inactiveLayer:Hide()
        activeLayer:SetTexture(correctedTexture)
        
        if iconAlphaSliderValue == 0 then
            activeLayer:SetVertexColor(1, 1, 1, 1.0)
        else
            activeLayer:SetVertexColor(r, g, b, iconAlphaSliderValue)
        end
        
        if not activeLayer:IsShown() then activeLayer:Show() end
    else
        if frame.signal then frame.signal:Hide() end
        if frame.signalMasked then frame.signalMasked:Hide() end
    end
    
    if not frame:IsShown() then frame:Show() end
end
-- Picks the rightmost known nameplate piece. Nameplate frames are restricted, so they must not be measured, only anchored to.
local function FindRightmostFrame(anchor)
    local level = anchor.LevelFrame
    if level and level:IsShown() then return level end
    return anchor.HealthBarsContainer or anchor.healthBar or anchor
end

-- MASTER MULTI-NAMEPLATE ITERATOR LOOP (V7.5.0 - DUNGEON SECRET STRING SAFE)
function TTP_RefreshAllNameplates()
    if not addonTable.GetDB then return end
    local currentDB = addonTable.GetDB()
    local activeWidgets = addonTable.activeWidgets
    local IsGrouped = (IsInGroup() or IsInRaid())
    
    if currentDB.hideWhileSolo and not IsGrouped then
        local allowSoloWithPet = currentDB.showSoloWithPet and UnitExists("pet") and not UnitIsDead("pet")
        if not allowSoloWithPet then 
            for unit, frame in pairs(activeWidgets) do 
                if frame then addonTable.RecycleSignalWidget(frame) end
                activeWidgets[unit] = nil 
            end 
            return 
        end
    end
    
    local localFrameUnitsTracker = {}
    local nameplates = C_NamePlate.GetNamePlates()
    local context
    
    for i = 1, #nameplates do
        local nameplate = nameplates[i]
        if nameplate and not nameplate:IsForbidden() then
            local unit = nameplate.namePlateUnitToken or (nameplate.UnitFrame and nameplate.UnitFrame.unit)
            if unit and UnitExists(unit) and not UnitIsDead(unit) and UnitCanAttack("player", unit) and addonTable.IsUnitEngagedWithMyGroup(unit) then
                
                local skipMob = false
                if currentDB.filterTrivial then
                    local success, shouldSkip = pcall(function()
                        local classification = UnitClassification and UnitClassification(unit)
                        if classification == "trivial" then
                            return true
                        end
                        
                        local name = UnitName(unit)
                        if name and (string_find(name, "Totem") or string_find(name, "totem")) then
                            return true
                        end
                        
                        return false
                    end)
                    
                    if success and shouldSkip then
                        skipMob = true
                    end
                end
                
                if not skipMob then
                    localFrameUnitsTracker[unit] = true 
                    local anchor = nameplate.UnitFrame or nameplate
                    local frame = activeWidgets[unit]
                    
                    if frame and (frame.unit ~= unit) then
                        addonTable.RecycleSignalWidget(frame)
                        activeWidgets[unit] = nil
                        frame = nil
                    end
                    
                    if not frame or not frame.signal then
                        frame = addonTable.CreateNewSignalWidget()
                        activeWidgets[unit] = frame
                    end
                    
                    frame:SetParent(anchor)
                    frame.unit = unit 
                    
                    if not frame:IsShown() then frame:Show() end
                    if not context then
                        context = { db = currentDB, texture = addonTable.GetActiveTexture(), playerIsTank = IsPlayerTank() }
                    end
                    UpdateSingleWidgetData(frame, unit, context)

                    -- Offsets are multiplied by the frame's own scale, so divide it out to keep a constant gap
                    local frameScale = frame:GetScale()
                    if not frameScale or frameScale <= 0 then frameScale = 1 end
                    frame:ClearAllPoints() 
                    local pointFrame = FindRightmostFrame(anchor)
                    frame:SetFrameLevel(anchor:GetFrameLevel() + 20)
                    if frame.wispModel then frame.wispModel:SetFrameLevel(frame:GetFrameLevel() + 1) end
                    if frame.textLayer then frame.textLayer:SetFrameLevel(frame:GetFrameLevel() + 2) end
                    frame:SetPoint("LEFT", pointFrame, "RIGHT", (addonTable.BaseOffset + (currentDB.xOffset or 0)) / frameScale, 0) 

                else 
                    if activeWidgets[unit] then 
                        addonTable.RecycleSignalWidget(activeWidgets[unit]) 
                        activeWidgets[unit] = nil 
                    end 
                end
            end
        end
    end
    
    for unit, frame in pairs(activeWidgets) do 
        if not localFrameUnitsTracker[unit] or not UnitExists(unit) or UnitIsDead(unit) then 
            if frame then addonTable.RecycleSignalWidget(frame) end
            activeWidgets[unit] = nil 
        end 
    end
end
-- HIGH-PERFORMANCE UPDATER TICKER THROTTLES
local elapsedTimer = 0
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
eventFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")

eventFrame:SetScript("OnUpdate", function(_, elapsed)
    if not addonTable.GetDB or not addonTable.GetActiveTexture then return end
    local currentDB = addonTable.GetDB()  
    if not currentDB or not currentDB.updateThrottle then return end
    elapsedTimer = elapsedTimer + elapsed
    if elapsedTimer >= currentDB.updateThrottle then 
        elapsedTimer = 0 
        if InCombatLockdown() or next(addonTable.activeWidgets) then 
            TTP_RefreshAllNameplates() 
        end 
    end
end)

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "PLAYER_REGEN_ENABLED" then
        if addonTable.activeWidgets then
            for unit, frame in pairs(addonTable.activeWidgets) do 
                if frame then addonTable.RecycleSignalWidget(frame) end
                addonTable.activeWidgets[unit] = nil
            end
        end
        if addonTable.soundCooldowns then wipe(addonTable.soundCooldowns) end
    elseif event == "PLAYER_ROLES_ASSIGNED" then
        if type(TTP_RefreshAllNameplates) == "function" then
            TTP_RefreshAllNameplates()
        end
    elseif (event == "NAME_PLATE_UNIT_ADDED" or event == "NAME_PLATE_UNIT_REMOVED") then 
        TTP_RefreshAllNameplates() 
    end
end)

function addonTable.TriggerThreatAudioAlert(unit, status, currentDB, playerIsTank)
    currentDB = currentDB or addonTable.GetDB()
    if not currentDB or not currentDB.enableSound then return end
    
    local now = GetTime()
    addonTable.soundCooldowns = addonTable.soundCooldowns or {}
    local lastPlayed = addonTable.soundCooldowns[unit] or 0
    
    if (now - lastPlayed) >= 3.5 then
        if playerIsTank == nil then playerIsTank = IsPlayerTank() end
        
        if playerIsTank and status < 3 then
            addonTable.soundCooldowns[unit] = now
            PlaySound(8174, "Master", true)
        elseif not playerIsTank and status == 3 then
            addonTable.soundCooldowns[unit] = now
            PlaySound(8174, "Master", true)
        end
    end
end

addonTable.UpdateSingleWidgetData = UpdateSingleWidgetData

-- IN-GAME VERSION CHECKING & COMM NETWORKING CHANNELS
local commPrefix = "TBF_VERSION_CHECK"
local versionAlertPlayed = false

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(commPrefix)
elseif RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix(commPrefix)
end

local commFrame = CreateFrame("Frame")
commFrame:RegisterEvent("PLAYER_LOGIN")
commFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
commFrame:RegisterEvent("CHAT_MSG_ADDON")

commFrame:SetScript("OnEvent", function(_, event, prefix, text, channel, sender)
    if event == "PLAYER_LOGIN" or event == "GROUP_ROSTER_UPDATE" then
        if IsInGroup() then
            local targetChannel = IsInRaid() and "RAID" or "PARTY"
            
            if C_ChatInfo and C_ChatInfo.SendAddOnMessage then
                C_ChatInfo.SendAddOnMessage(commPrefix, addonTable.Version, targetChannel)
            elseif SendAddOnMessage then
                SendAddOnMessage(commPrefix, addonTable.Version, targetChannel)
            end
        end
        
    elseif event == "CHAT_MSG_ADDON" and prefix == commPrefix then
        local myName = UnitName("player") .. "-" .. GetRealmName():gsub(" ", "")
        if sender == myName then return end
        
        if text and addonTable.Version and not versionAlertPlayed then
            local currentNum = tonumber(addonTable.Version:gsub("[^%d]", "")) or 200
            local incomingNum = tonumber(text:gsub("[^%d]", "")) or 200
            
            if incomingNum > currentNum then
                versionAlertPlayed = true
                
                C_Timer.After(3.0, function()
                    local alertTextTemplate = addonTable.GetFallbackText and addonTable.GetFallbackText("TEXT_VERSION_ALERT") or "A newer version (V%s) is available!"
                    print(string.format("|cff00ff00ThreatBuddyForever:|r " .. alertTextTemplate, text))
                end)
            end
        end
    end
end)
