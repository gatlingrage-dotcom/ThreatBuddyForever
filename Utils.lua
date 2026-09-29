local ADDON_NAME, addonTable = ...

-- HOT PATH CACHING: Cache local engine variables to completely block garbage collection spikes
local UnitClass, UnitBuff, GetShapeshiftForm = UnitClass, UnitBuff, GetShapeshiftForm
local UnitThreatSituation, UnitExists, UnitIsUnit = UnitThreatSituation, UnitExists, UnitIsUnit
local IsInGroup, IsInRaid = IsInGroup, IsInRaid
local string_find, select = string.find, select

-- ACCELERATED TANK SPECIALIZATION DETECTOR (Vanilla 2.0 Dynamic Engine Caching)
function addonTable.IsPlayerTank()
    local class = select(2, UnitClass("player"))
    if class == "WARRIOR" then
        return GetShapeshiftForm() == 2 -- Fast integer defensive stance check
    elseif class == "PALADIN" then
        if type(UnitBuff) == "function" then
            for i = 1, 40 do
                local name = UnitBuff("player", i)
                if not name then break end -- Exit early on empty buffs to save CPU cycles
                if string_find(name, "Righteous Fury") then return true end
            end
        end
    elseif class == "DRUID" then
        return GetShapeshiftForm() == 1 -- Fast integer bear form check
    end
    return false
end

-- ACCELERATED GROUP COMBAT SEPARATION SCANNER
function addonTable.IsUnitEngagedWithMyGroup(unit)
    if UnitThreatSituation("player", unit) then return true end
    if UnitExists("pet") and UnitThreatSituation("pet", unit) then return true end
    
    if IsInGroup() or IsInRaid() then
        local targetToken = unit .. "target"
        if UnitExists(targetToken) then
            for i = 1, 4 do
                if UnitIsUnit(targetToken, "party" .. i) then return true end
                if UnitExists("partypet" .. i) and UnitIsUnit(targetToken, "partypet" .. i) then return true end
            end
            if IsInRaid() then
                for i = 1, 40 do 
                    if UnitIsUnit(targetToken, "raid" .. i) then return true end 
                end
            end
        end
    end
    return false
end
