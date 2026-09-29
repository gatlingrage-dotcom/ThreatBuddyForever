local ADDON_NAME, addonTable = ...

-- MASTER THEME DICTIONARY (V7.1.0 - UNBLOCKABLE NATIVE ENGINE SHAPES)
addonTable.THEMES = {
    SIGNAL_LIGHT = {
        size = 36, 
        font = STANDARD_TEXT_FONT,
        fontSize = 11,
        texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", 
        texCoords = { 0.25, 0.50, 0, 0.25 }, -- Hardware crops directly to a perfect round solid circle disk
        isCircle = true,
        colors = {
            good = { 0.10, 0.85, 0.10 }, -- Safe Green
            warn = { 1.00, 0.55, 0.00 }, -- Warning Amber
            bad  = { 1.00, 0.10, 0.10 }, -- Danger Red
            idle = { 0.25, 0.25, 0.25 }, 
            taunt = { 0.00, 0.80, 1.00 } 
        }
    },
    SQUARE_PLATE = { 
        size = 38,
        font = STANDARD_TEXT_FONT,
        fontSize = 11,
        texture = "Interface\\CastingBar\\UI-CastingBar-Border", 
        texCoords = { 0.10, 0.90, 0.22, 0.78 }, -- Hardware crops to isolate a gorgeous chiseled rectangular box
        isCircle = false,
        colors = {
            good = { 0.10, 0.85, 0.30 }, 
            warn = { 1.00, 0.65, 0.00 }, 
            bad  = { 1.00, 0.10, 0.20 }, 
            idle = { 0.20, 0.20, 0.20 },
            taunt = { 0.00, 0.80, 1.00 }
        }
    },
    MODERN_HUD = { 
        size = 44, 
        font = STANDARD_TEXT_FONT,
        fontSize = 11,
        texture = "Interface\\Minimap\\UI-Minimap-Border", 
        texCoords = { 0.05, 0.95, 0.05, 0.95 }, -- Hardware crops out layout borders to isolate a thin ring loop
        isCircle = true,
        colors = {
            good = { 0.00, 1.00, 0.50 }, -- Electric Neon Green
            warn = { 1.00, 0.75, 0.00 }, -- Amber Gold
            bad  = { 1.00, 0.15, 0.15 }, -- Plasma Danger Red
            idle = { 0.20, 0.20, 0.20 },
            taunt = { 0.00, 0.85, 1.00 }
        }
    }
}

function addonTable.GetActiveTheme()
    local currentDB = addonTable.GetDB()
    local styleKey = currentDB.visualStyle or "SIGNAL_LIGHT"
    return addonTable.THEMES[styleKey] or addonTable.THEMES.SIGNAL_LIGHT
end
-- HIGH-PERFORMANCE UNBLOCKABLE GEOMETRY ALLOCATOR
function addonTable.CreateNewSignalWidget()
    local activeTheme = addonTable.GetActiveTheme()
    local widgetPool = addonTable.widgetPool
    
    if #widgetPool > 0 then
        local frame = table.remove(widgetPool)
        frame:SetScale(addonTable.GetDB().widgetScale or 1.0)
        return frame
    end
    
    -- Created clean without BackdropTemplate allocations to bypass alpha lock crashes completely
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(activeTheme.size, activeTheme.size)
    frame:SetFrameStrata("HIGH")

    -- 1. BASE BACKGROUND HOUSING: Flat dark backing plate (Only visible for square mode)
    frame.bgTexture = frame:CreateTexture(nil, "BACKGROUND", nil, -2)
    frame.bgTexture:SetTexture("Interface\\Buttons\\WHITE8X8")
    frame.bgTexture:SetVertexColor(0.04, 0.04, 0.04, 0.50)

    -- 2. MAIN VISIBLE GRAPHIC FIXTURE: Sits securely on the middle ARTWORK layout channel
    frame.signal = frame:CreateTexture(nil, "ARTWORK", nil, 4) 
    frame.signal:SetSize(activeTheme.size, activeTheme.size)
    frame.signal:SetPoint("CENTER", frame, "CENTER", 0, 0)

    -- Explicitly purge all obsolete masking variables to lock visibility profiles
    frame.circleMask = nil
    frame.innerMask = nil

    -- 3. NUMERIC PERCENTAGE TEXT LAYER (Floats at the very top of the stack)
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge", 7)
    frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.text:SetFont(STANDARD_TEXT_FONT, activeTheme.fontSize, "OUTLINE")
    frame.text:SetTextColor(1, 1, 1)
    
    return frame
end

function addonTable.RecycleSignalWidget(frame)
    frame:Hide() frame:ClearAllPoints() frame.unit = nil
    frame.combatStartTime = nil frame.currentThreatDisplayValue = 0
    table.insert(addonTable.widgetPool, frame)
end
-- REAL-TIME TRANSFORMS CONTROLLER (V7.1.0 - SECURE VECTOR ASSIGNMENT HOOKS)
function addonTable.RebuildWidgetTextures()
    local currentDB = addonTable.GetDB()
    local activeTheme = addonTable.GetActiveTheme()
    local showBackdrop = currentDB.showBackgroundFrame
    
    for _, frame in pairs(addonTable.activeWidgets) do
        frame:SetSize(activeTheme.size, activeTheme.size)
        
        if not showBackdrop then
            frame.signal:Hide()
            frame.bgTexture:Hide()
        else
            frame.signal:SetTexture(activeTheme.texture)
            frame.signal:SetSize(activeTheme.size, activeTheme.size)
            frame.signal:SetTexCoord(unpack(activeTheme.texCoords))
            frame.signal:Show()
            
            if activeTheme.isCircle then
                -- ROUND MODES: Shut down background square blocker plates to leave shape vectors pristine
                frame.bgTexture:Hide()
            else
                -- SQUARE HUD MODE: Fits the dark backing plate container cleanly beneath Blizzard's chiseled layout border
                frame.bgTexture:ClearAllPoints()
                frame.bgTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
                frame.bgTexture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
                frame.bgTexture:Show()
            end
        end
    end
end
