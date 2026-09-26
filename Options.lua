local ADDON_NAME, addonTable = ...
local GetText = addonTable.GetText
local SoundList = addonTable.SoundList or {}

local languages = {
    { label = "Default (Game)", value = nil },
    { label = "English", value = "enUS" },
    { label = "Português", value = "ptBR" },
    { label = "Español", value = "esES" },
    { label = "Italiano", value = "itIT" },
    { label = "Français", value = "frFR" },
    { label = "Deutsch", value = "deDE" },
    { label = "日本語", value = "jaJP" }
}

-- 1. PAINEL MESTRE
local optionsPanel = CreateFrame("Frame", "ThreatBuddyForeverOptionsPanel", UIParent)
optionsPanel.name = "ThreatBuddyForever"

local scrollFrame = CreateFrame("ScrollFrame", "TBFOptionsScrollFrame", optionsPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 8, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", -28, 10)

local scrollChild = CreateFrame("Frame", "TBFOptionsScrollChild", scrollFrame)
scrollChild:SetSize(600, 720) -- Expandido para dar espaço ao Logo
scrollFrame:SetScrollChild(scrollChild)

-- ===========================================================================
-- SUPORTE DESIGN V2.0: CRIAÇÃO DO LOGO GRÁFICO OFICIAL (FEITO EM CÓDIGO)
-- ===========================================================================
local logoContainer = CreateFrame("Frame", "TBFLogoContainer", scrollChild)
logoContainer:SetSize(300, 50)
logoContainer:SetPoint("TOPLEFT", 16, -16)

-- O Brasão de Fundo (Moldura de Joia Lendária do WoW)
logoContainer.bg = logoContainer:CreateTexture(nil, "BACKGROUND")
logoContainer.bg:SetSize(46, 46)
logoContainer.bg:SetPoint("LEFT", logoContainer, "LEFT", 0, 0)
logoContainer.bg:SetTexture("Interface\\COMMON\\Indicator-Green") -- O icónico semáforo ativo

-- O Brilho Místico do Logo V2.0
logoContainer.glow = logoContainer:CreateTexture(nil, "BORDER")
logoContainer.glow:SetSize(62, 62)
logoContainer.glow:SetPoint("CENTER", logoContainer.bg, "CENTER", 0, 0)
logoContainer.glow:SetTexture("Interface\\UNITPOWERBARALT\\ArtifactChipsBurst")
logoContainer.glow:SetVertexColor(0.0, 1.0, 0.0, 0.6) -- Néon Verde pulsante de segurança

-- Título Estilizado com Efeito de Sombra e Cor de Ouro Épico da Blizzard
local title = logoContainer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("LEFT", logoContainer.bg, "RIGHT", 12, 4)
title:SetTextColor(1.0, 0.82, 0.0) -- Blizzard Gold

local sub = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
sub:SetPoint("TOPLEFT", logoContainer.bg, "BOTTOMLEFT", 0, -12)

-- Animação discreta de pulso no brilho do Logo
local elapsedGlow = 0
logoContainer:SetScript("OnUpdate", function(_, elapsed)
    elapsedGlow = elapsedGlow + elapsed
    local alpha = 0.4 + math.sin(elapsedGlow * 3) * 0.2
    logoContainer.glow:SetAlpha(alpha)
end)

-- ===========================================================================
-- CONTROLOS DE CAIXAS DE SELECÇÃO (CHECKBOXES)
-- ===========================================================================
local glowCheck = CreateFrame("CheckButton", "TBFGlowCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
glowCheck:SetPoint("TOPLEFT", sub, "BOTTOMLEFT", 0, -20)

local soloCheck = CreateFrame("CheckButton", "TBFSoloCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
soloCheck:SetPoint("TOPLEFT", glowCheck, "BOTTOMLEFT", 0, -10)

local petCheck = CreateFrame("CheckButton", "TBFPetCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
petCheck:SetPoint("TOPLEFT", soloCheck, "BOTTOMLEFT", 20, -6)

local soundCheck = CreateFrame("CheckButton", "TBFSoundCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
soundCheck:SetPoint("TOPLEFT", petCheck, "BOTTOMLEFT", -20, -14)

local playButton = CreateFrame("Button", "TBFPlaySoundButton", scrollChild, "UIPanelButtonTemplate")
playButton:SetSize(60, 22)
playButton:SetPoint("LEFT", soundCheck, "LEFT", 260, 0)
playButton:SetText("Play")
playButton:SetScript("OnClick", function()
    PlaySound(8174, "Master", true)
end)

local highlightCheck = CreateFrame("CheckButton", "TBFHighlightCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
highlightCheck:SetPoint("TOPLEFT", soundCheck, "BOTTOMLEFT", 0, -14)

local filterCheck = CreateFrame("CheckButton", "TBFFilterCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
filterCheck:SetPoint("TOPLEFT", highlightCheck, "BOTTOMLEFT", 0, -10)

local charProfileCheck = CreateFrame("CheckButton", "TBFCharProfileCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
charProfileCheck:SetPoint("TOPLEFT", filterCheck, "BOTTOMLEFT", 0, -10)

local langLabel = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
langLabel:SetPoint("TOPLEFT", charProfileCheck, "BOTTOMLEFT", 0, -25)

local prevBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
prevBtn:SetSize(28, 22)
prevBtn:SetPoint("LEFT", langLabel, "RIGHT", 15, 0)
prevBtn:SetText("<")

local choiceBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
choiceBtn:SetSize(130, 22)
choiceBtn:SetPoint("LEFT", prevBtn, "RIGHT", 4, 0)

local nextBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
nextBtn:SetSize(28, 22)
nextBtn:SetPoint("LEFT", choiceBtn, "RIGHT", 4, 0)
nextBtn:SetText(">")

if prevBtn:GetFontString() then prevBtn:GetFontString():SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE") end
if nextBtn:GetFontString() then nextBtn:GetFontString():SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE") end
if playButton:GetFontString() then playButton:GetFontString():SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE") end

local scaleSlider
local targetScaleSlider
local offsetSlider
local lagSlider

local function RefreshPanelStrings()
    local currentDB = addonTable.GetText and addonTable.GetDB() or {}
    title:SetText("ThreatBuddyForever 2.0") -- Texto Fixo do Logo Estilizado
    sub:SetText(GetText("PANEL_SUB"))
    _G[glowCheck:GetName() .. "Text"]:SetText(GetText("TEXT_GLOW"))
    _G[soloCheck:GetName() .. "Text"]:SetText(GetText("TEXT_SOLO"))
    _G[petCheck:GetName() .. "Text"]:SetText(GetText("TEXT_PET"))
    _G[soundCheck:GetName() .. "Text"]:SetText(GetText("TEXT_SOUND"))
    _G[highlightCheck:GetName() .. "Text"]:SetText(GetText("TEXT_HIGHLIGHT"))
    _G[filterCheck:GetName() .. "Text"]:SetText(GetText("TEXT_FILTER"))
    _G[charProfileCheck:GetName() .. "Text"]:SetText(GetText("TEXT_CHARPROFILE"))
    langLabel:SetText(GetText("TEXT_LANG"))
    
    if ThreatBuddyForeverDB and currentDB.widgetScale then
        if scaleSlider then _G[scaleSlider:GetName() .. "Text"]:SetText(GetText("TEXT_SCALE") .. string.format("%.1f", currentDB.widgetScale)) end
        if targetScaleSlider then _G[targetScaleSlider:GetName() .. "Text"]:SetText(GetText("TEXT_TARSCALE") .. string.format("%.2fx", currentDB.targetScale or 1.35)) end
        if offsetSlider then _G[offsetSlider:GetName() .. "Text"]:SetText(GetText("TEXT_DIST") .. (currentDB.xOffset or 10) .. "px") end
        if lagSlider then _G[lagSlider:GetName() .. "Text"]:SetText(GetText("TEXT_LAG") .. string.format("%.2fs", currentDB.updateThrottle or 0.08)) end
    end
    
    local currentIdx = 1
    if ThreatBuddyForeverDB then
        for i, lang in ipairs(languages) do if ThreatBuddyForeverDB.forcedLocale == lang.value then currentIdx = i break end end
    end
    choiceBtn:SetText(languages[currentIdx].label)
end

local function CycleLanguage(direction)
    if not ThreatBuddyForeverDB then return end
    local currentIdx = 1
    for i, lang in ipairs(languages) do if ThreatBuddyForeverDB.forcedLocale == lang.value then currentIdx = i break end end
    local newIdx = currentIdx + direction
    if newIdx < 1 then newIdx = #languages end
    if newIdx > #languages then newIdx = 1 end
    ThreatBuddyForeverDB.forcedLocale = languages[newIdx].value
    RefreshPanelStrings()
end

glowCheck:SetScript("OnClick", function(self)
    addonTable.GetDB().enableGlow = self:GetChecked() == true
    if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end
end)

soloCheck:SetScript("OnClick", function(self)
    addonTable.GetDB().hideWhileSolo = self:GetChecked() == true
    if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end
end)

petCheck:SetScript("OnClick", function(self)
    addonTable.GetDB().showSoloWithPet = self:GetChecked() == true
    if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end
end)

soundCheck:SetScript("OnClick", function(self)
    addonTable.GetDB().enableSound = self:GetChecked() == true
end)

highlightCheck:SetScript("OnClick", function(self)
    addonTable.GetDB().highlightTarget = self:GetChecked() == true
end)

filterCheck:SetScript("OnClick", function(self)
    addonTable.GetDB().filterTrivial = self:GetChecked() == true
end)

charProfileCheck:SetScript("OnClick", function(self)
    if not ThreatBuddyForeverDB then return end
    ThreatBuddyForeverDB.useCharProfile = self:GetChecked() == true
    local currentDB = addonTable.GetDB()
    scaleSlider:SetValue(currentDB.widgetScale or 1.0)
    targetScaleSlider:SetValue(currentDB.targetScale or 1.35)
    offsetSlider:SetValue(currentDB.xOffset or 10)
    lagSlider:SetValue(currentDB.updateThrottle or 0.08)
    RefreshPanelStrings()
end)

prevBtn:SetScript("OnClick", function() CycleLanguage(-1) end)
nextBtn:SetScript("OnClick", function() CycleLanguage(1) end)
choiceBtn:SetScript("OnClick", function() CycleLanguage(1) end)

scaleSlider = CreateFrame("Slider", "TBFScaleSlider", scrollChild, "OptionsSliderTemplate")
scaleSlider:SetPoint("TOPLEFT", langLabel, "BOTTOMLEFT", 0, -45)
scaleSlider:SetWidth(200)
scaleSlider:SetMinMaxValues(0.5, 2.0)
scaleSlider:SetValueStep(0.1)
scaleSlider:SetObeyStepOnDrag(true)
_G[scaleSlider:GetName() .. "Low"]:SetText("0.5")
_G[scaleSlider:GetName() .. "High"]:SetText("2.0")
_G[scaleSlider:GetName() .. "Text"]:ClearAllPoints()
_G[scaleSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", scaleSlider, "TOPLEFT", 0, 6)

scaleSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 10) + 0.5) / 10
    addonTable.GetDB().widgetScale = rounded
    _G[self:GetName() .. "Text"]:SetText(GetText("TEXT_SCALE") .. string.format("%.1f", rounded))
    if addonTable.activeWidgets then
        for _, frame in pairs(addonTable.activeWidgets) do if frame.SetScale then frame:SetScale(rounded) end end
    end
end)

targetScaleSlider = CreateFrame("Slider", "TBFTargetScaleSlider", scrollChild, "OptionsSliderTemplate")
targetScaleSlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -65)
targetScaleSlider:SetWidth(200)
targetScaleSlider:SetMinMaxValues(1.0, 2.5)
targetScaleSlider:SetValueStep(0.05)
targetScaleSlider:SetObeyStepOnDrag(true)
_G[targetScaleSlider:GetName() .. "Low"]:SetText("1.0x")
_G[targetScaleSlider:GetName() .. "High"]:SetText("2.5x")
_G[targetScaleSlider:GetName() .. "Text"]:ClearAllPoints()
_G[targetScaleSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", targetScaleSlider, "TOPLEFT", 0, 6)

targetScaleSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 100) + 0.5) / 100
    addonTable.GetDB().targetScale = rounded
    _G[self:GetName() .. "Text"]:SetText(GetText("TEXT_TARSCALE") .. string.format("%.2fx", rounded))
end)

offsetSlider = CreateFrame("Slider", "TBFOffsetSlider", scrollChild, "OptionsSliderTemplate")
offsetSlider:SetPoint("TOPLEFT", targetScaleSlider, "BOTTOMLEFT", 0, -65)
offsetSlider:SetWidth(200)
offsetSlider:SetMinMaxValues(-20, 50)
offsetSlider:SetValueStep(2)
offsetSlider:SetObeyStepOnDrag(true)
_G[offsetSlider:GetName() .. "Low"]:SetText("-20")
_G[offsetSlider:GetName() .. "High"]:SetText("50")
_G[offsetSlider:GetName() .. "Text"]:ClearAllPoints()
_G[offsetSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", offsetSlider, "TOPLEFT", 0, 6)

offsetSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor(value)
    addonTable.GetDB().xOffset = rounded
    _G[self:GetName() .. "Text"]:SetText(GetText("TEXT_DIST") .. rounded .. "px")
    if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end
end)

lagSlider = CreateFrame("Slider", "TBFLagSlider", scrollChild, "OptionsSliderTemplate")
lagSlider:SetPoint("TOPLEFT", offsetSlider, "BOTTOMLEFT", 0, -65)
lagSlider:SetWidth(200)
lagSlider:SetMinMaxValues(0.02, 0.30)
lagSlider:SetValueStep(0.02)
lagSlider:SetObeyStepOnDrag(true)
_G[lagSlider:GetName() .. "Low"]:SetText("0.02s")
_G[lagSlider:GetName() .. "High"]:SetText("0.30s")
_G[lagSlider:GetName() .. "Text"]:ClearAllPoints()
_G[lagFrame or lagSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", lagSlider, "TOPLEFT", 0, 6)

lagSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 100) + 0.5) / 100
    addonTable.GetDB().updateThrottle = rounded
    _G[self:GetName() .. "Text"]:SetText(GetText("TEXT_LAG") .. string.format("%.2fs", rounded))
end)

local savedCategory
if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
    local category = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name)
    Settings.RegisterAddOnCategory(category)
    savedCategory = category
