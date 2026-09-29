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

-- HIGH-SPEED TEXTURE & COLOR INTERPOLATOR (V4.2.5 - BACKDROP COMPATIBLE)
UpdateSingleWidgetData = function(frame, unit)
    local isTestFrame = (unit == "test")
    if not isTestFrame then
        if not UnitExists(unit) or UnitIsDead(unit) or not UnitCanAttack("player", unit) then 
            frame:Hide() return 
        end
    end
    
    local currentDB = addonTable.GetDB()
    local activeTheme = addonTable.GetActiveTheme() 
    local status = isTestFrame and 1 or (UnitThreatSituation("player", unit) or 0)
    local displayColor = activeTheme.colors.warn

    -- OPTIMIZATION: Clean, high-performance native string matching
    local isTaunted = false
    if not isTestFrame and type(UnitDebuff) == "function" then
        for i = 1, 40 do
            local name = UnitDebuff(unit, i)
            if not name then break end
            if string_find(name, "Taunt") or string_find(name, "Growl") or string_find(name, "Mocking") or string_find(name, "Provoke") then 
                isTaunted = true 
                break 
            end
        end
    end

    local isCurrentTarget = isTestFrame
    if not isTestFrame then isCurrentTarget = UnitIsUnit(unit, "target") end
    
    local currentScale = currentDB.widgetScale or 1.0
    if isCurrentTarget and currentDB.highlightTarget then
        frame:SetScale(currentScale * (currentDB.targetScale or 1.35))
        frame.text:SetFont(activeTheme.font, activeTheme.fontSize + 1, "THICKOUTLINE")
    else
        frame:SetScale(currentScale) 
        frame.text:SetFont(activeTheme.font, activeTheme.fontSize, "OUTLINE")
    end

    local playerIsTank = addonTable.IsPlayerTank()
    local targetPercent = isTestFrame and 50 or 0

    if not isTestFrame then
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

    if not frame.currentThreatDisplayValue then frame.currentThreatDisplayValue = isTestFrame and 50 or 0 end
    local diff = targetPercent - frame.currentThreatDisplayValue
    if (diff > 0.5 or diff < -0.5) then 
        frame.currentThreatDisplayValue = frame.currentThreatDisplayValue + (diff * 0.12)
    else 
        frame.currentThreatDisplayValue = targetPercent 
    end
    local finalDisplayValue = math_floor(frame.currentThreatDisplayValue + 0.5)

    if not isTestFrame then
        if isTaunted then 
            displayColor = activeTheme.colors.taunt
        elseif playerIsTank then
            if status == 3 or finalDisplayValue >= 100 then displayColor = activeTheme.colors.good
            elseif status == 1 or status == 2 or finalDisplayValue >= 75 then displayColor = activeTheme.colors.warn
            else displayColor = activeTheme.colors.bad end
        else
            if status == 3 or finalDisplayValue >= 100 then displayColor = activeTheme.colors.bad
            elseif status == 1 or status == 2 or finalDisplayValue >= 75 then displayColor = activeTheme.colors.warn
            else displayColor = activeTheme.colors.good end
        end
    end

    if isTaunted then 
        frame.text:SetText(addonTable.SafeGetText("STATUS_TAUNT")) 
    else 
        frame.text:SetText(finalDisplayValue .. "%") 
    end

    -- INJECTS TARGET SHADE: Paints character class colors onto text strings dynamically
    if not isTestFrame and UnitExists(unit) and UnitIsPlayer(unit) then
        local _, classToken = UnitClass(unit)
        if classToken and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken] then
            local cColor = RAID_CLASS_COLORS[classToken]
            frame.text:SetTextColor(cColor.r, cColor.g, cColor.b, 1.0)
        else frame.text:SetTextColor(1, 1, 1, 1) end
    else
        frame.text:SetTextColor(1, 1, 1, 1)
    end

    -- FIXED SAFETY OVERHAUL: Converts vertex mapping to Backdrop Template border parameters natively [1.32]
    local customAlpha = currentDB.widgetAlpha or 1.0
    local r, g, b = 1, 1, 1
    if type(displayColor) == "table" and #displayColor >= 3 then
        r, g, b = displayColor[1], displayColor[2], displayColor[3]
    else
        local fallbackColor = playerIsTank and activeTheme.colors.bad or activeTheme.colors.good
        r, g, b = fallbackColor[1], fallbackColor[2], fallbackColor[3]
    end

    -- VERTEX COLOR CHANNELS: Applies neon color profiles and updates your alpha opacity multiplier stably
    local customAlpha = currentDB.widgetAlpha or 1.0
    if type(displayColor) == "table" and #displayColor >= 3 then
        frame.signal:SetVertexColor(displayColor[1], displayColor[2], displayColor[3], customAlpha)
    else
        local fallbackColor = playerIsTank and activeTheme.colors.bad or activeTheme.colors.good
        frame.signal:SetVertexColor(fallbackColor[1], fallbackColor[2], fallbackColor[3], customAlpha)
    end
    
    -- Sync text transparency to match the frame alpha curve safely
    frame.text:SetAlpha(customAlpha)
    
    if not frame:IsShown() then frame:Show() end
