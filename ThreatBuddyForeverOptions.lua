local ADDON_NAME, addonTable = ...
local SafeGetText = addonTable.SafeGetText

-- Localization lookup caching node
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

-- 1. WINDOW PANEL CANVAS FRAME STORAGE REGISTRATION
local optionsPanel = CreateFrame("Frame", "ThreatBuddyForeverOptionsPanel", UIParent)
optionsPanel.name = "ThreatBuddyForever"

-- 2. BLIZZARD-STYLE CANVAS SCROLL CONTAINER
local scrollFrame = CreateFrame("ScrollFrame", "TBFOptionsScrollFrame", optionsPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 8, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", -28, 10)

local scrollChild = CreateFrame("Frame", "TBFOptionsScrollChild", scrollFrame)
scrollChild:SetSize(600, 750)
scrollFrame:SetScrollChild(scrollChild)
-- ===========================================================================
-- ANIMATED HEADER COMPOSITOR SECTION
-- ===========================================================================
local logoContainer = CreateFrame("Frame", "TBFLogoContainer", scrollChild)
logoContainer:SetSize(300, 50)
logoContainer:SetPoint("TOPLEFT", 16, -16)

logoContainer.bg = logoContainer:CreateTexture(nil, "BACKGROUND")
logoContainer.bg:SetSize(46, 46)
logoContainer.bg:SetPoint("LEFT", logoContainer, "LEFT", 0, 0)
logoContainer.bg:SetTexture("Interface\\COMMON\\Indicator-Green")

logoContainer.glow = logoContainer:CreateTexture(nil, "BORDER")
logoContainer.glow:SetSize(62, 62)
logoContainer.glow:SetPoint("CENTER", logoContainer.bg, "CENTER", 0, 0)
logoContainer.glow:SetTexture("Interface\\UNITPOWERBARALT\\ArtifactChipsBurst")
logoContainer.glow:SetVertexColor(0.0, 1.0, 0.0, 0.6)

local title = logoContainer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("LEFT", logoContainer.bg, "RIGHT", 12, 4)
title:SetTextColor(1.0, 0.82, 0.0)

local sub = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
sub:SetPoint("TOPLEFT", logoContainer.bg, "BOTTOMLEFT", 0, -12)

local elapsedGlow = 0
logoContainer:SetScript("OnUpdate", function(_, elapsed)
    elapsedGlow = elapsedGlow + elapsed
    logoContainer.glow:SetAlpha(0.4 + math.sin(elapsedGlow * 3) * 0.2)
end)

-- ===========================================================================
-- CHECKBOX SELECTION HOOK INTERFACES
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
playButton:SetSize(60, 22) playButton:SetPoint("LEFT", soundCheck, "LEFT", 260, 0)
playButton:SetText("Play") playButton:SetScript("OnClick", function() PlaySound(8174, "Master", true) end)

local highlightCheck = CreateFrame("CheckButton", "TBFHighlightCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
highlightCheck:SetPoint("TOPLEFT", soundCheck, "BOTTOMLEFT", 0, -10)

local filterCheck = CreateFrame("CheckButton", "TBFFilterCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
filterCheck:SetPoint("TOPLEFT", highlightCheck, "BOTTOMLEFT", 0, -10)

local charProfileCheck = CreateFrame("CheckButton", "TBFCharProfileCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
charProfileCheck:SetPoint("TOPLEFT", filterCheck, "BOTTOMLEFT", 0, -10)
-- ===========================================================================
-- CUSTOM ICON TEXT ENTRY CONTROLLER & NATIVE ICON PICKER (BROWSE DIALOG)
-- ===========================================================================
local customIconLabel = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
customIconLabel:SetPoint("TOPLEFT", charProfileCheck, "BOTTOMLEFT", 0, -20)
customIconLabel:SetText("") -- Safely filled at runtime by RefreshPanelStrings

local iconEditBox = CreateFrame("EditBox", "TBFCustomIconEditBox", scrollChild, "InputBoxTemplate")
iconEditBox:SetSize(210, 24)
iconEditBox:SetPoint("TOPLEFT", customIconLabel, "BOTTOMLEFT", 0, -6)
iconEditBox:SetAutoFocus(false)

if iconEditBox.SetClearButtonEnabled then
    iconEditBox:SetClearButtonEnabled(true)
end

local browseIconsBtn = CreateFrame("Button", "TBFBrowseIconsButton", scrollChild, "UIPanelButtonTemplate")
browseIconsBtn:SetHeight(24)
browseIconsBtn:SetPoint("LEFT", iconEditBox, "RIGHT", 8, 0)
browseIconsBtn:SetText("") -- Safely filled at runtime by RefreshPanelStrings
browseIconsBtn.fitTextWidthPadding = 12

-- BUILD AN INDEPENDENT TBF ICON SELECTION POPUP PANEL FRAME
local TBF_IconPickerFrame = CreateFrame("Frame", "TBFCustomIconPickerFrame", UIParent, "BackdropTemplate")
TBF_IconPickerFrame:SetSize(275, 300)
TBF_IconPickerFrame:SetPoint("LEFT", optionsPanel, "RIGHT", 25, 0)
TBF_IconPickerFrame:SetFrameStrata("DIALOG")
TBF_IconPickerFrame:Hide()

TBF_IconPickerFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
TBF_IconPickerFrame:SetBackdropBorderColor(0.60, 0.50, 0.40, 1)

local pickerTitle = TBF_IconPickerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
pickerTitle:SetPoint("TOPLEFT", 18, -14)
pickerTitle:SetText("") -- Safely filled at runtime by RefreshPanelStrings

local globalMacroIcons = {
    132333, 134153, 132212, 132147, 132155, 135800, 135964, 136012, 136085, 136116,
    136122, 136200, 134951, 132111, 132161, 132115, 135911, 135940, 135959, 135988,
    136025, 136041, 136052, 136066, 136074, 136096, 136104, 136137, 136148, 136176,
    136184, 136189, 136210, 136222, 132204, 132218, 132240, 132255, 132276, 132292,
    132305, 132316, 132331, 132341, 132363, 132381, 132393, 132410, 132435, 132444,
    132060, 132085, 132010, 132117, 132130, 132144, 132170, 132185, 132199, 132222,
    132235, 132250, 132269, 132288, 132311, 132328, 132350, 132369, 132389, 132405,
    132422, 132450, 132465, 132480, 132495, 132510, 132525, 132540, 132555, 132570
}

local currentPage = 1
local iconsPerPage = 20 
local maxPages = math.ceil(#globalMacroIcons / iconsPerPage)

local pageText = TBF_IconPickerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
pageText:SetPoint("BOTTOM", TBF_IconPickerFrame, "BOTTOM", 0, 52)

local gridButtons = {}
local function UpdatePickerGridDisplay()
    pageText:SetText(string.format("Page %d / %d", currentPage, maxPages))
    local startOffset = (currentPage - 1) * iconsPerPage
    
    for gridIndex = 1, iconsPerPage do
        local targetAssetIndex = startOffset + gridIndex
        local btn = gridButtons[gridIndex]
        local iconTextureSource = globalMacroIcons[targetAssetIndex]
        
        if iconTextureSource then
            btn.texture:SetTexture(iconTextureSource)
            btn.savedIconTextureValue = iconTextureSource
            btn:Show()
        else
            btn:Hide()
        end
    end
end

local iconsPerRow = 5
local buttonSize = 38
local spacing = 10

for idx = 1, iconsPerPage do
    local btn = CreateFrame("Button", nil, TBF_IconPickerFrame)
    btn:SetSize(buttonSize, buttonSize)
    btn:SetPoint("TOPLEFT", 21 + (((idx - 1) % iconsPerRow) * (buttonSize + spacing)), -42 - (math.floor((idx - 1) / iconsPerRow) * (buttonSize + spacing)))
    
    local tex = btn:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints()
    tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    btn.texture = tex

    local high = btn:CreateTexture(nil, "HIGHLIGHT")
    high:SetAllPoints()
    high:SetTexture("Interface\\Buttons\\CheckButtonHilight")
    high:SetBlendMode("ADD")

    btn:SetScript("OnClick", function(self)
        if self.savedIconTextureValue then
            local selection = self.savedIconTextureValue
            addonTable.GetDB().customIconPath = selection
            
            -- FIX: Setting the userInput flag parameter to true kicks off real-time updates instantly!
            iconEditBox:SetText(tostring(selection), true)
            
            if addonTable.RebuildWidgetTextures then addonTable.RebuildWidgetTextures() end
            if TTP_RefreshAllNameplates then TTP_RefreshAllNameplates() end
            if testFrame and addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
            
            TBF_IconPickerFrame:Hide()
        end
    end)
    gridButtons[idx] = btn
end

local prevPageBtn = CreateFrame("Button", nil, TBF_IconPickerFrame, "UIPanelButtonTemplate")
prevPageBtn:SetSize(36, 22) prevPageBtn:SetPoint("BOTTOMLEFT", 18, 44) prevPageBtn:SetText("<")
prevPageBtn:SetScript("OnClick", function() if currentPage > 1 then currentPage = currentPage - 1 UpdatePickerGridDisplay() end end)

local nextPageBtn = CreateFrame("Button", nil, TBF_IconPickerFrame, "UIPanelButtonTemplate")
nextPageBtn:SetSize(36, 22) nextPageBtn:SetPoint("BOTTOMRIGHT", -18, 44) nextPageBtn:SetText(">")
nextPageBtn:SetScript("OnClick", function() if currentPage < maxPages then currentPage = currentPage + 1 UpdatePickerGridDisplay() end end)

local resetDefaultBtn = CreateFrame("Button", nil, TBF_IconPickerFrame, "UIPanelButtonTemplate")
local cutEdgesCheck = CreateFrame("CheckButton", "TBFCutIconEdgesCheckButton", scrollChild, "InterfaceOptionsCheckButtonTemplate")
cutEdgesCheck:SetPoint("TOPLEFT", iconEditBox, "BOTTOMLEFT", 0, -10)
resetDefaultBtn:SetHeight(22) 
resetDefaultBtn:SetPoint("BOTTOM", TBF_IconPickerFrame, "BOTTOM", 0, 14)
resetDefaultBtn:SetText("") -- Safely filled at runtime by RefreshPanelStrings
resetDefaultBtn.fitTextWidthPadding = 16
if resetDefaultBtn:GetFontString() then resetDefaultBtn:GetFontString():SetFont(STANDARD_TEXT_FONT, 10) end

resetDefaultBtn:SetScript("OnClick", function()
    addonTable.GetDB().customIconPath = nil
    iconEditBox:SetText("")
    if addonTable.RebuildWidgetTextures then addonTable.RebuildWidgetTextures() end
    if TTP_RefreshAllNameplates then TTP_RefreshAllNameplates() end
    if testFrame and addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
    TBF_IconPickerFrame:Hide()
end)

browseIconsBtn:SetScript("OnClick", function() if TBF_IconPickerFrame:IsShown() then TBF_IconPickerFrame:Hide() else currentPage = 1 UpdatePickerGridDisplay() TBF_IconPickerFrame:Show() end end)

local langLabel = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
langLabel:SetPoint("TOPLEFT", cutEdgesCheck, "BOTTOMLEFT", 0, -25)

local prevBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
prevBtn:SetSize(28, 22) prevBtn:SetPoint("LEFT", langLabel, "RIGHT", 15, 0) prevBtn:SetText("<")

local choiceBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
choiceBtn:SetSize(130, 22) choiceBtn:SetPoint("LEFT", prevBtn, "RIGHT", 4, 0)

local nextBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
nextBtn:SetSize(28, 22) nextBtn:SetPoint("LEFT", choiceBtn, "RIGHT", 4, 0) nextBtn:SetText(">")
-- ===========================================================================
-- SLIDER TRACK MATRIX HOUSING
-- ===========================================================================
local scaleSlider = CreateFrame("Slider", "TBFScaleSlider", scrollChild, "OptionsSliderTemplate")
local targetScaleSlider = CreateFrame("Slider", "TBFTargetScaleSlider", scrollChild, "OptionsSliderTemplate")
local offsetSlider = CreateFrame("Slider", "TBFOffsetSlider", scrollChild, "OptionsSliderTemplate")
local lagSlider = CreateFrame("Slider", "TBFLagSlider", scrollChild, "OptionsSliderTemplate")
local alphaSlider = CreateFrame("Slider", "TBFAlphaSlider", scrollChild, "OptionsSliderTemplate")
-- NEW SLIDER: Controls icon texture opacity independently from the text parameters
local colorAlphaSlider = CreateFrame("Slider", "TBFColorAlphaSlider", scrollChild, "OptionsSliderTemplate")

scaleSlider:SetPoint("TOPLEFT", langLabel, "BOTTOMLEFT", 0, -45)
scaleSlider:SetWidth(200) scaleSlider:SetMinMaxValues(0.5, 2.0) scaleSlider:SetValueStep(0.1) scaleSlider:SetObeyStepOnDrag(true)
_G[scaleSlider:GetName() .. "Low"]:SetText("0.5") _G[scaleSlider:GetName() .. "High"]:SetText("2.0")
_G[scaleSlider:GetName() .. "Text"]:ClearAllPoints() _G[scaleSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", scaleSlider, "TOPLEFT", 0, 6)

targetScaleSlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -55)
targetScaleSlider:SetWidth(200) targetScaleSlider:SetMinMaxValues(1.0, 2.5) targetScaleSlider:SetValueStep(0.05) targetScaleSlider:SetObeyStepOnDrag(true)
_G[targetScaleSlider:GetName() .. "Low"]:SetText("1.0x") _G[targetScaleSlider:GetName() .. "High"]:SetText("2.5x")
_G[targetScaleSlider:GetName() .. "Text"]:ClearAllPoints() _G[targetScaleSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", targetScaleSlider, "TOPLEFT", 0, 6)

offsetSlider:SetPoint("TOPLEFT", targetScaleSlider, "BOTTOMLEFT", 0, -55)
offsetSlider:SetWidth(200) offsetSlider:SetMinMaxValues(-20, 50) offsetSlider:SetValueStep(2) offsetSlider:SetObeyStepOnDrag(true)
_G[offsetSlider:GetName() .. "Low"]:SetText("-20") _G[offsetSlider:GetName() .. "High"]:SetText("50")
_G[offsetSlider:GetName() .. "Text"]:ClearAllPoints() _G[offsetSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", offsetSlider, "TOPLEFT", 0, 6)

lagSlider:SetPoint("TOPLEFT", offsetSlider, "BOTTOMLEFT", 0, -55)
lagSlider:SetWidth(200) lagSlider:SetMinMaxValues(0.02, 0.30) lagSlider:SetValueStep(0.02) lagSlider:SetObeyStepOnDrag(true)
_G[lagSlider:GetName() .. "Low"]:SetText("0.02s") _G[lagSlider:GetName() .. "High"]:SetText("0.30s")
_G[lagSlider:GetName() .. "Text"]:ClearAllPoints() _G[lagSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", lagSlider, "TOPLEFT", 0, 6)

alphaSlider:SetPoint("TOPLEFT", lagSlider, "BOTTOMLEFT", 0, -55)
alphaSlider:SetWidth(200) alphaSlider:SetMinMaxValues(0.10, 1.00) alphaSlider:SetValueStep(0.05) alphaSlider:SetObeyStepOnDrag(true)
_G[alphaSlider:GetName() .. "Low"]:SetText("10%") _G[alphaSlider:GetName() .. "High"]:SetText("100%")
_G[alphaSlider:GetName() .. "Text"]:ClearAllPoints() _G[alphaSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", alphaSlider, "TOPLEFT", 0, 6)

-- NEW SLIDER ANCHORS MAPPING: Places the icon color alpha layout under the master alpha control
colorAlphaSlider:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", 0, -55)
colorAlphaSlider:SetWidth(200) colorAlphaSlider:SetMinMaxValues(0.00, 1.00) colorAlphaSlider:SetValueStep(0.05) colorAlphaSlider:SetObeyStepOnDrag(true)
_G[colorAlphaSlider:GetName() .. "Low"]:SetText("0%") _G[colorAlphaSlider:GetName() .. "High"]:SetText("100%")
_G[colorAlphaSlider:GetName() .. "Text"]:ClearAllPoints() _G[colorAlphaSlider:GetName() .. "Text"]:SetPoint("BOTTOMLEFT", colorAlphaSlider, "TOPLEFT", 0, 6)

-- ===========================================================================
-- GLOBAL FALLBACK REGISTRATION & STRING REFRESH PIPELINE
-- ===========================================================================
function addonTable.GetFallbackText(key)
    if addonTable.SafeGetText then 
        local localizedText = addonTable.SafeGetText(key)
        if localizedText and localizedText ~= key then return localizedText end
    end
    
    local fallbacks = {
        PANEL_SUB = "Threat Configuration Profile Panel Manager.",
        TEXT_GLOW = "Enable Neon Glow Visual Effects",
        TEXT_SOLO = "Hide While Solo (Ignore nameplates when out of groups)",
        TEXT_PET  = "Keep Enabled if Pet is Actively Engaged",
        TEXT_SOUND = "Play Audio Alarm Alerts on Aggro Losses",
        TEXT_HIGHLIGHT = "Scale Target Widget Focus Highlighting",
        TEXT_FILTER = "Filter out Trivial Mobs & Background Totems",
        TEXT_CHARPROFILE = "Use Separate Character Profiles (Ignore Global Settings)",
        TEXT_LANG = "Language Localization Pack Profile:",
        TEXT_SCALE = "Master Widget Size Scale: ",
        TEXT_TARSCALE = "Focus Target Highlights Scaling: ",
        TEXT_DIST = "Nameplate Horizontal Pixel Spacing Offset: ",
        TEXT_LAG = "Nameplate Interface Scanner Throttle Ticks: ",
        TEXT_ALPHA = "Threat Indicator Opacity: ",
        TEXT_ICON_LABEL = "Custom Icon Name or Asset ID:",
        TEXT_BROWSE_BTN = "Browse...",
        TEXT_RESET_BTN  = "Reset Default",
        TEXT_CUT_EDGES = "Clip Icon Corners (Smooth Rounded Edges)",
        TEXT_COLOR_ALPHA = "Icon Texture Color Opacity: "
    }
    return fallbacks[key] or key
end

local function RefreshPanelStrings()
    local currentDB = addonTable.GetDB and addonTable.GetDB() or {}
    local GetText = addonTable.GetFallbackText
    
    if not GetText then return end
    
    title:SetText("ThreatBuddyForever 2.0") sub:SetText(GetText("PANEL_SUB"))
    _G[glowCheck:GetName() .. "Text"]:SetText(GetText("TEXT_GLOW")) _G[soloCheck:GetName() .. "Text"]:SetText(GetText("TEXT_SOLO"))
    _G[petCheck:GetName() .. "Text"]:SetText(GetText("TEXT_PET")) _G[soundCheck:GetName() .. "Text"]:SetText(GetText("TEXT_SOUND"))
    _G[highlightCheck:GetName() .. "Text"]:SetText(GetText("TEXT_HIGHLIGHT")) _G[filterCheck:GetName() .. "Text"]:SetText(GetText("TEXT_FILTER"))
    _G[charProfileCheck:GetName() .. "Text"]:SetText(GetText("TEXT_CHARPROFILE")) langLabel:SetText(GetText("TEXT_LANG"))
    _G[cutEdgesCheck:GetName() .. "Text"]:SetText(GetText("TEXT_CUT_EDGES"))
    
    customIconLabel:SetText(GetText("TEXT_ICON_LABEL"))
    if pickerTitle then pickerTitle:SetText(GetText("TEXT_ICON_LABEL")) end
    
    -- AUTO-FIT WIDTH COMPU-MATRIX: Automatically updates button sizes dynamically
    browseIconsBtn:SetText(GetText("TEXT_BROWSE_BTN"))
    local browseTextWidth = browseIconsBtn:GetTextWidth() or 60
    browseIconsBtn:SetWidth(math.max(75, browseTextWidth + 20))
    
    resetDefaultBtn:SetText(GetText("TEXT_RESET_BTN"))
    local resetTextWidth = resetDefaultBtn:GetTextWidth() or 90
    resetDefaultBtn:SetWidth(math.max(120, resetTextWidth + 24))
    
    if ThreatBuddyForeverDB and currentDB.widgetScale then
        _G[scaleSlider:GetName() .. "Text"]:SetText(GetText("TEXT_SCALE") .. string.format("%.1f", currentDB.widgetScale))
        _G[targetScaleSlider:GetName() .. "Text"]:SetText(GetText("TEXT_TARSCALE") .. string.format("%.2fx", currentDB.targetScale or 1.35))
        _G[offsetSlider:GetName() .. "Text"]:SetText(GetText("TEXT_DIST") .. (currentDB.xOffset or 10) .. "px")
        _G[lagSlider:GetName() .. "Text"]:SetText(GetText("TEXT_LAG") .. string.format("%.2fs", currentDB.updateThrottle or 0.08))
        _G[alphaSlider:GetName() .. "Text"]:SetText(GetText("TEXT_ALPHA") .. string.format("%d%%", math.floor((currentDB.widgetAlpha or 1.0) * 100)))
        _G[colorAlphaSlider:GetName() .. "Text"]:SetText(GetText("TEXT_COLOR_ALPHA") .. string.format("%d%%", math.floor((currentDB.colorAlpha or 1.0) * 100)))

    end
    local currentIdx = 1
    if ThreatBuddyForeverDB then for i = 1, #languages do if ThreatBuddyForeverDB.forcedLocale == languages[i].value then currentIdx = i break end end end
    choiceBtn:SetText(languages[currentIdx].label)
end

local function CycleLanguage(direction)
    if not ThreatBuddyForeverDB then return end local currentIdx = 1
    for i = 1, #languages do if ThreatBuddyForeverDB.forcedLocale == languages[i].value then currentIdx = i break end end
    local newIdx = currentIdx + direction if newIdx < 1 then newIdx = #languages end if newIdx > #languages then newIdx = 1 end
    ThreatBuddyForeverDB.forcedLocale = languages[newIdx].value RefreshPanelStrings()
end
-- ===========================================================================
-- FORM SLIDER EVENT ASSIGNERS & INSTANT KEYSTROKE TEXT HANDLERS
-- ===========================================================================
glowCheck:SetScript("OnClick", function(self) addonTable.GetDB().enableGlow = self:GetChecked() == true; if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end end)
soloCheck:SetScript("OnClick", function(self) addonTable.GetDB().hideWhileSolo = self:GetChecked() == true; if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end end)
petCheck:SetScript("OnClick", function(self) addonTable.GetDB().showSoloWithPet = self:GetChecked() == true; if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end end)
soundCheck:SetScript("OnClick", function(self) addonTable.GetDB().enableSound = self:GetChecked() == true end)
highlightCheck:SetScript("OnClick", function(self) addonTable.GetDB().highlightTarget = self:GetChecked() == true end)
filterCheck:SetScript("OnClick", function(self) addonTable.GetDB().filterTrivial = self:GetChecked() == true end)
charProfileCheck:SetScript("OnClick", function(self)
    if not ThreatBuddyForeverDB then return end ThreatBuddyForeverDB.useCharProfile = self:GetChecked() == true
    local currentDB = addonTable.GetDB() scaleSlider:SetValue(currentDB.widgetScale or 1.0)
    local targetScaleMultiplier = currentDB.targetScale or 1.35 targetScaleSlider:SetValue(targetScaleMultiplier)
    offsetSlider:SetValue(currentDB.xOffset or 10) lagSlider:SetValue(currentDB.updateThrottle or 0.08)
    alphaSlider:SetValue(currentDB.widgetAlpha or 1.0) RefreshPanelStrings()
end)

-- FIXED: Key-by-key text box processing update engine triggers
iconEditBox:SetScript("OnTextChanged", function(self, userInput)
    if not userInput then return end -- Shield execution from systemic data cycles loops
    local path = self:GetText():gsub("^%s*(.-)%s*$", "%1")
    addonTable.GetDB().customIconPath = (path ~= "") and path or nil
    
    if addonTable.RebuildWidgetTextures then addonTable.RebuildWidgetTextures() end
    if TTP_RefreshAllNameplates then TTP_RefreshAllNameplates() end
    if testFrame and addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
end)

iconEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus() -- Keep as focus dropout trigger shortcut
end)

iconEditBox:SetScript("OnEditFocusLost", function(self)
    local path = self:GetText():gsub("^%s*(.-)%s*$", "%1")
    addonTable.GetDB().customIconPath = (path ~= "") and path or nil
    if addonTable.RebuildWidgetTextures then addonTable.RebuildWidgetTextures() end
end)

prevBtn:SetScript("OnClick", function() CycleLanguage(-1) end) nextBtn:SetScript("OnClick", function() CycleLanguage(1) end) choiceBtn:SetScript("OnClick", function() CycleLanguage(1) end)

scaleSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 10) + 0.5) / 10 addonTable.GetDB().widgetScale = rounded
    _G[self:GetName() .. "Text"]:SetText(addonTable.GetFallbackText("TEXT_SCALE") .. string.format("%.1f", rounded))
    if addonTable.activeWidgets then for _, frame in pairs(addonTable.activeWidgets) do if frame.SetScale then frame:SetScale(rounded) end end end
    if testFrame and testFrame.SetScale then testFrame:SetScale(rounded) end
end)
targetScaleSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 100) + 0.5) / 100 addonTable.GetDB().targetScale = rounded
    _G[self:GetName() .. "Text"]:SetText(addonTable.GetFallbackText("TEXT_TARSCALE") .. string.format("%.2fx", rounded))
end)
offsetSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor(value) addonTable.GetDB().xOffset = rounded
    _G[self:GetName() .. "Text"]:SetText(addonTable.GetFallbackText("TEXT_DIST") .. rounded .. "px")
    if type(TTP_RefreshAllNameplates) == "function" then TTP_RefreshAllNameplates() end
end)
lagSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 100) + 0.5) / 100 addonTable.GetDB().updateThrottle = rounded
    _G[self:GetName() .. "Text"]:SetText(addonTable.GetFallbackText("TEXT_LAG") .. string.format("%.2fs", rounded))