elseif InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(optionsPanel)
end

local syncFrame = CreateFrame("Frame")
syncFrame:RegisterEvent("ADDON_LOADED")
syncFrame:RegisterEvent("PLAYER_LOGIN")
syncFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        _G.ThreatBuddyForeverDB = _G.ThreatBuddyForeverDB or {}
        local db = _G.ThreatBuddyForeverDB
        local currentDB = addonTable.GetDB()
        
        glowCheck:SetChecked(currentDB.enableGlow) 
        soloCheck:SetChecked(currentDB.hideWhileSolo) 
        petCheck:SetChecked(currentDB.showSoloWithPet)
        soundCheck:SetChecked(currentDB.enableSound)
        highlightCheck:SetChecked(currentDB.highlightTarget)
        filterCheck:SetChecked(currentDB.filterTrivial)
        charProfileCheck:SetChecked(db.useCharProfile)
        
        scaleSlider:SetValue(currentDB.widgetScale or 1.0) 
        targetScaleSlider:SetValue(currentDB.targetScale or 1.35)
        offsetSlider:SetValue(currentDB.xOffset or 10) 
        lagSlider:SetValue(currentDB.updateThrottle or 0.08) 
        
        RefreshPanelStrings()
    elseif event == "PLAYER_LOGIN" then
        print(GetText("LOADED"))
    end
