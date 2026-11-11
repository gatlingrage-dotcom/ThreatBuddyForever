-- Run from the addon root with: lua tests\threat_values.lua
local secret = {}
issecretvalue = function(value) return rawequal(value, secret) end
local threatStatus, threatPercent, simpleThreat, petThreat
local tank, sounds, targetExists, targetingGroup = false, 0, false, false
local db = {
    widgetScale = 1, targetScale = 1.35, highlightTarget = false,
    enableGlow = true, enableSound = true, widgetAlpha = 1, colorAlpha = 1,
}

UnitExists = function(unit)
    return unit == "nameplate1" or unit == "nameplate2" or unit == "pet"
        or (targetExists and unit == "nameplate1target")
end
UnitIsDead = function() return false end
UnitCanAttack = function() return true end
UnitIsUnit = function() return false end
UnitThreatSituation = function(unit)
    if unit == "pet" then return petThreat end
    return simpleThreat
end
UnitDetailedThreatSituation = function() return false, threatStatus, threatPercent end
UnitClass = function() return nil, "MAGE" end
GetTime = function() return 10 end
IsInGroup = function() return false end
IsInRaid = function() return false end
InCombatLockdown = function() return true end
PlaySound = function() sounds = sounds + 1 end
STANDARD_TEXT_FONT = "font"

local function newObject()
    return setmetatable({ shown = true }, {
        __index = function(_, key)
            if key == "IsShown" then return function(self) return self.shown end end
            if key == "Show" then return function(self) self.shown = true end end
            if key == "Hide" then return function(self) self.shown = false end end
            if key == "SetText" then return function(self, value) self.value = value end end
            if key == "SetFormattedText" then
                return function(self, format, value)
                    assert(format == "%.0f%%")
                    assert(rawequal(value, secret))
                    self.value = "protected%"
                end
            end
            if key == "SetTextColor" then
                return function(self, r, g, b) self.color = { r, g, b } end
            end
            if key == "SetVertexColor" then
                return function(self, r, g, b) self.color = { r, g, b } end
            end
            if key == "SetAlpha" then return function(self, value) self.alpha = value end end
            if key == "SetTexture" then return function(self, value) self.texture = value end end
            if key == "GetFrameLevel" then return function(self) return self.level or 1 end end
            if key == "SetFrameLevel" then return function(self, value) self.level = value end end
            if key == "SetDisplayInfo" then return function(self, value) self.display = value end end
            if key == "SetParticlesEnabled" then return function(self, value) self.particles = value end end
            if key == "SetSize" then return function(self, w, h) self.width, self.height = w, h end end
            if key == "SetPoint" then
                return function(self, point, relativeTo, relativePoint, x, y)
                    self.anchor = { point, relativeTo, relativePoint, x, y }
                end
            end
            if key == "CreateTexture" or key == "CreateFontString" then
                return function() return newObject() end
            end
            if key == "SetScale" then return function(self, value) self.scale = value end end
            if key == "GetScale" then return function(self) return self.scale or 1 end end
            if key:match("^[A-Z]") then return function() end end
        end,
    })
end
CreateFrame = function() return newObject() end

local addon = {
    activeWidgets = {}, widgetPool = {}, soundCooldowns = {},
    GetDB = function() return db end,
    GetActiveTexture = function() return nil end,
    IsPlayerTank = function() return tank end,
    IsUnitTargetingGroupMember = function() return targetingGroup end,
}
assert(loadfile("Engine.lua"))("ThreatBuddyForever", addon)

local frame = newObject()
frame.text, frame.wisp = newObject(), newObject()
frame.signal, frame.signalMasked = newObject(), newObject()
local function update(status, percent)
    threatStatus, threatPercent = status, percent
    addon.UpdateSingleWidgetData(frame, "nameplate1")
    return frame.text.value
end

