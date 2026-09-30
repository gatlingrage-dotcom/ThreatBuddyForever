local ADDON_NAME, addonTable = ...

-- Slimmed down to a single global default configuration size profile
addonTable.IconSize = 36

-- COMPLETE LUA ENGINE ASSET SOLVER: ZERO HARDCODED DICTIONARIES (V9.0.0)
function addonTable.ResolveIconTexturePath(inputString)
    if not inputString or inputString == "" then 
        return nil -- DEFAULT: Return nil to keep the icon layer completely text-only
    end
    
    -- Clean the string: Convert to lowercase and trim any accidental spaces/whitespaces
    local cleanString = tostring(inputString):gsub("^%s*(.-)%s*$", "%1"):lower()
    
    -- 1. PURE NUMBER CHECK: If the player typed a direct Asset ID (like 4638531), return it instantly
    local numericID = tonumber(cleanString)
    if numericID then 
        return numericID 
    end
    
    -- 2. STRIP COPIED PATH PATTERNS: Extract only the cleanest filename block
    local iconNameOnly = cleanString:match("([^\\/]+)$") or cleanString
    iconNameOnly = iconNameOnly:gsub("%.blp$", ""):gsub("%.png$", "")
    
    -- 3. UN-BLOCKED ENGINE TEXTURE REGISTER INTERCEPT:
    -- Instead of passing a dead string, we query Blizzard's filesystem table.
    -- If C_Texture isn't ready or returns nil, we explicitly pass the exact 
    -- texture name format that SetTexture() uses to dynamically pull from the client data.
    if C_Texture and C_Texture.GetFileSystemTextureID then
        local resolvedID = C_Texture.GetFileSystemTextureID(iconNameOnly)
        if resolvedID and resolvedID > 0 then
            return resolvedID
        end
        
        -- Safe auto-correct step for truncated legacy names (like mindfreeze -> mindfreez)
        local truncatedName = iconNameOnly:sub(1, #iconNameOnly - 1)
        local truncatedID = C_Texture.GetFileSystemTextureID(truncatedName)
        if truncatedID and truncatedID > 0 then
            return truncatedID
        end
    end
    
    -- 4. THE MAGIC UNBREAKABLE FALLBACK INTERFACE ROUTE:
    -- If the game engine's lookup hasn't indexed the name yet, passing a string formatted 
    -- with lowercase forward-slashes bypasses the hard string block and forces the 
    -- graphic layer renderer to fetch the file token natively by name string!
    return "interface/icons/" .. iconNameOnly
end



function addonTable.GetActiveTexture()
    local currentDB = addonTable.GetDB()
    return addonTable.ResolveIconTexturePath(currentDB.customIconPath)
end

-- ===========================================================================
-- DUAL-CHANNEL TEXTURE WIDGET MANAGER (V10.0.0 - MASK LOCK BYPASS)
-- ===========================================================================
function addonTable.CreateNewSignalWidget()
    local widgetPool = addonTable.widgetPool
    
    if #widgetPool > 0 then
        local frame = table.remove(widgetPool)
        frame:SetScale(addonTable.GetDB().widgetScale or 1.0)
        return frame
    end
    
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(addonTable.IconSize, addonTable.IconSize)
    frame:SetFrameStrata("HIGH")

    -- CHANNEL A: Standard crisp square icon layout
    frame.signal = frame:CreateTexture(nil, "ARTWORK", nil, 1) 
    frame.signal:SetSize(addonTable.IconSize, addonTable.IconSize)
    frame.signal:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.signal:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- Clean border trim

    -- CHANNEL B: Dedicated rounded mask icon layout (Permanent clipping anchor)
    frame.signalMasked = frame:CreateTexture(nil, "ARTWORK", nil, 2)
    frame.signalMasked:SetSize(addonTable.IconSize, addonTable.IconSize)
    frame.signalMasked:SetPoint("CENTER", frame, "CENTER", 0, 0)
    
    if frame.signalMasked.SetMask then
        frame.signalMasked:SetMask("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    end

    -- THE PERCENTAGE TEXT LAYER
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge", 7)
    frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    frame.text:SetTextColor(1, 1, 1)
    
    return frame
end

function addonTable.RecycleSignalWidget(frame)
    frame:Hide() 
    frame:ClearAllPoints() 
    frame.unit = nil
    frame.combatStartTime = nil 
    frame.currentThreatDisplayValue = 0
    if frame.signal then frame.signal:Hide() end
    if frame.signalMasked then frame.signalMasked:Hide() end
    table.insert(addonTable.widgetPool, frame)
end

function addonTable.RebuildWidgetTextures()
    local activeTexture = addonTable.GetActiveTexture()
    local currentDB = addonTable.GetDB()
    
    for _, frame in pairs(addonTable.activeWidgets) do
        if frame then
            frame:SetSize(addonTable.IconSize, addonTable.IconSize)
            
            -- Route active drawing channels based on the current sub-option toggle state
            local activeLayer = currentDB.cutIconEdges and frame.signalMasked or frame.signal
            local inactiveLayer = currentDB.cutIconEdges and frame.signal or frame.signalMasked
            
            inactiveLayer:Hide()
            
            if activeTexture then
                local correctedTexture = tonumber(activeTexture) or activeTexture
                activeLayer:SetTexture(correctedTexture)
                activeLayer:Show()
            else
                activeLayer:Hide()
            end
            
            if frame.unit and addonTable.UpdateSingleWidgetData then
                addonTable.UpdateSingleWidgetData(frame, frame.unit)
            end
        end
    end
end
