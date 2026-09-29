local ADDON_NAME, addonTable = ...

-- HOT PATH CACHING: Cache local engine pointers to boost frame rendering speeds
local UnitExists, UnitIsDead, UnitCanAttack = UnitExists, UnitIsDead, UnitCanAttack
local UnitThreatSituation, UnitClass, UnitIsUnit = UnitThreatSituation, UnitClass, UnitIsUnit
local GetTime, math_max, math_floor, type, pairs, next = GetTime, math.max, math.floor, type, pairs, next
local IsInGroup, IsInRaid, InCombatLockdown, PlaySound = IsInGroup, IsInRaid, InCombatLockdown, PlaySound
local string_find, type = string.find, type

local UpdateSingleWidgetData
-- DYNAMIC OFFTARGET ESTIMATION MATRIX
local function EstimateFluidOffTargetThreat(unit, currentStatus)
    if currentStatus == 3 then return 100
    elseif currentStatus == 2 then return 90
    elseif currentStatus == 1 then return 75 end
    
    local highestGroupStatus = 0
    if UnitExists("pet") then 
        highestGroupStatus = math_max(highestGroupStatus, UnitThreatSituation("pet", unit) or 0) 
    end
    
    if IsInGroup() or IsInRaid() then
        for i = 1, 4 do
            if UnitExists("party" .. i) then 
                highestGroupStatus = math_max(highestGroupStatus, UnitThreatSituation("party" .. i) or 0) 
            end
            if UnitExists("partypet" .. i) then 
                highestGroupStatus = math_max(highestGroupStatus, UnitThreatSituation("partypet" .. i) or 0) 
            end
        end
        if IsInRaid() then
            for i = 1, 40 do 
                if UnitExists("raid" .. i) then 
                    highestGroupStatus = math_max(highestGroupStatus, UnitThreatSituation("raid" .. i) or 0) 
                end 
            end
        end
    end
    
    if highestGroupStatus == 3 then return nil
    elseif highestGroupStatus == 2 or highestGroupStatus == 1 then return 55 end
    return 20 
end