end)

local testFrame
SLASH_THREATBUDDYFOREVER1 = "/tbf"
SlashCmdList.THREATBUDDYFOREVER = function(msg)
    local cmd, arg = string.split(" ", msg or "")
    cmd = string.lower(cmd or "")
    local currentDB = addonTable.GetDB()
    
    if cmd == "scale" and arg then
        local num = tonumber(arg)
        if num and num >= 0.5 and num <= 2.5 then 
            currentDB.widgetScale = num scaleSlider:SetValue(num) print(GetText("SCALE_CHANGED") .. num) 
        else print(GetText("SCALE_ERROR")) end
    elseif cmd == "test" then
        if testFrame and testFrame:IsShown() then testFrame:Hide() print(GetText("TEST_OFF"))
        else
            if not testFrame then
                testFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate") testFrame:SetSize(44, 44)
                testFrame.signal = testFrame:CreateTexture(nil, "ARTWORK") testFrame.signal:SetSize(44, 44) testFrame.signal:SetPoint("CENTER")
                testFrame.signal:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask") testFrame.signal:SetVertexColor(0.5, 0.5, 0.5, 0.8)
                testFrame.text = testFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge") testFrame.text:SetPoint("CENTER")
                testFrame.text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE") testFrame.text:SetText("50%")
            end
            testFrame:ClearAllPoints() testFrame:SetPoint(currentDB.point or "CENTER", UIParent, currentDB.point or "CENTER", currentDB.x or 0, currentDB.y or 100)
            testFrame:SetScale(currentDB.widgetScale or 1.0) testFrame:Show() print(GetText("TEST_ON"))
        end
    elseif cmd == "reset" then
        currentDB.point, currentDB.x, currentDB.y = "CENTER", 0, 0
        if testFrame then testFrame:ClearAllPoints() testFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100) end
        print(GetText("RESET_POS"))
    else
        if Settings and Settings.OpenToCategory and savedCategory then
            Settings.OpenToCategory(savedCategory:GetID())
        elseif InterfaceOptionsFrame_OpenToCategory then
            InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        end
    end
end
