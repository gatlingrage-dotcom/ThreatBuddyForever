-- Run from the addon root with: lua tests\core_defaults.lua
local frames = {}
CreateFrame = function()
    local frame = {}
    function frame:RegisterEvent() end
    function frame:SetScript(_, handler) self.handler = handler end
    frames[#frames + 1] = frame
    return frame
end
local nameCalls = 0
UnitName = function() nameCalls = nameCalls + 1; return "Tester" end
GetRealmName = function() return "Realm" end
ThreatBuddyForeverDB = { updateThrottle = 0.3, enableGlow = false }
local addon = {}
assert(loadfile("Core.lua"))("ThreatBuddyForever", addon)
assert(addon.Version == "2.3.0")
assert(#frames == 1)
frames[1].handler(frames[1], "ADDON_LOADED", "ThreatBuddyForever")
assert(addon.GetDB() == ThreatBuddyForeverDB)
assert(nameCalls == 0)
assert(ThreatBuddyForeverDB.updateThrottle == 0.3)
assert(ThreatBuddyForeverDB.enableGlow == false)
assert(ThreatBuddyForeverDB.widgetAlpha == 1)
assert(ThreatBuddyForeverDB.visualStyle == nil and ThreatBuddyForeverDB.showBackgroundFrame == nil)
ThreatBuddyForeverDB.useCharProfile = true
local profile = addon.GetDB()
assert(nameCalls == 1 and profile == ThreatBuddyForeverDB.charProfiles["Tester - Realm"])
assert(profile.updateThrottle == 0.08 and profile.enableGlow == true)
profile.updateThrottle = 0.12
assert(addon.GetDB().updateThrottle == 0.12)
ThreatBuddyForeverDB.useCharProfile = false
assert(addon.GetDB().updateThrottle == 0.3)
print("Core defaults tests passed")
