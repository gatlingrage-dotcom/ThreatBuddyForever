local ADDON_NAME, addonTable = ...

-- HOT PATH CACHING: Cache local engine pointers to boost frame rendering speeds
local UnitClass, UnitBuff, GetShapeshiftForm = UnitClass, UnitBuff, GetShapeshiftForm
local UnitThreatSituation, UnitExists, UnitIsUnit = UnitThreatSituation, UnitExists, UnitIsUnit
local IsInGroup, IsInRaid, type, select = IsInGroup, IsInRaid, type, select
local string_find = string.find

-- HARDWARE ROLE DESIGNATOR: ULTRA CLEAN AUTOMATED ROLE DETECTION
function addonTable.IsPlayerTank()
    -- 1. PRIMARY INSTANCE TRACKER: Check Blizzard's official secure dungeon role assignment
    if UnitGroupRolesAssigned then
        local assignedRole = UnitGroupRolesAssigned("player")
        if assignedRole == "TANK" then 
            return true 
        elseif assignedRole == "DAMAGER" or assignedRole == "HEALER" then
            return false
        end
    end
    
    -- 2. CLASSIC OPEN-WORLD FALLBACK MAPS: Tracks active spec configurations if role is unassigned
    local _, classToken = UnitClass("player")
    
    if classToken == "WARRIOR" then
        return GetShapeshiftForm() == 2 -- Defensive Stance
    elseif classToken == "DRUID" then
        return GetShapeshiftForm() == 1 -- Bear Form
    elseif classToken == "PALADIN" then
        if type(UnitBuff) == "function" then
            for i = 1, 40 do
                local name = UnitBuff("player", i)
                if not name then break end
                if string_find(name, "Righteous Fury") then return true end
            end
        end
    end
    
    return false
end

-- ACCELERATED GROUP COMBAT SEPARATION SCANNER
function addonTable.IsUnitEngagedWithMyGroup(unit)
    if not UnitExists(unit) then return false end
    local playerThreat = UnitThreatSituation("player", unit)
    if issecretvalue and issecretvalue(playerThreat) then return true end
    if playerThreat ~= nil then return true end
    if UnitExists("pet") then
        local petThreat = UnitThreatSituation("pet", unit)
        if issecretvalue and issecretvalue(petThreat) then return true end
        if petThreat ~= nil then return true end
    end
    
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

function addonTable.IsUnitTargetingGroupMember(unit)
    if not UnitExists(unit) then return false end
    local targetToken = unit .. "target"
    if not UnitExists(targetToken) or UnitIsUnit(targetToken, "player") or UnitIsUnit(targetToken, "pet") then
        return false
    end

    for i = 1, 4 do
        if UnitExists("party" .. i) and UnitIsUnit(targetToken, "party" .. i) then return true end
        if UnitExists("partypet" .. i) and UnitIsUnit(targetToken, "partypet" .. i) then return true end
    end

    if IsInRaid() then
        for i = 1, 40 do
            if UnitExists("raid" .. i) and UnitIsUnit(targetToken, "raid" .. i) then return true end
            if UnitExists("raidpet" .. i) and UnitIsUnit(targetToken, "raidpet" .. i) then return true end
        end
    end

    return false
end