-- HIGH-SPEED TEXTURE & COLOR INTERPOLATOR (V7.8.0 - TEXT CHANNEL ARRAY FIX)
UpdateSingleWidgetData = function(frame, unit)
    local isTestFrame = (unit == "test")
    if not isTestFrame then
        if not UnitExists(unit) or UnitIsDead(unit) or not UnitCanAttack("player", unit) then 
            frame:Hide() return 
        end
    end
    
    local currentDB = addonTable.GetDB()
    local activeTexture = addonTable.GetActiveTexture()
    
    local status = 0
    local rawThreatPercentage = 0
    if not isTestFrame then
        local rawStatus, rawPercent = UnitThreatSituation("player", unit)
        if rawStatus then
            status = tonumber(rawStatus) or 0
            rawThreatPercentage = tonumber(rawPercent) or 0
        end
    else
        status = 1
        rawThreatPercentage = 50
    end
    
    -- Establish native threat color values directly
    local displayColor = { 1.00, 0.55, 0.00 } -- Default Warning Amber

    local isTaunted = false
    local isTargetingPlayer = false
    if not isTestFrame then
        local targetToken = unit .. "target"
        if UnitExists(targetToken) then
            if UnitIsUnit("player", targetToken) then
                isTargetingPlayer = true
            elseif status == 0 and not UnitIsUnit("pet", targetToken) then
                if frame.currentThreatDisplayValue and frame.currentThreatDisplayValue > 30 then
                    if addonTable.IsUnitEngagedWithMyGroup(unit) then
                        isTaunted = true
                    end
                end
            end
        end
    end

    local isCurrentTarget = isTestFrame
    if not isTestFrame then isCurrentTarget = UnitIsUnit(unit, "target") end
    
    local currentScale = currentDB.widgetScale or 1.0
    if isCurrentTarget and currentDB.highlightTarget then
        frame:SetScale(currentScale * (currentDB.targetScale or 1.35))
        frame.text:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE")
    else
        frame:SetScale(currentScale) 
        frame.text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    end

    local playerIsTank = false
    if addonTable.IsPlayerTank and addonTable.IsPlayerTank() then
        playerIsTank = true
    else
        local assignedRole = UnitGroupRolesAssigned and UnitGroupRolesAssigned("player")
        if assignedRole == "TANK" then playerIsTank = true end
    end

    local targetPercent = 0
    if isTestFrame then
        targetPercent = 50
    else
        if rawThreatPercentage > 0 then
            targetPercent = math_floor(rawThreatPercentage)
            if isTargetingPlayer or status == 3 then
                if targetPercent < 100 then targetPercent = 100 end
            end
        else
            if isTargetingPlayer or status == 3 then
                targetPercent = 100
            elseif status == 2 then
                targetPercent = 90
            elseif status == 1 then
                targetPercent = 75
            else
                local estimatedBase = EstimateFluidOffTargetThreat(unit, status)
                if estimatedBase then 
                    targetPercent = estimatedBase
                else
                    local now = GetTime()
                    if not frame.combatStartTime then frame.combatStartTime = now end
                    local duration = now - frame.combatStartTime
                    local timeFactor = (duration / 12)
                    if timeFactor > 1 then timeFactor = 1 end
                    targetPercent = math_floor(15 + (timeFactor * 57))
                end
            end
        end
    end

    if not frame.currentThreatDisplayValue then frame.currentThreatDisplayValue = targetPercent end
    local diff = targetPercent - frame.currentThreatDisplayValue
    if (diff > 0.5 or diff < -0.5) then 
        frame.currentThreatDisplayValue = frame.currentThreatDisplayValue + (diff * 0.20)
    else 
        frame.currentThreatDisplayValue = targetPercent 
    end
    local finalDisplayValue = math_floor(frame.currentThreatDisplayValue)

    -- Assign direct colors arrays cleanly
    if not isTestFrame then
        if isTaunted then 
            displayColor = { 0.00, 0.85, 1.00 } -- Taunt Blue
        elseif playerIsTank then
            if status == 3 or finalDisplayValue >= 100 then displayColor = { 0.10, 0.85, 0.10 } -- Good Green
            elseif status == 1 or status == 2 or finalDisplayValue >= 75 then displayColor = { 1.00, 0.55, 0.00 } -- Warn Amber
            else displayColor = { 1.00, 0.10, 0.10 } end -- Bad Red
        else
            if status == 3 or finalDisplayValue >= 100 then displayColor = { 1.00, 0.10, 0.10 } -- Bad Red
            elseif status == 1 or status == 2 or finalDisplayValue >= 75 then displayColor = { 1.00, 0.55, 0.00 } -- Warn Amber
            else displayColor = { 0.10, 0.85, 0.10 } end -- Good Green
        end
    end

    if isTaunted then 
        frame.text:SetText(addonTable.SafeGetText("STATUS_TAUNT")) 
    else 
        frame.text:SetText(finalDisplayValue .. "%") 
    end

    if not isTestFrame and status and addonTable.TriggerThreatAudioAlert then
        addonTable.TriggerThreatAudioAlert(unit, status)
    end

    -- ===========================================================================
    -- SEPARATE OPACITY COUPLING ENGINES HOOK
    -- ===========================================================================
    local masterTextAlpha = currentDB.widgetAlpha or 1.0
    local iconAlphaSliderValue = currentDB.colorAlpha or 1.0

    -- FIXED EXPLICIT ARRAY INDEXING EXTRACTION:
    -- Pulls numerical coordinate key values directly from bracket positional indices, [2], [3]
    local r, g, b = 1, 1, 1
    if type(displayColor) == "table" and #displayColor >= 3 then
        r, g, b = displayColor[1], displayColor[2], displayColor[3]
    else
        local fallbackColor = playerIsTank and {1, 0.1, 0.1} or {0.1, 0.85, 0.1}
        r, g, b = fallbackColor[1], fallbackColor[2], fallbackColor[3]
    end

    -- 1. TEXT LAYER: Only influenced by the Master Threat Opacity slider tracking channel
    frame.text:SetTextColor(r, g, b, 1.0)
    frame.text:SetAlpha(masterTextAlpha)

    -- 2. ICON LAYER: Completely broken off from text alpha loops!
    if activeTexture then
        local correctedTexture = tonumber(activeTexture) or activeTexture
        frame.signal:SetTexture(correctedTexture)
        
        -- DYNAMIC BYPASS MATRIX:
        if iconAlphaSliderValue == 0 then
            -- Native color mode: Draw the icon at 100% full opacity, leaving text colored!
            frame.signal:SetVertexColor(1, 1, 1, 1.0)
        else
            -- Threat color overlay tint mode: Uses only your Icon Texture Color Opacity slider settings channel
            frame.signal:SetVertexColor(r, g, b, iconAlphaSliderValue)
        end
        
        if not frame.signal:IsShown() then frame.signal:Show() end
    else
        frame.signal:Hide()
    end
    
    if not frame:IsShown() then frame:Show() end