assert(update(0, 0) == "0%")
assert(frame.text.color[1] == 0.10 and frame.text.color[2] == 0.85)
assert(frame.wisp.shown and frame.wisp.color[2] == 0.85 and frame.wisp.alpha > 0)
assert(update(secret, secret) == "protected%")
assert(frame.text.color[1] == 0.75 and frame.text.color[2] == 0.75)
assert(frame.wisp.shown and frame.wisp.color[1] == 0.25 and frame.wisp.color[3] == 1)
assert(frame.wisp.alpha > 0)
assert(frame.currentThreatDisplayValue == nil)
assert(sounds == 0)
simpleThreat = 0
assert(update(secret, secret) == "protected%")
assert(frame.text.color[1] == 0.10 and frame.text.color[2] == 0.85)
simpleThreat = 2
assert(update(secret, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.55)
simpleThreat = 3
assert(update(secret, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.10)
assert(update(0, secret) == "protected%")
assert(frame.text.color[1] == 0.10 and frame.text.color[2] == 0.85)
simpleThreat = secret
assert(update(secret, secret) == "protected%")
assert(frame.text.color[1] == 0.75 and frame.text.color[2] == 0.75)
simpleThreat, sounds = nil, 0
addon.soundCooldowns = {}
assert(update(1, nil) == "--")
assert(frame.text.color[1] == 0.75 and frame.text.color[2] == 0.75)
assert(frame.wisp.color[1] == 0.25 and frame.wisp.color[3] == 1)
assert(update(secret, 42) == "42%")
assert(sounds == 0)
assert(update(0, secret) == "protected%")
assert(frame.text.color[1] == 0.10 and frame.text.color[2] == 0.85)
assert(update(1, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.55)
assert(update(2, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.55)
assert(update(3, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.10)
assert(update(4, secret) == "protected%")
assert(frame.text.color[1] == 0.75 and frame.text.color[2] == 0.75)
sounds = 0
addon.soundCooldowns = {}
assert(update(3, 37) == "37%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.10)
assert(sounds == 1)
assert(update(3, 100) == "62%")
assert(update(nil, nil) == "--")
assert(update(0, 100) == "100%")
assert(update(0, -5) == "60%")
db.enableGlow = false
assert(update(0, 0) == "36%")
assert(not frame.wisp.shown)
db.enableGlow = true
assert(update(0, 0) == "21%")
assert(frame.wisp.shown)
addon.UpdateSingleWidgetData(frame, "test")
assert(frame.text.value == "32%")
tank, targetExists, targetingGroup, sounds = true, true, true, 0
addon.soundCooldowns = {}
assert(update(secret, secret) == "protected%")
assert(frame.scale == 1 and sounds == 0)
simpleThreat = 3
assert(update(secret, secret) == "protected%")
assert(frame.text.color[1] == 0.10 and frame.text.color[2] == 0.85)
simpleThreat = nil
assert(update(1, secret) == "protected%")
assert(frame.scale == 1 * 1.35 * 1.40 and sounds == 1)
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.55)
assert(update(0, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.10)
assert(update(2, secret) == "protected%")
assert(frame.text.color[1] == 1 and frame.text.color[2] == 0.55)
assert(update(3, secret) == "protected%")
assert(frame.text.color[1] == 0.10 and frame.text.color[2] == 0.85)
tank, targetExists, targetingGroup = false, false, false

local utils = {}
assert(loadfile("Utils.lua"))("ThreatBuddyForever", utils)
simpleThreat, petThreat = secret, nil
assert(utils.IsUnitEngagedWithMyGroup("nameplate1"))
simpleThreat, petThreat = nil, secret
assert(utils.IsUnitEngagedWithMyGroup("nameplate1"))
simpleThreat, petThreat = 0, nil
assert(utils.IsUnitEngagedWithMyGroup("nameplate1"))
simpleThreat, petThreat = nil, nil
assert(not utils.IsUnitEngagedWithMyGroup("nameplate1"))

UnitDetailedThreatSituation = nil
local fallbackAddon = {
    activeWidgets = {}, widgetPool = {}, soundCooldowns = {},
    GetDB = function() return db end,
    GetActiveTexture = function() return nil end,
    IsPlayerTank = function() return false end,
    IsUnitTargetingGroupMember = function() return false end,
}
assert(loadfile("Engine.lua"))("ThreatBuddyForever", fallbackAddon)
simpleThreat = secret
fallbackAddon.UpdateSingleWidgetData(frame, "nameplate1")
assert(frame.text.value == "--")
simpleThreat = 3
fallbackAddon.UpdateSingleWidgetData(frame, "nameplate1")
assert(frame.text.value == "--")

issecretvalue = nil
simpleThreat = 0
fallbackAddon.UpdateSingleWidgetData(frame, "nameplate1")
assert(frame.text.value == "--")
threatStatus, threatPercent = 0, 0
addon.UpdateSingleWidgetData(frame, "nameplate1")
assert(frame.text.value == "0%")

local widgetAddon = { widgetPool = {}, activeWidgets = {}, GetDB = function() return db end }
assert(loadfile("Themes.lua"))("ThreatBuddyForever", widgetAddon)
local widget = widgetAddon.CreateNewSignalWidget()
assert(widget.wisp.texture == "Interface\\AddOns\\ThreatBuddyForever\\Media\\ThreatWisp.tga")
assert(widget.wisp.width == 36 * 1.5 and widget.wisp.height == 36 * 2.1)
assert(not widget.wisp.shown)
assert(widget.wispModel.display == 10045 and widget.wispModel.particles)
for i = 1, 5 do assert(widget.wispModel.anchor[i] == widget.text.anchor[i]) end
assert(widget.wispModel.level == 2 and widget.textLayer.level == 3)
assert(not widget.wispModel.shown)
issecretvalue = function(value) return rawequal(value, secret) end
threatStatus, threatPercent = secret, secret
addon.UpdateSingleWidgetData(widget, "nameplate1")
assert(widget.wisp.shown and widget.wispModel.shown)
assert(widget.text.value == "protected%")
db.enableGlow = false
addon.UpdateSingleWidgetData(widget, "nameplate1")
assert(not widget.wisp.shown and not widget.wispModel.shown)
db.enableGlow = true
addon.UpdateSingleWidgetData(widget, "nameplate1")
assert(widget.wispModel.shown)
widget.wisp:Show()
widgetAddon.RecycleSignalWidget(widget)
assert(not widget.wisp.shown and not widget.wispModel.shown and #widgetAddon.widgetPool == 1)
assert(widgetAddon.CreateNewSignalWidget() == widget)

local plate1, plate2 = newObject(), newObject()
local anchor1, anchor2 = newObject(), newObject()
anchor1.LevelFrame, anchor1.HealthBarsContainer, anchor1.healthBar = false, false, false
anchor2.LevelFrame, anchor2.HealthBarsContainer, anchor2.healthBar = false, false, false
plate1.namePlateUnitToken, plate1.UnitFrame = "nameplate1", anchor1
plate2.namePlateUnitToken, plate2.UnitFrame = "nameplate2", anchor2
C_NamePlate = { GetNamePlates = function() return { plate1, plate2 } end }
local roleCalls, textureCalls, targetCalls = 0, 0, 0
addon.IsPlayerTank = function() roleCalls = roleCalls + 1; return tank end
addon.GetActiveTexture = function() textureCalls = textureCalls + 1; return nil end
addon.IsUnitTargetingGroupMember = function() targetCalls = targetCalls + 1; return true end
addon.IsUnitEngagedWithMyGroup = function() return true end
addon.CreateNewSignalWidget = widgetAddon.CreateNewSignalWidget
addon.RecycleSignalWidget = widgetAddon.RecycleSignalWidget
db.enableSound, db.filterTrivial = false, false
targetExists, tank = true, false
threatStatus, threatPercent = 1, 41
UnitDetailedThreatSituation = function() return false, threatStatus, threatPercent end
assert(loadfile("Engine.lua"))("ThreatBuddyForever", addon)
TTP_RefreshAllNameplates()
assert(roleCalls == 1 and textureCalls == 1 and targetCalls == 0)
assert(addon.activeWidgets.nameplate1.text.value == "41%")
assert(addon.activeWidgets.nameplate2.text.value == "41%")
roleCalls, textureCalls, targetCalls = 0, 0, 0
tank = true
TTP_RefreshAllNameplates()
assert(roleCalls == 1 and textureCalls == 1 and targetCalls == 1)
assert(addon.activeWidgets.nameplate1.scale == 1 * 1.35 * 1.40)
assert(addon.activeWidgets.nameplate2.scale == 1)
print("Threat value regression tests passed")
