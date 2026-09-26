local ADDON_NAME, addonTable = ...

-- MOTOR DE TEMAS SUPREMO
local THEMES = {
    SIGNAL_LIGHT = {
        size = 44,
        font = STANDARD_TEXT_FONT,
        fontSize = 11,
        maskTexture = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask",
        colors = {
            good = { 0.10, 0.85, 0.10 }, -- Verde
            warn = { 1.00, 0.55, 0.00 }, -- Laranja
            bad  = { 1.00, 0.10, 0.10 }, -- Vermelho
            idle = { 0.25, 0.25, 0.25, 0.40 }, -- Cinza
            taunt = { 0.00, 0.80, 1.00 } -- Azul Ciana para Taunt
        }
    }
}
local activeTheme = THEMES.SIGNAL_LIGHT

addonTable.activeWidgets = addonTable.activeWidgets or {}
local activeWidgets = addonTable.activeWidgets
local widgetPool = {}
local soundCooldowns = {}

-- DECLARAÇÃO ANTECIPADA DE SEGURANÇA CONTRA ERROS DE CHAMADA NULA
local UpdateSingleWidgetData
function TTP_RefreshAllNameplates() end

-- Função inteligente para ler o perfil correto (Global ou por Boneco)
function addonTable.GetDB()
    local charKey = UnitName("player") .. " - " .. GetRealmName()
    if ThreatBuddyForeverDB and ThreatBuddyForeverDB.useCharProfile then
        ThreatBuddyForeverDB.charProfiles = ThreatBuddyForeverDB.charProfiles or {}
        ThreatBuddyForeverDB.charProfiles[charKey] = ThreatBuddyForeverDB.charProfiles[charKey] or {}
        return ThreatBuddyForeverDB.charProfiles[charKey]
    end
    return ThreatBuddyForeverDB or {}
end

-- Detetor inteligente se o jogador é Tank ativo usando APIs Clássicas (Vanilla/Classic)
local function IsPlayerTank()
    local class = select(2, UnitClass("player"))
    if class == "WARRIOR" then
        return GetShapeshiftForm() == 2 -- Defensive Stance clássico
    elseif class == "PALADIN" then
        -- No Classic, faz varredura por UnitBuff clássico usando índice numérico
        if type(UnitBuff) == "function" then
            for i = 1, 40 do
                local name = UnitBuff("player", i)
                if name and string.find(name, "Righteous Fury") then return true end
            end
        end
    elseif class == "DRUID" then
        return GetShapeshiftForm() == 1 -- Bear Form clássico
    end
    return false
end

-- Função de proteção para extrair as traduções de forma blindada
local function SafeGetText(key)
    if addonTable.GetText then
        return addonTable.GetText(key)
    elseif addonTable.L and addonTable.L[key] then
        return addonTable.L[key]
    end
    if key == "STATUS_AGRO" then return "AGRO"
    elseif key == "STATUS_WARN" then return "WARN"
    elseif key == "STATUS_OK" then return "SAFE"
    elseif key == "STATUS_TAUNT" then return "TAUNT"
    end
    return ""
end


local function CreateNewSignalWidget()
    if #widgetPool > 0 then
        local frame = table.remove(widgetPool)
        frame:SetScale(addonTable.GetDB().widgetScale or 1.0)
        return frame
    end
    local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    frame:SetSize(activeTheme.size, activeTheme.size)
    frame:SetFrameStrata("HIGH")

    frame.signal = frame:CreateTexture(nil, "ARTWORK")
    frame.signal:SetSize(activeTheme.size, activeTheme.size)
    frame.signal:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.signal:SetTexture(activeTheme.maskTexture)

    frame.glow = frame:CreateTexture(nil, "BACKGROUND")
    frame.glow:SetSize(activeTheme.size + 16, activeTheme.size + 16)
    frame.glow:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.glow:SetTexture("Interface\\UNITPOWERBARALT\\ArtifactChipsBurst")
    frame.glow:Hide()

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.text:SetFont(STANDARD_TEXT_FONT, activeTheme.fontSize, "OUTLINE")
    frame.text:SetTextColor(1, 1, 1)
    return frame
end

local function RecycleSignalWidget(frame)
    frame:Hide() frame:ClearAllPoints() frame.glow:Hide() frame.unit = nil
    table.insert(widgetPool, frame)
end