end)
alphaSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 100) + 0.5) / 100 addonTable.GetDB().widgetAlpha = rounded
    _G[self:GetName() .. "Text"]:SetText(addonTable.GetFallbackText("TEXT_ALPHA") .. string.format("%d%%", math.floor(rounded * 100)))
    if TTP_RefreshAllNameplates then TTP_RefreshAllNameplates() end
    if testFrame and addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
end)
colorAlphaSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor((value * 100) + 0.5) / 100 
    addonTable.GetDB().colorAlpha = rounded
    _G[self:GetName() .. "Text"]:SetText(addonTable.GetFallbackText("TEXT_COLOR_ALPHA") .. string.format("%d%%", math.floor(rounded * 100)))
    if TTP_RefreshAllNameplates then TTP_RefreshAllNameplates() end
    if testFrame and addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
end)
cutEdgesCheck:SetScript("OnClick", function(self)
    local isChecked = (self:GetChecked() == true)
    addonTable.GetDB().cutIconEdges = isChecked
    
    -- Force the active textures engine to apply or strip the mask immediately
    if addonTable.RebuildWidgetTextures then addonTable.RebuildWidgetTextures() end
    if TTP_RefreshAllNameplates then TTP_RefreshAllNameplates() end
    if testFrame and addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
end)
    addonTable.settingsCategoryObject = nil