end


-- MASTER MULTI-NAMEPLATE ITERATOR LOOP (V7.3.0 - MASK SYNC OVERHAUL FIXED)
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
    
    for i = 1, #nameplates do
        local nameplate = nameplates[i]
        if nameplate and not nameplate:IsForbidden() then
            local unit = nameplate.namePlateUnitToken or (nameplate.UnitFrame and nameplate.UnitFrame.unit)
            if unit and UnitExists(unit) and not UnitIsDead(unit) and UnitCanAttack("player", unit) and addonTable.IsUnitEngagedWithMyGroup(unit) then
                
                local skipMob = false
                if currentDB.filterTrivial then
                    if UnitClassification and UnitClassification(unit) == "trivial" then 
                        skipMob = true
                    else
                        local name = UnitName(unit)
                        if name and (string_find(name, "Totem") or string_find(name, "totem")) then 
                            skipMob = true 
                        end
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
                    
                    frame:SetParent(nameplate)
                    frame.unit = unit 
                    
                    -- CRITICAL ENHANCEMENT MASK SYNC:
                    -- Re-verify mask state dynamically on the active widget. 
                    -- This ensures that frames freshly pulled out of the cache pool 
                    -- immediately respect your choice toggle settings.
                    if frame.signal then
                        if currentDB.cutIconEdges and frame.signal.SetMask then
                            frame.signal:SetMask("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
                        elseif frame.signal.RemoveMask then
                            frame.signal:RemoveMask()
                        end
                    end
                    
                    frame:ClearAllPoints() 
                    frame:SetPoint("LEFT", anchor, "RIGHT", currentDB.xOffset or 10, 0) 
                    
                    if not frame:IsShown() then frame:Show() end
                    UpdateSingleWidgetData(frame, unit)
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
    elseif (event == "NAME_PLATE_UNIT_ADDED" or event == "NAME_PLATE_UNIT_REMOVED") then 
        TTP_RefreshAllNameplates() 
    end
end)

function addonTable.TriggerThreatAudioAlert(unit, status)
    local currentDB = addonTable.GetDB()
    if not currentDB or not currentDB.enableSound then return end
    
    local now = GetTime()
    addonTable.soundCooldowns = addonTable.soundCooldowns or {}
    local lastPlayed = addonTable.soundCooldowns[unit] or 0
    
    if (now - lastPlayed) >= 3.5 then
        local playerIsTank = false
        if addonTable.IsPlayerTank and addonTable.IsPlayerTank() then
            playerIsTank = true
        else
            local assignedRole = UnitGroupRolesAssigned and UnitGroupRolesAssigned("player")
            if assignedRole == "TANK" then playerIsTank = true end
        end
        
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