UpdateSingleWidgetData = function(frame, unit)
    if not UnitExists(unit) or UnitIsDead(unit) or not UnitCanAttack("player", unit) then
        frame:Hide() return
    end
    
    local currentDB = addonTable.GetDB()
    local status = UnitThreatSituation("player", unit) or 0
    local displayColor = activeTheme.colors.good
    local showGlowEffect = false

    -- SOLUÇÃO DEFINITIVA DO TAUNT (CLASSIC BYPASS):
    -- Varre debuffs usando pcall para isolar qualquer erro de API do Classic
    local isTaunted = false
    if type(UnitDebuff) == "function" then
        pcall(function()
            for i = 1, 40 do
                local name = UnitDebuff(unit, i)
                if name then
                    if string.find(name, "Taunt") or string.find(name, "Growl") or string.find(name, "Mocking") or string.find(name, "Provoke") or string.find(name, "Provocação") then
                        isTaunted = true
                        break
                    end
                end
            end
        end)
    end

    local isCurrentTarget = UnitIsUnit(unit, "target")
    local currentScale = currentDB.widgetScale or 1.0
    local targetScaleMultiplier = currentDB.targetScale or 1.35
    
    if isCurrentTarget and currentDB.highlightTarget then
        frame:SetScale(currentScale * targetScaleMultiplier)
        frame.text:SetFont(activeTheme.font, activeTheme.fontSize + 1, "THICKOUTLINE")
    else
        frame:SetScale(currentScale)
        frame.text:SetFont(activeTheme.font, activeTheme.fontSize, "OUTLINE")
    end

    local playerIsTank = IsPlayerTank()

    if isCurrentTarget then
        local _, _, threatPercent = UnitDetailedThreatSituation("player", "target")
        local displayPercent = tonumber(threatPercent) and math.floor(threatPercent) or 0
        frame.text:SetText(displayPercent .. "%")
        
        if isTaunted then
            displayColor = activeTheme.colors.taunt
            showGlowEffect = true
        elseif playerIsTank then
            if displayPercent >= 100 or status == 3 then displayColor = activeTheme.colors.good
            elseif displayPercent >= 75 then displayColor = activeTheme.colors.warn showGlowEffect = true
            else displayColor = activeTheme.colors.bad showGlowEffect = true end
        else
            if displayPercent >= 100 or status == 3 then displayColor = activeTheme.colors.bad showGlowEffect = true
            elseif displayPercent >= 75 then displayColor = activeTheme.colors.warn showGlowEffect = true
            else displayColor = activeTheme.colors.good end
        end
    else
        if UnitIsUnit(unit.."target", "player") or (UnitExists("pet") and UnitIsUnit(unit.."target", "pet")) then status = 3 end
        
        if isTaunted then
            frame.text:SetText(SafeGetText("STATUS_TAUNT"))
            displayColor = activeTheme.colors.taunt
            showGlowEffect = true
        elseif playerIsTank then
            if status == 3 then frame.text:SetText(SafeGetText("STATUS_OK")) displayColor = activeTheme.colors.good
            elseif status == 1 or status == 2 then frame.text:SetText(SafeGetText("STATUS_WARN")) displayColor = activeTheme.colors.warn showGlowEffect = true
            else frame.text:SetText(SafeGetText("STATUS_AGRO")) displayColor = activeTheme.colors.bad showGlowEffect = true end
        else
            if status == 3 then frame.text:SetText(SafeGetText("STATUS_AGRO")) displayColor = activeTheme.colors.bad showGlowEffect = true
            elseif status == 1 or status == 2 then frame.text:SetText(SafeGetText("STATUS_WARN")) displayColor = activeTheme.colors.warn showGlowEffect = true
            else frame.text:SetText(SafeGetText("STATUS_OK")) displayColor = activeTheme.colors.good end
        end
    end

    if status == 3 and currentDB.enableSound and not playerIsTank then
        local guid = UnitGUID(unit)
        local now = GetTime()
        if guid and (not soundCooldowns[guid] or (now - soundCooldowns[guid] > 6)) then
            soundCooldowns[guid] = now
            PlaySound(8174, "Master", true)
        end
    end

    frame.signal:SetVertexColor(unpack(displayColor))
    if showGlowEffect and currentDB.enableGlow then
        frame.glow:SetVertexColor(unpack(displayColor)) frame.glow:Show()
    else frame.glow:Hide() end
    if not frame:IsShown() then frame:Show() end
end