local function RegisterAddonSettingsCategory()
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local category = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name)
        Settings.RegisterAddOnCategory(category)
        addonTable.settingsCategoryObject = category
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(optionsPanel)
    end
end

local syncFrame = CreateFrame("Frame")
syncFrame:RegisterEvent("ADDON_LOADED") syncFrame:RegisterEvent("PLAYER_LOGIN")
syncFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        _G.ThreatBuddyForeverDB = _G.ThreatBuddyForeverDB or {} local db = _G.ThreatBuddyForeverDB local currentDB = addonTable.GetDB and addonTable.GetDB() or {}
        glowCheck:SetChecked(currentDB.enableGlow) soloCheck:SetChecked(currentDB.hideWhileSolo) petCheck:SetChecked(currentDB.showSoloWithPet)
        soundCheck:SetChecked(currentDB.enableSound) highlightCheck:SetChecked(currentDB.highlightTarget) filterCheck:SetChecked(currentDB.filterTrivial)
        charProfileCheck:SetChecked(db.useCharProfile) scaleSlider:SetValue(currentDB.widgetScale or 1.0) targetScaleSlider:SetValue(currentDB.targetScale or 1.35)
        offsetSlider:SetValue(currentDB.xOffset or 10) lagSlider:SetValue(currentDB.updateThrottle or 0.08)
        colorAlphaSlider:SetValue(currentDB.colorAlpha or 1.0)
        cutEdgesCheck:SetChecked(currentDB.cutIconEdges)
        alphaSlider:SetValue(currentDB.widgetAlpha or 1.0) 
        
        if iconEditBox then iconEditBox:SetText(currentDB.customIconPath or "") end
        
        RefreshPanelStrings()
        RegisterAddonSettingsCategory()
    elseif event == "PLAYER_LOGIN" then 
        RefreshPanelStrings()
        if addonTable.SafeGetText and addonTable.SafeGetText("LOADED") ~= "" then print(addonTable.SafeGetText("LOADED")) end 
    end