end




-- MASTER MULTI-NAMEPLATE ITERATOR LOOP
function TTP_RefreshAllNameplates()
    if not addonTable.GetDB then return end
    local currentDB = addonTable.GetDB()
    if currentDB.hideWhileSolo and not IsInGroup() and not IsInRaid() then
        local allowSoloWithPet = currentDB.showSoloWithPet and UnitExists("pet") and not UnitIsDead("pet")
        if not allowSoloWithPet then 
            for unit, frame in pairs(addonTable.activeWidgets) do 
                addonTable.RecycleSignalWidget(frame) 
                addonTable.activeWidgets[unit] = nil 
            end 
            return 
        end
    end
    
    local activeWidgets = addonTable.activeWidgets
    local localFrameUnitsTracker = {}
    local nameplates = C_NamePlate.GetNamePlates()
    
    for i = 1, #nameplates do
        local nameplate = nameplates[i]
        if not nameplate:IsForbidden() then
            local unit = nameplate.namePlateUnitToken or (nameplate.UnitFrame and nameplate.UnitFrame.unit)
            if unit and UnitExists(unit) and not UnitIsDead(unit) and UnitCanAttack("player", unit) and addonTable.IsUnitEngagedWithMyGroup(unit) then
                localFrameUnitsTracker[unit] = true 
                local skipMob = false
                
                if currentDB.filterTrivial then
                    if UnitClassification(unit) == "trivial" then 
                        skipMob = true
                    else
                        local name = UnitName(unit)
                        if name and (string_find(name, "Totem") or string_find(name, "totem")) then 
                            skipMob = true 
                        end
                    end
                end
                
                if not skipMob then
                    local frame = activeWidgets[unit] or addonTable.CreateNewSignalWidget() 
                    activeWidgets[unit] = frame
                    frame.unit = unit 
                    frame:ClearAllPoints() 
                    local anchor = nameplate.UnitFrame or nameplate
                    frame:SetPoint("LEFT", anchor, "RIGHT", currentDB.xOffset or 10, 0) 
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
            addonTable.RecycleSignalWidget(frame) 
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
    if not addonTable.GetDB or not addonTable.GetActiveTheme then return end
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

eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" then
        for unit, frame in pairs(addonTable.activeWidgets) do 
            addonTable.RecycleSignalWidget(frame) 
            addonTable.activeWidgets[unit] = nil 
        end 
        wipe(addonTable.soundCooldowns)
    elseif (event == "NAME_PLATE_UNIT_ADDED" or event == "NAME_PLATE_UNIT_REMOVED") then 
        TTP_RefreshAllNameplates() 
    end
end)

addonTable.UpdateSingleWidgetData = UpdateSingleWidgetData