function TTP_RefreshAllNameplates()
    local currentDB = addonTable.GetDB()
    if currentDB.hideWhileSolo and not IsInGroup() and not IsInRaid() then
        if not (currentDB.showSoloWithPet and UnitExists("pet") and not UnitIsDead("pet")) then
            for unit, frame in pairs(activeWidgets) do RecycleSignalWidget(frame) activeWidgets[unit] = nil end
            return
        end
    end
    for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
        if not nameplate:IsForbidden() then
            local unit = nameplate.namePlateUnitToken or (nameplate.UnitFrame and nameplate.UnitFrame.unit)
            if unit and UnitExists(unit) and not UnitIsDead(unit) and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) then
                
                local skipMob = false
                if currentDB.filterTrivial then
                    local classification = UnitClassification(unit)
                    local name = UnitName(unit) or ""
                    if classification == "trivial" or string.find(name, "Totem") or string.find(name, "totem") then
                        skipMob = true
                    end
                end

                if not skipMob then
                    local frame = activeWidgets[unit] or CreateNewSignalWidget()
                    activeWidgets[unit] = frame
                    frame.unit = unit
                    frame:ClearAllPoints()
                    local anchor = nameplate.UnitFrame or nameplate
                    frame:SetPoint("LEFT", anchor, "RIGHT", currentDB.xOffset or 10, 0)
                    UpdateSingleWidgetData(frame, unit)
                else
                    if activeWidgets[unit] then RecycleSignalWidget(activeWidgets[unit]) activeWidgets[unit] = nil end
                end
            end
        end
    end
    for unit, frame in pairs(activeWidgets) do
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        if not nameplate or not UnitExists(unit) or UnitIsDead(unit) or not UnitAffectingCombat(unit) then
            RecycleSignalWidget(frame) activeWidgets[unit] = nil
        end
    end
end

local elapsedTimer, glowAlpha, glowExpanding = 0, 0, true
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")

eventFrame:SetScript("OnUpdate", function(_, elapsed)
    local currentDB = addonTable.GetDB()
    if not currentDB or not currentDB.updateThrottle then return end
    elapsedTimer = elapsedTimer + elapsed
    if InCombatLockdown() or next(activeWidgets) then TTP_RefreshAllNameplates() end
    
    if elapsedTimer >= currentDB.updateThrottle then
        elapsedTimer = 0
        TTP_RefreshAllNameplates()
    end

    if glowExpanding then glowAlpha = glowAlpha + (elapsed * 2.5) if glowAlpha >= 0.9 then glowExpanding = false end
    else glowAlpha = glowAlpha - (elapsed * 2.5) if glowAlpha <= 0.3 then glowExpanding = true end end
    for _, frame in pairs(activeWidgets) do if frame.glow:IsShown() then frame.glow:SetAlpha(glowAlpha) end end
end)

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        _G.ThreatBuddyForeverDB = _G.ThreatBuddyForeverDB or {}
        local db = _G.ThreatBuddyForeverDB
        db.x = db.x or 0 db.y = db.y or 0 db.point = db.point or "CENTER"
        db.widgetScale = db.widgetScale or 1.0 db.xOffset = db.xOffset or 10
        db.enableGlow = (db.enableGlow ~= false) db.hideWhileSolo = (db.hideWhileSolo == true)
        db.showSoloWithPet = (db.showSoloWithPet ~= false) db.updateThrottle = db.updateThrottle or 0.08
        db.enableSound = (db.enableSound == true) db.highlightTarget = (db.highlightTarget ~= false) db.filterTrivial = (db.filterTrivial ~= false)
        db.targetScale = db.targetScale or 1.35
        db.useCharProfile = (db.useCharProfile == true)
        
        local currentDB = addonTable.GetDB()
        for _, frame in pairs(activeWidgets) do frame:SetScale(currentDB.widgetScale or 1.0) end
    elseif event == "PLAYER_REGEN_ENABLED" then
        for unit, frame in pairs(activeWidgets) do RecycleSignalWidget(frame) activeWidgets[unit] = nil end
        wipe(soundCooldowns)
    elseif event == "UNIT_THREAT_LIST_UPDATE" and arg1 then
        local currentDB = addonTable.GetDB()
        if currentDB and currentDB.enableSound and InCombatLockdown() and not IsPlayerTank() then
            local status = UnitThreatSituation("player", arg1) or 0
            if status == 3 or UnitIsUnit(arg1.."target", "player") then
                local guid = UnitGUID(arg1)
                local now = GetTime()
                if guid and (not soundCooldowns[guid] or (now - soundCooldowns[guid] > 5)) then
                    soundCooldowns[guid] = now
                    PlaySound(8174, "Master", true)
                end
            end
        end
    end
end)

addonTable.activeWidgets = activeWidgets