end)

SLASH_THREATBUDDYFOREVER1 = "/tbf"
SlashCmdList.THREATBUDDYFOREVER = function(msg)
    local cmd, arg = string.split(" ", msg or "") cmd = string.lower(cmd or "") local currentDB = addonTable.GetDB and addonTable.GetDB() or {}
    if cmd == "scale" and arg then
        local num = tonumber(arg) if num and num >= 0.5 and num <= 2.5 then currentDB.widgetScale = num scaleSlider:SetValue(num) end
    elseif cmd == "test" then
        if testFrame and testFrame:IsShown() then testFrame:Hide()
        else
            if not testFrame and addonTable.CreateNewSignalWidget then 
                testFrame = addonTable.CreateNewSignalWidget() 
                addonTable.activeWidgets["test"] = testFrame 
            end
            if testFrame then
                testFrame:ClearAllPoints() testFrame:SetPoint(currentDB.point or "CENTER", UIParent, currentDB.point or "CENTER", currentDB.x or 0, currentDB.y or 100)
                testFrame:SetScale(currentDB.widgetScale or 1.0) testFrame:Show() 
                if addonTable.UpdateSingleWidgetData then addonTable.UpdateSingleWidgetData(testFrame, "test") end
                if addonTable.RebuildWidgetTextures then addonTable.RebuildWidgetTextures() end
            end
        end
    elseif cmd == "reset" then
        currentDB.point, currentDB.x, currentDB.y = "CENTER", 0, 0
        if testFrame then testFrame:ClearAllPoints() testFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100) end
    else
        if type(ToggleOptionsFrame) == "function" then
            ToggleOptionsFrame()
            if addonTable.settingsCategoryObject and SettingsPanel then
                C_Timer.After(0.01, function()
                    pcall(function() Settings.OpenToCategory(addonTable.settingsCategoryObject:GetID()) end)
                end)
            end
        else
            if SettingsPanel and SettingsPanel:IsShown() then 
                SettingsPanel:Hide() 
            else 
                if Settings and Settings.OpenToCategory and addonTable.settingsCategoryObject then
                    pcall(function() Settings.OpenToCategory(addonTable.settingsCategoryObject:GetID()) end)
                else
                    ShowUIPanel(GameMenuFrame)
                end
            end
        end
    end
end
