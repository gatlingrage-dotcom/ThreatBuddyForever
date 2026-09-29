local ADDON_NAME, addonTable = ...

-- HOT PATH CACHING: Micro-cache core engine structures to avoid processing spikes
local UnitClass, UnitBuff, GetShapeshiftForm = UnitClass, UnitBuff, GetShapeshiftForm
local UnitThreatSituation, UnitExists, UnitIsUnit = UnitThreatSituation, UnitExists, UnitIsUnit
local IsInGroup, IsInRaid, type, select = IsInGroup, IsInRaid, type, select
local string_find = string.find

-- ACCELERATED TANK SPECIALIZATION DETECTOR (Taint-Free Vector Caching)
function addonTable.IsPlayerTank()
    local _, classToken = UnitClass("player")
    
    if classToken == "WARRIOR" then
        return GetShapeshiftForm() == 2 -- Secure structural Defensive Stance check
    elseif classToken == "DRUID" then
        return GetShapeshiftForm() == 1 -- Secure structural Bear Form check
    elseif classToken == "PALADIN" then
        -- Fast iteration lookup matching active protective combat locks
        if type(UnitBuff) == "function" then
            for i = 1, 40 do
                local name = UnitBuff("player", i)
                if not name then break end -- Terminate line sweep instantly on empty frames
                if string_find(name, "Righteous Fury") then return true end
            end
        end
    end
    
    -- Fall back securely on standard role layout matrices if talent structures don't query numbers
    local assignedRole = UnitGroupRolesAssigned and UnitGroupRolesAssigned("player")
    if assignedRole == "TANK" then
        return true
    end
    
    return false
end

-- ACCELERATED GROUP COMBAT SEPARATION SCANNER
-- Keeps your widgets hidden until an enemy is actively generated onto a team threat wheel
function addonTable.IsUnitEngagedWithMyGroup(unit)
    if not UnitExists(unit) then return false end
    
    -- Direct validation: If the player registers on the target's threat wheel, skip subsequent checks
    if UnitThreatSituation("player", unit) then return true end
    
    -- Pet validation: Check your active summoning arrays safely
    if UnitExists("pet") and UnitThreatSituation("pet", unit) then return true end
    
    if IsInGroup() or IsInRaid() then
        local targetToken = unit .. "target"
        if UnitExists(targetToken) then
            -- 1. Fast Group Party Line Scanner loop (1 to 4 teammates)
            for i = 1, 4 do
                if UnitIsUnit(targetToken, "party" .. i) then return true end
                if UnitExists("partypet" .. i) and UnitIsUnit(targetToken, "partypet" .. i) then return true end
            end
            
            -- 2. Extended Raid Line Grid Scanner loop (1 to 40 teammates)
            if IsInRaid() then
                for i = 1, 40 do 
                    if UnitIsUnit(targetToken, "raid" .. i) then return true end 
                end
            end
        end
    end
    
    return false
end
