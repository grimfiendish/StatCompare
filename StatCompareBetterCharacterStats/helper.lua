--[[

This file isset up to be used outside of BCS as a standalone library.

HOW TO USE THIS FILE OUTSIDE OF BCS IN YOUR OWN ADDON:

	1. Note the version of BCS you pulled helper.lua from (e.g. open the `toc` file and grab its Version, e.g. `1.13.0`)
	2. In your addon's toc file, add this line
		## OptionalDeps: BetterCharacterStats
	3. Copy helper.lua into your addon (which you may rename) and add it into your toc file, like so:
	   libs/BCSHelper.lua
	4. Make sure you have a lua file that loads before `helper.lua`, and in it define BCS_MIN_VERSION, like so:
		BCS_MIN_VERSION="1.13.0"
	
Having done the above, you should be able to access BCS functions like `BCS:GetSpellPower` even if the user
does not have BCS installed.

If they do have BCS installed and it's newer than your BCS_MIN_VERSION then it'll use theirs.

--]]

BCS = BCS or {}
BCS.Debug = BCS.Debug or false

-- UnitStat(unit, STAT)...
local STAT_STRENGTH      =  1
local STAT_AGILITY       =  2
local STAT_STAMINA       =  3
local STAT_INTELLECT     =  4
local STAT_SPIRIT        =  5

-- SetInventoryItem(unit, SLOT)
local UNITSLOT_AMMO      =  0
local UNITSLOT_HEAD      =  1
local UNITSLOT_NECK      =  2
local UNITSLOT_SHOULDER  =  3
local UNITSLOT_SHIRT     =  4
local UNITSLOT_CHEST     =  5
local UNITSLOT_BELT      =  6
local UNITSLOT_LEGS      =  7
local UNITSLOT_FEET      =  8
local UNITSLOT_WRIST     =  9
local UNITSLOT_GLOVES    = 10
local UNITSLOT_FINGER_1  = 11
local UNITSLOT_FINGER_2  = 12
local UNITSLOT_TRINKET_1 = 13
local UNITSLOT_TRINKET_2 = 14
local UNITSLOT_BACK      = 15
local UNITSLOT_MAIN_HAND = 16
local UNITSLOT_OFF_HAND  = 17
local UNITSLOT_RANGED    = 18
local UNITSLOT_TABARD    = 19


local function nvl(value, default)
    return value ~= nil and value or default
end


BCS.FOO = BCS.FOO or {}
table.insert(BCS.FOO, "Loading")


function BCS:FindVersion(ver)
	local major, minor, tiny
	
	m = string.gmatch and string.gmatch or string.gfind

	-- Use gmatch to iterate over the parts of the string
	local i = 1
	for part in m(nvl(ver,""), "(%d+)") do
		if i == 1 then
			major = tonumber(part)
		elseif i == 2 then
			minor = tonumber(part)
		elseif i == 3 then
			tiny = tonumber(part)
		end
		i = i + 1
	end
	
	return major, minor, tiny
end

-- Returns true iff p1 > p2.
function BCS:isVersionNewer(p1, p2)
	local major1, minor1, tiny1 = BCS:FindVersion(p1)
	local major2, minor2, tiny2 = BCS:FindVersion(p2)
	
    if major1 ~= nil and major2 == nil or nvl(major1,-1) > nvl(major2,-1) then
        return 1
    elseif major1 == nil and major2 ~= nil or nvl(major1,-1) < nvl(major2,-1) then
        return -1
    end

    if minor1 ~= nil and minor2 == nil or nvl(minor1,-1) > nvl(minor2,-1) then
        return 1
    elseif minor1 == nil and minor2 ~= nil or nvl(minor1,-1) < nvl(minor2,-1) then
        return -1
    end
	
    if tiny1 ~= nil and tiny2 == nil or nvl(tiny1,-1) > nvl(tiny2,-1) then
        return 1
    elseif tiny1 == nil and tiny2 ~= nil or nvl(tiny1,-1) < nvl(tiny2,-1) then
        return -1
    end

    return 0
end

if BCS ~= nil and BCS.BCS_SUPPORTS_TARGET and BCS.BCS_SUPPORTS_TARGET == true and BCS_MIN_VERSION ~= nil then
table.insert(BCS.FOO, "Comparing versions!")
	-- This file is set up to be usable outside of BetterCharacterStats
	-- Here we check to see what version of BCS is installed relative to the version of `helper.lua` we've tucked away.
	-- If it's less than our version then it implies they've got an out-of-date BCS and we'll need to use this one, which will be compatible with their old version.
	-- If it's equal-or-higher, then we'll use the BCS version.
	local realBCSversion = GetAddOnMetadata("BetterCharacterStats", "Version");
table.insert(BCS.FOO, "real version is "..realBCSversion.." and min version is ".. BCS_MIN_VERSION)
	if BCS:isVersionNewer(realBCSversion, BCS_MIN_VERSION) >= 0 then
table.insert(BCS.FOO, "Aborting! Yay!")
		return
	end
table.insert(BCS.FOO, "After Abort?!")
else

if BCS == nil then
table.insert(BCS.FOO, "bcsnil")
elseif BCS.BCS_SUPPORTS_TARGET == nil then
table.insert(BCS.FOO, "supportsisnil")
elseif BCS_MIN_VERSION == nil then
table.insert(BCS.FOO, "nominversion")
else
table.insert(BCS.FOO, "else!")
end

end


BCS.BCS_SUPPORTS_TARGET = true

local BCS_Prefix = "BetterCharacterStatsTooltip"
local BCS_Tooltip = getglobal("BetterCharacterStatsTooltip") or CreateFrame("GameTooltip", BCS_Prefix, nil, "GameTooltipTemplate")
BCS_Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local L = BCS["L"]
local setPattern = "(.+) %(%d/%d%)"
local strfind = strfind
local tonumber = tonumber
local tinsert = tinsert

local function tContains(table, item)
	local index = 1
	while table[index] do
		if ( item == table[index] ) then
			return 1
		end
		index = index + 1
	end
	return nil
end

BCScache = BCScache or {
	["gear"] = {
		damage_and_healing = 0,
		arcane = 0,
		fire = 0,
		frost = 0,
		holy = 0,
		nature = 0,
		shadow = 0,
		healing = 0,
		mp5 = 0,
		casting = 0,
		spell_hit = 0,
		spell_crit = 0,
		hit = 0,
		ranged_hit = 0,
		ranged_crit = 0
	},
	["talents"] = {
		damage_and_healing = 0,
		healing = 0,
		spell_hit = 0,
		spell_hit_fire = 0,
		spell_hit_frost = 0,
		spell_hit_arcane = 0,
		spell_hit_shadow = 0,
		spell_hit_holy = 0,
		spell_crit = 0,
		casting = 0,
		mp5 = 0,
		hit = 0,
		ranged_hit = 0,
		ranged_crit = 0
	},
	["auras"] = {
		damage_and_healing = 0,
		only_damage = 0,
		arcane = 0,
		fire = 0,
		frost = 0,
		holy = 0,
		nature = 0,
		shadow = 0,
		healing = 0,
		mp5 = 0,
		casting = 0,
		spell_hit = 0,
		spell_crit = 0,
		hit = 0,
		ranged_hit = 0,
		ranged_crit = 0,
		hit_debuff = 0
	},
	["skills"] = {
		mh = 0,
		oh = 0,
		ranged = 0
	}
}

-- From https://github.com/refaim/SortBags/blob/master/SortBags.lua#L6
local function IsPlayingOnTurtleWoW()
	-- https://github.com/refaim/Turtle-WoW-UI-Source/blob/d6137c2ebd291f10ce284e586a5733dd5141bef2/Interface/FrameXML/TargetFrame.xml#L183
	return TargetHPText ~= nil and TargetHPPercText ~= nil
end

function BCS:GetPlayerAura(searchText, auraType)
	if not auraType then
		-- buffs
		-- http://blue.cardplace.com/cache/wow-dungeons/624230.htm
		-- 32 buffs max
		for i=0, 31 do
			local index = GetPlayerBuff(i, 'HELPFUL')
			if index > -1 then
				BCS_Tooltip:SetPlayerBuff(index)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						if strfind(text, searchText) then
							return strfind(text, searchText)
						end
					end
				end
			end
		end
	elseif auraType == 'HARMFUL' then
		for i=0, 6 do
			local index = GetPlayerBuff(i, auraType)
			if index > -1 then
				BCS_Tooltip:SetPlayerBuff(index)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						if strfind(text, searchText) then
							return strfind(text, searchText)
						end
					end
				end
			end
		end
	end
end

function BCS:GetUnitHitRating(unit, hitOnly)
	if unit == nil then unit = "player"; end
	local Hit_Set_Bonus = {}
	local hit = 0
	local gear_hit = 0
	local auras_hit = 0
	local auras_hit_debuff = 0
	local talents_hit = 0

	if BCS.needScanGear or unit ~= "player" then
		gear_hit = 0
		--scan gear
		for slot=1, 19 do
			if BCS_Tooltip:SetInventoryItem(unit, slot) then
				local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
				if eqItemLink then
					BCS_Tooltip:ClearLines()
					BCS_Tooltip:SetHyperlink(eqItemLink)
				end
				local SET_NAME = nil
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _,_, value = strfind(text, L["Equip: Improves your chance to hit by (%d)%%."])
						if value then
							gear_hit = gear_hit + tonumber(value)
						end
						_,_, value = strfind(text, L["/Hit %+(%d+)"])
						if value then
							gear_hit = gear_hit + tonumber(value)
						end

						_,_, value = strfind(text, setPattern)
						if value then
							SET_NAME = value
						end
						_,_, value = strfind(text, L["^Set: Improves your chance to hit by (%d)%%."])
						if value and SET_NAME and not tContains(Hit_Set_Bonus, SET_NAME) then
							tinsert(Hit_Set_Bonus, SET_NAME)
							gear_hit = gear_hit + tonumber(value)
							break
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["gear"].hit = gear_hit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		gear_hit = BCScache["gear"].hit
	end

	if BCS.needScanAuras and unit == "player" then
		-- buffs
		local _, _, hitFromAura = BCS:GetPlayerAura(L["Chance to hit increased by (%d)%%."])
		if hitFromAura then
			auras_hit = auras_hit + tonumber(hitFromAura)
		end
		_, _, hitFromAura = BCS:GetPlayerAura(L["Improves your chance to hit by (%d+)%%."])
		if hitFromAura then
			auras_hit = auras_hit + tonumber(hitFromAura)
		end
		_, _, hitFromAura = BCS:GetPlayerAura(L["Increases attack power by %d+ and chance to hit by (%d+)%%."])
		if hitFromAura then
			auras_hit = auras_hit + tonumber(hitFromAura)
		end
		-- debuffs
		_, _, hitFromAura = BCS:GetPlayerAura(L["Chance to hit reduced by (%d+)%%."], 'HARMFUL')
		if hitFromAura then
			auras_hit_debuff = auras_hit_debuff + tonumber(hitFromAura)
		end
		_, _, hitFromAura = BCS:GetPlayerAura(L["Chance to hit decreased by (%d+)%% and %d+ Nature damage every %d+ sec."], 'HARMFUL')
		if hitFromAura then
			auras_hit_debuff = auras_hit_debuff + tonumber(hitFromAura)
		end
		hitFromAura = BCS:GetPlayerAura(L["Lowered chance to hit."], 'HARMFUL')
		if hitFromAura then
			auras_hit_debuff = auras_hit_debuff + 25
		end
		if unit == "player" then
			BCScache["auras"].hit = auras_hit
			BCScache["auras"].hit_debuff = auras_hit_debuff
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		auras_hit = BCScache["auras"].hit
		auras_hit_debuff = BCScache["auras"].hit_debuff
	end

	if BCS.needScanTalents and unit == "player" then
		talents_hit = 0
		--scan talents
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						-- Rogue
						local _,_, value = strfind(text, L["Increases your chance to hit with melee weapons by (%d)%%."])
						if value and rank > 0 then
							talents_hit = talents_hit + tonumber(value)
							break
						end
						-- Hunter
						_,_, value = strfind(text, L["Increases hit chance by (%d)%% and increases the chance movement impairing effects will be resisted by an additional %d+%%."])
						if value and rank > 0 then
							talents_hit = talents_hit + tonumber(value)
							break
						end
						-- Druid
						-- Natural Weapons
						_,_, value = strfind(text, L["Also increases chance to hit with melee attacks and spells by (%d+)%%."])
						if value and rank > 0 then
							talents_hit = talents_hit + tonumber(value)
							break
						end
						-- Paladin
						-- Precision
						_,_, value = strfind(text, L["Increases your chance to hit with melee attacks and spells by (%d+)%%."])
						if value and rank > 0 then
							talents_hit = talents_hit + tonumber(value)
							break
						end
						-- Shaman
						-- Elemental Devastation
						_,_, value = strfind(text, L["Increases your chance to hit with spells and melee attacks by (%d+)%%"])
						if value and rank > 0 then
							talents_hit = talents_hit + tonumber(value)
							break
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["talents"].hit = talents_hit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
			talents_hit = BCScache["talents"].hit
	end
	hit = talents_hit + gear_hit + auras_hit
	if not hitOnly then
		hit = hit - auras_hit_debuff
		if hit < 0 then hit = 0 end -- Dust Cloud OP
		return hit
	else
		return hit
	end
end

function BCS:GetHitRating(hitOnly)
	return BCS:GetUnitHitRating("player", hitOnly)
end

function BCS:GetUnitRangedHitRating(unit)
	if unit == nil then unit = "player"; end
	local auras_hit_debuff = (unit == "player") and BCScache["auras"].hit_debuff or 0
	local ranged_hit = 0
	if BCS.needScanGear or unit ~= "player" then
		if BCS_Tooltip:SetInventoryItem(unit, UNITSLOT_RANGED) then
			for line=1, BCS_Tooltip:NumLines() do
				local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
				local text = left:GetText()
				if text then
					local _,_, value = strfind(text, L["+(%d)%% Ranged Hit"])
					if value then
						ranged_hit = ranged_hit + tonumber(value)
						break
					end
				end
			end
		end	
		if unit == "player" then
			BCScache["gear"].ranged_hit = ranged_hit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		ranged_hit = BCScache["gear"].ranged_hit
	end
	local ranged_hit = BCS:GetUnitHitRating(unit, true) + ranged_hit - auras_hit_debuff
	if ranged_hit < 0 then ranged_hit = 0 end
	
	return ranged_hit
end

function BCS:GetRangedHitRating()
	return BCS:GetUnitRangedHitRating("player")
end

function BCS:GetUnitSpellHitRating(unit)
	if unit == nil then unit = "player"; end
	local hit = 0
	local gear_spell_hit = 0
	local talents_spell_hit = 0
	local spell_hit_fire = 0
	local spell_hit_frost = 0
	local spell_hit_arcane = 0
	local spell_hit_shadow = 0
	local spell_hit_holy = 0
	local auras_spell_hit = 0
	local hit_Set_Bonus = {}
	if BCS.needScanGear or unit ~= "player" then
		-- scan gear
		for slot=1, 19 do
			if BCS_Tooltip:SetInventoryItem(unit, slot) then
				local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
				if eqItemLink then
					BCS_Tooltip:ClearLines()
					BCS_Tooltip:SetHyperlink(eqItemLink)
				end
				local SET_NAME
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _,_, value = strfind(text, L["Equip: Improves your chance to hit with spells by (%d)%%."])
						if value then
							gear_spell_hit = gear_spell_hit + tonumber(value)
						end
						_,_, value = strfind(text, L["/Spell Hit %+(%d+)"])
						if value then
							gear_spell_hit = gear_spell_hit + tonumber(value)
						end
						
						_,_, value = strfind(text, setPattern)
						if value then
							SET_NAME = value
						end
						_, _, value = strfind(text, L["^Set: Improves your chance to hit with spells by (%d)%%."])
						if value and SET_NAME and not tContains(hit_Set_Bonus, SET_NAME) then
							tinsert(hit_Set_Bonus, SET_NAME)
							gear_spell_hit = gear_spell_hit + tonumber(value)
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["gear"].spell_hit = gear_spell_hit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		gear_spell_hit = BCScache["gear"].spell_hit
	end
	if BCS.needScanTalents or unit ~= "player" then
		-- scan talents
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						-- Mage
						-- Elemental Precision
						local _,_, value = strfind(text, L["Reduces the chance that the opponent can resist your Frost and Fire spells by (%d)%%."])
						if value and rank > 0 then
							spell_hit_fire = spell_hit_fire + tonumber(value)
							spell_hit_frost = spell_hit_frost + tonumber(value)
							break
						end
						-- Arcane Focus
						_,_, value = strfind(text, L["Reduces the chance that the opponent can resist your Arcane spells by (%d+)%%."])
						if value and rank > 0 then
							spell_hit_arcane = spell_hit_arcane + tonumber(value)
							break
						end
						-- Priest
						-- Piercing Light
						_,_, value = strfind(text, L["Reduces the chance for enemies to resist your Holy and Discipline spells by (%d+)%%."])
						if value and rank > 0 then
							spell_hit_holy = spell_hit_holy + tonumber(value)
							break
						end
						-- Shadow Focus
						_,_, value = strfind(text, L["Reduces your target's chance to resist your Shadow spells by (%d+)%%."])
						if value and rank > 0 then
							spell_hit_shadow = spell_hit_shadow + tonumber(value)
							break
						end
						-- Druid
						-- Natural Weapons
						_,_, value = strfind(text, L["Also increases chance to hit with melee attacks and spells by (%d+)%%."])
						if value and rank > 0 then
							talents_spell_hit = talents_spell_hit + tonumber(value)
							break
						end
						-- Paladin
						-- Precision
						_,_, value = strfind(text, L["Increases your chance to hit with melee attacks and spells by (%d+)%%."])
						if value and rank > 0 then
							talents_spell_hit = talents_spell_hit + tonumber(value)
							break
						end
						-- Shaman
						-- Elemental Devastation
						_,_, value = strfind(text, L["Increases your chance to hit with spells and melee attacks by (%d+)%%"])
						if value and rank > 0 then
							talents_spell_hit = talents_spell_hit + tonumber(value)
							break
						end
						-- Warlock
						-- Suppression
						_,_, value = strfind(text, L["Reduces the chance for enemies to resist your Affliction spells by (%d+)%%."])
						if value and rank > 0 then
							spell_hit_shadow = spell_hit_shadow + tonumber(value)
							break
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["talents"].spell_hit = talents_spell_hit
			BCScache["talents"].spell_hit_fire = spell_hit_fire
			BCScache["talents"].spell_hit_frost = spell_hit_frost
			BCScache["talents"].spell_hit_arcane = spell_hit_arcane
			BCScache["talents"].spell_hit_shadow = spell_hit_shadow
			BCScache["talents"].spell_hit_holy = spell_hit_holy
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		talents_spell_hit = BCScache["talents"].spell_hit
		spell_hit_fire = BCScache["talents"].spell_hit_fire
		spell_hit_frost = BCScache["talents"].spell_hit_frost
		spell_hit_arcane = BCScache["talents"].spell_hit_arcane
		spell_hit_shadow = BCScache["talents"].spell_hit_shadow
		spell_hit_holy = BCScache["talents"].spell_hit_holy
	end
	-- buffs
	if BCS.needScanAuras and unit == "player" then
		local _, _, hitFromAura = BCS:GetPlayerAura(L["Spell hit chance increased by (%d+)%%."])
		if hitFromAura then
			auras_spell_hit = auras_spell_hit + tonumber(hitFromAura)
		end
		-- Elemental Devastation
		_, _, hitFromAura = BCS:GetPlayerAura(L["Increases your chance to hit with spells by (%d+)%%"])
		if hitFromAura then
			auras_spell_hit = auras_spell_hit + tonumber(hitFromAura)
		end
		if unit == "player" then
			BCScache["auras"].spell_hit = auras_spell_hit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		auras_spell_hit = BCScache["auras"].spell_hit
	end

	hit = gear_spell_hit + talents_spell_hit + auras_spell_hit

	return hit, spell_hit_fire, spell_hit_frost, spell_hit_arcane, spell_hit_shadow, spell_hit_holy
end

function BCS:GetSpellHitRating()
	return BCS:GetUnitSpellHitRating("player")
end

function BCS:GetCritChance()
	local crit = 0
	--scan spellbook
	for tab=1, GetNumSpellTabs() do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		for spell=1, numSpells do
			local currentPage = ceil(spell/SPELLS_PER_PAGE)
			local SpellID = spell + offset + ( SPELLS_PER_PAGE * (currentPage - 1))
			BCS_Tooltip:SetSpell(SpellID, BOOKTYPE_SPELL)
			for line=1, BCS_Tooltip:NumLines() do
				local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
				local text = left:GetText()
				if text then
					local _,_, value = strfind(text, L["([%d.]+)%% chance to crit"])
					if value then
						crit = crit + tonumber(value)
						break
					end
				end
			end
		end
	end

	return crit
end

function BCS:GetUnitRangedCritChance(unit)
	-- values from vmangos core
	local crit = 0
	local _, class = UnitClass(unit)
	local _, agility = UnitStat(unit, STAT_AGILITY)
	local vallvl1 = 0
	local vallvl60 = 0
	local classrate = 0
	local auras_ranged_crit = 0
	local gear_ranged_crit = 0
	local talents_ranged_crit = 0

	if class == "MAGE" then
		vallvl1 = 12.9
		vallvl60 = 20
	elseif class == "ROGUE" then
		vallvl1 = 2.2
		vallvl60 = 29
	elseif class == "HUNTER" then
		vallvl1 = 3.5
		vallvl60 = 53
	elseif class == "PRIEST" then
		vallvl1 = 11
		vallvl60 = 20
	elseif class == "WARLOCK" then
		vallvl1 = 8.4
		vallvl60 = 20
	elseif class == "WARRIOR" then
		vallvl1 = 3.9
		vallvl60 = 20
	else
		return crit
	end

	classrate = vallvl1 * (60 - UnitLevel(unit)) / 59 + vallvl60 * (UnitLevel(unit) - 1) / 59
	crit = agility / classrate

	if BCS.needScanTalents and unit == "player" then
		--scan talents
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						local _,_, value = strfind(text, L["Increases your critical strike chance with ranged weapons by (%d)%%."])
						if value and rank > 0 then
							talents_ranged_crit = talents_ranged_crit + tonumber(value)
							break
						end
						_,_, value = strfind(text, L["Increases your critical strike chance with all attacks by (%d)%%."])
						if value and rank > 0 then
							talents_ranged_crit = talents_ranged_crit + tonumber(value)
							break
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["talents"].ranged_crit = talents_ranged_crit
		end

	elseif unit == "player" then -- We did not recalculate, so using cache
		talents_ranged_crit = BCScache["talents"].ranged_crit
	end

	if BCS.needScanGear or unit ~= "player" then
		--scan gear
		local Crit_Set_Bonus = {}
		for slot=1, 19 do
			if BCS_Tooltip:SetInventoryItem('player', slot) then
				local _, _, eqItemLink = strfind(GetInventoryItemLink('player', slot), "(item:%d+:%d+:%d+:%d+)")
				if eqItemLink then
					BCS_Tooltip:ClearLines()
					BCS_Tooltip:SetHyperlink(eqItemLink)
				end
				local SET_NAME
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _,_, value = strfind(text, L["Equip: Improves your chance to get a critical strike by (%d)%%."])
						if value then
							gear_ranged_crit = gear_ranged_crit + tonumber(value)
						end
						_,_, value = strfind(text, L["Equip: Improves your chance to get a critical strike with missile weapons by (%d)%%."])
						if value then
							gear_ranged_crit = gear_ranged_crit + tonumber(value)
						end
						-- Might of the Scourge (shoulder enchant)
						_,_, value = strfind(text, L["%+(%d+)%% Critical Strike"])
						if value then
							gear_ranged_crit = gear_ranged_crit + tonumber(value)
						end

						_,_, value = strfind(text, setPattern)
						if value then
							SET_NAME = value
						end
						_, _, value = strfind(text, L["^Set: Improves your chance to get a critical strike by (%d)%%."])
						if value and SET_NAME and not tContains(Crit_Set_Bonus, SET_NAME) then
							tinsert(Crit_Set_Bonus, SET_NAME)
							gear_ranged_crit = gear_ranged_crit + tonumber(value)
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["gear"].ranged_crit = gear_ranged_crit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		gear_ranged_crit = BCScache["gear"].ranged_crit
	end
	if BCS.needScanAuras and unit == "player" then
		--ony head
		local critFromAura = BCS:GetPlayerAura(L["Increases critical chance of spells by 10%%, melee and ranged by 5%% and grants 140 attack power. 120 minute duration."])
		if critFromAura then
			auras_ranged_crit = auras_ranged_crit + 5
		end
		--mongoose
		_, _, critFromAura = BCS:GetPlayerAura(L["Agility increased by 25, Critical hit chance increases by (%d)%%."])
		if critFromAura then
			auras_ranged_crit = auras_ranged_crit + tonumber(critFromAura)
		end
		--songflower
		_, _, critFromAura = BCS:GetPlayerAura(L["Increases chance for a melee, ranged, or spell critical by (%d+)%% and all attributes by %d+."])
		if critFromAura then
			auras_ranged_crit = auras_ranged_crit + tonumber(critFromAura)
		end
		--leader of the pack
		_, _, critFromAura = BCS:GetPlayerAura(L["Increases ranged and melee critical chance by (%d+)%%."])
		if critFromAura then
			auras_ranged_crit = auras_ranged_crit + tonumber(critFromAura)
			--check if druid is shapeshifted and have Idol of the Moonfang equipped
			for i=1, GetNumPartyMembers() do
				local _, partyClass = UnitClass("party"..i)
				if partyClass == "DRUID" then
					if BCS_Tooltip:SetInventoryItem("party"..i, UNITSLOT_RANGED) and UnitCreatureType("party"..i) == "Beast" then
						for line=1, BCS_Tooltip:NumLines() do
							local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
							local text = left:GetText()
							if text then
								_, _, critFromAura = strfind(text, L["Equip: Increases the critical chance provided by Leader of the Pack and Moonkin Aura by (%d)%%."])
								if critFromAura  then
									auras_ranged_crit = auras_ranged_crit + tonumber(critFromAura)
									break
								end
							end
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["auras"].ranged_crit = auras_ranged_crit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		auras_ranged_crit = BCScache["auras"].ranged_crit
	end

	if class == "MAGE" then
		crit = crit + 3.2
	elseif class == "PRIEST" then
		crit = crit + 3
	elseif class == "WARLOCK" then
		crit = crit + 2
	end

	crit = crit + gear_ranged_crit + talents_ranged_crit + auras_ranged_crit

	return crit
end

function BCS:GetRangedCritChance()
	return BCS:GetUnitRangedCritChance("player")
end

function BCS:GetUnitSpellCritChance(unit)
	if unit == nil then unit = "player" end
	local Crit_Set_Bonus = {}
	local spell_crit = 0;
	local auras_spell_crit = 0;
	local gear_spell_crit = 0
	local talents_spell_crit = 0
	local _, intellect = UnitStat(unit, STAT_INTELLECT)
	local _, class = UnitClass(unit)
	
	-- values from vmangos core
	local playerLevel = UnitLevel(unit)
	if class == "MAGE" then
		spell_crit = 3.7 + intellect / (14.77 + .65 * playerLevel)
	elseif class == "WARLOCK" then
		spell_crit = 3.18 + intellect / (11.30 + .82 * playerLevel)
	elseif class == "PRIEST" then
		spell_crit = 2.97 + intellect / (10.03 + .82 * playerLevel)
	elseif class == "DRUID" then
		spell_crit = 3.33 + intellect / (12.41 + .79 * playerLevel)
	elseif class == "SHAMAN" then
		spell_crit = 3.54 + intellect / (11.51 + .8 * playerLevel)
	elseif class == "PALADIN" then
		spell_crit = 3.7 + intellect / (14.77 + .65 * playerLevel)
	end
	if BCS.needScanGear or unit ~= "player" then
		gear_spell_crit = 0
		--scan gear
		for slot=1, 19 do
			if BCS_Tooltip:SetInventoryItem(unit, slot) then
				local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
				if eqItemLink then
					BCS_Tooltip:ClearLines()
					BCS_Tooltip:SetHyperlink(eqItemLink)
				end
				local SET_NAME = nil
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _,_, value = strfind(text, L["Equip: Improves your chance to get a critical strike with spells by (%d)%%."])
						if value then
							gear_spell_crit = gear_spell_crit + tonumber(value)
						end

						_,_, value = strfind(text, setPattern)
						if value then
							SET_NAME = value
						end
						_, _, value = strfind(text, L["^Set: Improves your chance to get a critical strike with spells by (%d)%%."])
						if value and SET_NAME and not tContains(Crit_Set_Bonus, SET_NAME) then
							tinsert(Crit_Set_Bonus, SET_NAME)
							gear_spell_crit = gear_spell_crit + tonumber(value)
						end
						_,_, value = strfind(text, L["(%d)%% Spell Critical Strike"])
						if value then
							gear_spell_crit = gear_spell_crit + tonumber(value)
						end
					end
				end
			end
		end
		if BCS_Tooltip:SetInventoryItem(unit, UNITSLOT_MAIN_HAND) then
			for line=1, BCS_Tooltip:NumLines() do
				local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
				local text = left:GetText()
				if text then
					local found = strfind(text, L["^Brilliant Wizard Oil"])
					if found then
						gear_spell_crit = gear_spell_crit + 1
					end
				end
			end
		end
		if unit == "player" then
			BCScache["gear"].spell_crit = gear_spell_crit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		gear_spell_crit = BCScache["gear"].spell_crit
	end

	if BCS.needScanAuras and unit == "player" then
		-- buffs
		local _, _, crit_from_aura = BCS:GetPlayerAura(L["Chance for a critical hit with a spell increased by (%d+)%%."])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
		end
		_, _, crit_from_aura = BCS:GetPlayerAura(L["Moonkin Aura"])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + 3
			if BCS:GetPlayerAura(L["Moonkin Form"]) and BCS_Tooltip:SetInventoryItem(unit, UNITSLOT_RANGED) then
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						_, _, crit_from_aura = strfind(text, L["Equip: Increases the critical chance provided by Leader of the Pack and Moonkin Aura by (%d)%%."])
						if crit_from_aura  then
							auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
						end
					end
				end
			else
				--check if druid is shapeshifted and have Idol of the Moonfang equipped
				for i=1, GetNumPartyMembers() do
					local _, partyClass = UnitClass("party"..i)
					if partyClass == "DRUID" then
						if BCS_Tooltip:SetInventoryItem("party"..i, UNITSLOT_RANGED) then
							for line=1, BCS_Tooltip:NumLines() do
								local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
								local text = left:GetText()
								if text then
									_, _, crit_from_aura = strfind(text, L["Equip: Increases the critical chance provided by Leader of the Pack and Moonkin Aura by (%d)%%."])
									if crit_from_aura  then
										for buff = 1, 32 do
											if UnitBuff("party"..i, buff) and UnitBuff("party"..i, buff) == "Interface\\Icons\\Spell_Nature_ForceOfNature" then
												auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		crit_from_aura = BCS:GetPlayerAura(L["Inner Focus"])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + 25
		end
		-- Power of the Guardian
		_, _, crit_from_aura = BCS:GetPlayerAura(L["Increases spell critical chance by (%d)%%."])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
		end
		_, _, crit_from_aura = BCS:GetPlayerAura(L["Chance to get a critical strike with spells is increased by (%d+)%%"])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
		end
		_, _, crit_from_aura = BCS:GetPlayerAura(L["While active, target's critical hit chance with spells and attacks increases by 10%%."])--SoD spell? 23964
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + 10
		end
		_, _, crit_from_aura = BCS:GetPlayerAura(L["Increases chance for a melee, ranged, or spell critical by (%d+)%% and all attributes by %d+."])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
		end
		crit_from_aura = BCS:GetPlayerAura(L["Increases critical chance of spells by 10%%, melee and ranged by 5%% and grants 140 attack power. 120 minute duration."])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + 10
		end
		_, _, crit_from_aura = BCS:GetPlayerAura(L["Critical strike chance with spells and melee attacks increased by (%d+)%%."])
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit + tonumber(crit_from_aura)
		end
		-- debuffs
		_, _, _, crit_from_aura = BCS:GetPlayerAura(L["Melee critical-hit chance reduced by (%d+)%%.\r\nSpell critical-hit chance reduced by (%d+)%%."], 'HARMFUL')
		if crit_from_aura then
			auras_spell_crit = auras_spell_crit - tonumber(crit_from_aura)
		end
		if unit == "player" then
			BCScache["auras"].spell_crit = auras_spell_crit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		auras_spell_crit = BCScache["auras"].spell_crit
	end

	-- scan talents
	if BCS.needScanTalents and unit == "player" then
		talents_spell_crit = 0
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						-- Arcane Instability
						local _,_, value = strfind(text, L["Increases your spell damage and critical srike chance by (%d+)%%."])
						if value and rank > 0 then
							talents_spell_crit = talents_spell_crit + tonumber(value)
							break
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["talents"].spell_crit = talents_spell_crit
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		talents_spell_crit= BCScache["talents"].spell_crit
	end

	spell_crit = spell_crit + talents_spell_crit + gear_spell_crit + auras_spell_crit

	return spell_crit
end

function BCS:GetSpellCritChance()
	return BCS:GetUnitSpellCritChance("player")
end

function BCS:GetSpellCritFromClass(class)
	if not class then
		return 0, 0, 0, 0, 0, 0
	end

	if class == "PALADIN" then
		--scan talents
		if BCS.needScanTalents or BCS.needScanAuras then
			BCScache["talents"].paladin_holy_light = 0
			BCScache["talents"].paladin_flash = 0
			BCScache["talents"].paladin_shock = 0
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Holy Power
							local _,_, value = strfind(text, L["Increases the critical effect chance of your Holy Light and Flash of Light by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].paladin_holy_light = BCScache["talents"].paladin_holy_light + tonumber(value)
								BCScache["talents"].paladin_flash = BCScache["talents"].paladin_flash + tonumber(value)
								break
							end
							-- Divine Favor
							_,_, value = strfind(text, L["Improves your chance to get a critical strike with Holy Shock by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].paladin_shock = BCScache["talents"].paladin_shock + tonumber(value)
								break
							end
						end
					end
				end
			end
		end

		return BCScache["talents"].paladin_holy_light,
				BCScache["talents"].paladin_flash,
				BCScache["talents"].paladin_shock, 0, 0, 0

	elseif class == "DRUID" then
		--scan talents
		if BCS.needScanTalents then
			BCScache["talents"].druid_moonfire = 0
			BCScache["talents"].druid_regrowth = 0
			-- scan talents
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Improved Moonfire
							local _,_, value = strfind(text, L["Increases the damage and critical strike chance of your Moonfire spell by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].druid_moonfire = BCScache["talents"].druid_moonfire + tonumber(value)
								break
							end
							-- Improved Regrowth
							_,_, value = strfind(text, L["Increases the critical effect chance of your Regrowth spell by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].druid_regrowth = BCScache["talents"].druid_regrowth + tonumber(value)
								break
							end
						end
					end
				end
			end
		end

		return BCScache["talents"].druid_moonfire,
				BCScache["talents"].druid_regrowth, 0, 0, 0, 0

	elseif class == "WARLOCK" then
		--scan talents
		if BCS.needScanTalents then
			BCScache["talents"].warlock_destruction_spells = 0
			BCScache["talents"].warlock_searing_pain = 0
			-- scan talents
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Devastation
							local _,_, value = strfind(text, L["Increases the critical strike chance of your Destruction spells by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].warlock_destruction_spells = BCScache["talents"].warlock_destruction_spells + tonumber(value)
								BCScache["talents"].warlock_searing_pain = BCScache["talents"].warlock_searing_pain + tonumber(value)
								break
							end
							-- Improved Searing Pain
							_,_, value = strfind(text, L["Increases the critical strike chance of your Searing Pain spell by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].warlock_searing_pain = BCScache["talents"].warlock_searing_pain + tonumber(value)
								break
							end
						end
					end
				end
			end
		end

		return BCScache["talents"].warlock_destruction_spells,
				BCScache["talents"].warlock_searing_pain, 0, 0, 0, 0

	elseif class == "MAGE" then
		--scan talents
		if BCS.needScanTalents or BCS.needScanAuras then
			BCScache["talents"].mage_arcane_spells = 0
			BCScache["talents"].mage_fire_spells = 0
			BCScache["talents"].mage_fireblast = 0
			BCScache["talents"].mage_scorch = 0
			BCScache["talents"].mage_flamestrike = 0
			BCScache["talents"].mage_shatter = 0
			-- scan talents
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Arcane Impact
							local _,_, value = strfind(text, L["Increases the critical strike chance of your Arcane Explosion and Arcane Missiles spells by an additional (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].mage_arcane_spells = BCScache["talents"].mage_arcane_spells + tonumber(value)
								break
							end
							-- Incinerate
							_,_, value = strfind(text, L["Increases the critical strike chance of your Fire Blast and Scorch spells by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].mage_fireblast = BCScache["talents"].mage_fireblast + tonumber(value)
								BCScache["talents"].mage_scorch = BCScache["talents"].mage_scorch + tonumber(value)
								break
							end
							-- Improved Flamestrike
							_,_, value = strfind(text, L["Increases the critical strike chance of your Flamestrike spell by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].mage_flamestrike = BCScache["talents"].mage_flamestrike + tonumber(value)
								break
							end
							-- Critical Mass
							_,_, value = strfind(text, L["Increases the critical strike chance of your Fire spells by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].mage_fire_spells = BCScache["talents"].mage_fire_spells + tonumber(value)
								BCScache["talents"].mage_fireblast = BCScache["talents"].mage_fireblast + tonumber(value)
								BCScache["talents"].mage_flamestrike = BCScache["talents"].mage_flamestrike + tonumber(value)
								BCScache["talents"].mage_scorch = BCScache["talents"].mage_scorch + tonumber(value)
								break
							end
							-- Shatter
							_,_, value = strfind(text, L["Increases the critical strike chance of all your spells against frozen targets by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].mage_shatter = BCScache["talents"].mage_shatter + tonumber(value)
								break
							end
						end
					end
				end
			end
			-- Buffs
			local _, _, value = BCS:GetPlayerAura(L["Increases critical strike chance from Fire damage spells by (%d+)%%."])
			-- Combustion
			if value then
				BCScache["talents"].mage_fire_spells = BCScache["talents"].mage_fire_spells + tonumber(value)
				BCScache["talents"].mage_fireblast = BCScache["talents"].mage_fireblast + tonumber(value)
				BCScache["talents"].mage_flamestrike = BCScache["talents"].mage_flamestrike + tonumber(value)
				BCScache["talents"].mage_scorch = BCScache["talents"].mage_scorch + tonumber(value)
			end
		end

		return BCScache["talents"].mage_arcane_spells,
				BCScache["talents"].mage_fire_spells,
				BCScache["talents"].mage_fireblast,
				BCScache["talents"].mage_scorch,
				BCScache["talents"].mage_flamestrike,
				BCScache["talents"].mage_shatter

	elseif class == "PRIEST" then
		if BCS.needScanTalents then
			BCScache["talents"].priest_holy_spells = 0
			BCScache["talents"].priest_discipline_spells = 0
			BCScache["talents"].priest_offensive_spells = 0
			-- scan talents
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Divinity
							local _,_, value = strfind(text, L["Increases the critical effect chance of your Holy and Discipline spells by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].priest_holy_spells = BCScache["talents"].priest_holy_spells + tonumber(value)
								BCScache["talents"].priest_discipline_spells = BCScache["talents"].priest_discipline_spells + tonumber(value)
								break
							end
							-- Force of Will
							_,_, value = strfind(text, L["Increases your spell damage and the critical strike chance of your offensive spells by (%d+)%%"])
							if value and rank > 0 then
								BCScache["talents"].priest_offensive_spells = BCScache["talents"].priest_offensive_spells + tonumber(value)
								break
							end
						end
					end
				end
			end
		end
		-- scan gear
		if BCS.needScanGear then
			-- t1 set gives + 2% crit to holy and 25% to prayer of healing
			BCScache["gear"].priest_holy_spells = 0
			BCScache["gear"].priest_prayer = 0
			local Crit_Set_Bonus = {}
			for slot=1, 19 do
				if BCS_Tooltip:SetInventoryItem('player', slot) then
					local _, _, eqItemLink = strfind(GetInventoryItemLink('player', slot), "(item:%d+:%d+:%d+:%d+)")
					if eqItemLink then
						BCS_Tooltip:ClearLines()
						BCS_Tooltip:SetHyperlink(eqItemLink)
					end
					local SET_NAME = nil
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _,_, value = strfind(text, setPattern)
							if value then
								SET_NAME = value
							end
							_, _, value = strfind(text, L["^Set: Improves your chance to get a critical strike with Holy spells by (%d)%%."])
							if value and SET_NAME and not tContains(Crit_Set_Bonus, SET_NAME) then
								tinsert(Crit_Set_Bonus, SET_NAME)
								BCScache["gear"].priest_holy_spells = BCScache["gear"].priest_holy_spells + tonumber(value)
							end
							_, _, value = strfind(text, L["^Set: Increases your chance of a critical hit with Prayer of Healing by (%d+)%%."])
							if value and SET_NAME and not tContains(Crit_Set_Bonus, SET_NAME) then
								tinsert(Crit_Set_Bonus, SET_NAME)
								BCScache["gear"].priest_prayer = BCScache["gear"].priest_prayer + tonumber(value)
							end
						end
					end
				end
			end
		end

		local holySpells = BCScache["talents"].priest_holy_spells + BCScache["gear"].priest_holy_spells

		return holySpells,
				BCScache["talents"].priest_discipline_spells,
				BCScache["talents"].priest_offensive_spells,
				BCScache["gear"].priest_prayer, 0, 0

	elseif class == "SHAMAN" then
		if BCS.needScanTalents then
			BCScache["talents"].shaman_lightning_bolt = 0
			BCScache["talents"].shaman_chain_lightning = 0
			BCScache["talents"].shaman_lightning_shield = 0
			BCScache["talents"].shaman_firefrost_spells = 0
			BCScache["talents"].shaman_healing_spells = 0
			-- scan talents
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Call of Thunder
							local _,_, value = strfind(text, L["Increases the critical strike chance of your Lightning Bolt and Chain Lightning spells by an additional (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].shaman_lightning_bolt = BCScache["talents"].shaman_lightning_bolt + tonumber(value)
								BCScache["talents"].shaman_chain_lightning = BCScache["talents"].shaman_chain_lightning + tonumber(value)
								break
							end
							-- Tidal Mastery
							_,_, value = strfind(text, L["Increases the critical effect chance of your healing and lightning spells by (%d+)%%."])
							if value and rank > 0 then
								BCScache["talents"].shaman_lightning_bolt = BCScache["talents"].shaman_lightning_bolt + tonumber(value)
								BCScache["talents"].shaman_chain_lightning = BCScache["talents"].shaman_chain_lightning + tonumber(value)
								BCScache["talents"].shaman_lightning_shield = BCScache["talents"].shaman_lightning_shield + tonumber(value)
								BCScache["talents"].shaman_healing_spells = BCScache["talents"].shaman_healing_spells + tonumber(value)
								break
							end
						end
					end
				end
			end
		end
		-- buffs
		if BCS.needScanAuras then
			BCScache["auras"].shaman_lightning_bolt = 0
			BCScache["auras"].shaman_chain_lightning = 0
			BCScache["auras"].shaman_firefrost_spells = 0
			local hasAura = BCS:GetPlayerAura(L["Elemental Mastery"])
			if hasAura then
				BCScache["auras"].shaman_lightning_bolt = 100
				BCScache["auras"].shaman_chain_lightning = 100
				BCScache["auras"].shaman_firefrost_spells = 100
			end
		end

		local lightningBolt = BCScache["auras"].shaman_lightning_bolt + BCScache["talents"].shaman_lightning_bolt
		local chainLightning = BCScache["auras"].shaman_chain_lightning + BCScache["talents"].shaman_chain_lightning

		return lightningBolt, chainLightning,
				BCScache["talents"].shaman_lightning_shield,
				BCScache["auras"].shaman_firefrost_spells,
				BCScache["talents"].shaman_healing_spells, 0
	
	else
		return 0, 0, 0, 0, 0, 0
	end
end

function BCS:GetUnitSpellPower(unit, school)
	local imp_inner_fire = nil
	local spiritual_guidance = nil
	if school then
		if not tContains({"Arcane","Fire","Frost","Holy","Nature","Shadow"}, school) then
			if BCS.Debug then
				DEFAULT_CHAT_FRAME:AddMessage("Unknown spell type ["..nvl(school,"nil").."] sent to GetUnitSpellPower. Ignoring.")
			end
			return nil
		end
		local school_spell_power = 0;
		--scan gear
		if BCS.needScanGear or unit ~= "player" then
			for slot=1, 19 do
				if BCS_Tooltip:SetInventoryItem(unit, slot) then
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _,_, value = strfind(text, L["Equip: Increases damage done by "..school.." spells and effects by up to (%d+)."])
							if value then
								school_spell_power = school_spell_power + tonumber(value)
							end
							_,_, value = strfind(text, L[school.." Damage %+(%d+)"])
							if value then
								school_spell_power = school_spell_power + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) "..school.." Spell Damage"])
							if value then
								school_spell_power = school_spell_power + tonumber(value)
							end
						end
					end
				end
			end
			if unit == "player" then
				BCScache["gear"][string.lower(school)] = school_spell_power
			end
		elseif unit == "player" then -- We did not recalculate, so using cache
			school_spell_power = BCScache["gear"][string.lower(school)]
		end
		return school_spell_power
	else
		local total_spell_power = 0
		local total_spell_damage_only = 0
		local gear_spell_power = 0
		local gear_spell_damage_only = 0
		local auras_spell_power = 0
		local auras_spell_damage_only = 0
		local talents_spell_power = 0
		
		local gear_arcane = 0
		local gear_fire = 0
		local gear_frost = 0
		local gear_holy = 0
		local gear_nature = 0
		local gear_shadow = 0
		
		local SpellPower_Set_Bonus = {}
		if BCS.needScanGear or unit ~= "player" then
			-- scan gear
			for slot=1, 19 do
				if BCS_Tooltip:SetInventoryItem(unit, slot) then
					local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
					if eqItemLink then
						BCS_Tooltip:ClearLines()
						BCS_Tooltip:SetHyperlink(eqItemLink)
					end
					local SET_NAME
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							-- generic bonus on most gear
							local _,_, value = strfind(text, L["Equip: Increases damage and healing done by magical spells and effects by up to (%d+)."])
							if value then
								gear_spell_power = gear_spell_power + tonumber(value)
							end
							-- Spell Power (weapon/bracer enchant) apparently gives healing too
							-- Arcanum of Focus (Head/Legs enchant)
							-- Power of the Scourge (Shoulder enchant)
							_,_, value = strfind(text, L["Spell Damage %+(%d+)"])
							if value then
								gear_spell_power = gear_spell_power + tonumber(value)
							end
							-- Atiesh (druid/priest)
							_,_, value = strfind(text, L["Equip: Increases your spell damage by up to (%d+) and your healing by up to %d+."])
							if value then
								gear_spell_damage_only = gear_spell_damage_only + tonumber(value)
							end
							-- Zandalar Signet of Mojo (Shoulder enchant)
							_,_, value = strfind(text, L["^%+(%d+) Spell Damage and Healing"])
							if value then
								gear_spell_power = gear_spell_power + tonumber(value)
							end
							-- Enchanted Armor Kit (Leatherworking)
							_,_, value = strfind(text, L["^%+(%d+) Damage and Healing Spells"])
							if value then
								gear_spell_power = gear_spell_power + tonumber(value)
							end
							_,_, value = strfind(text, L["Equip: Increases damage done by Arcane spells and effects by up to (%d+)."])
							if value then
								gear_arcane = gear_arcane + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) Arcane Spell Damage"])
							if value then
								gear_arcane = gear_arcane + tonumber(value)
							end
							_,_, value = strfind(text, L["Arcane Damage %+(%d+)"])
							if value then
								gear_arcane = gear_arcane + tonumber(value)
							end

							_,_, value = strfind(text, L["Equip: Increases damage done by Fire spells and effects by up to (%d+)."])
							if value then
								gear_fire = gear_fire + tonumber(value)
							end
							_,_, value = strfind(text, L["Fire Damage %+(%d+)"])
							if value then
								gear_fire = gear_fire + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) Fire Spell Damage"])
							if value then
								gear_fire = gear_fire + tonumber(value)
							end
							
							_,_, value = strfind(text, L["Equip: Increases damage done by Frost spells and effects by up to (%d+)."])
							if value then
								gear_frost = gear_frost + tonumber(value)
							end
							_,_, value = strfind(text, L["Frost Damage %+(%d+)"])
							if value then
								gear_frost = gear_frost + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) Frost Spell Damage"])
							if value then
								gear_frost = gear_frost + tonumber(value)
							end
							
							_,_, value = strfind(text, L["Equip: Increases damage done by Holy spells and effects by up to (%d+)."])
							if value then
								gear_holy = gear_holy + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) Holy Spell Damage"])
							if value then
								gear_holy = gear_holy + tonumber(value)
							end
							
							_,_, value = strfind(text, L["Equip: Increases damage done by Nature spells and effects by up to (%d+)."])
							if value then
								gear_nature = gear_nature + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) Nature Spell Damage"])
							if value then
								gear_nature = gear_nature + tonumber(value)
							end
							_,_, value = strfind(text, L["Nature Damage %+(%d+)"])
							if value then
								gear_nature = gear_nature + tonumber(value)
							end

							_,_, value = strfind(text, L["Equip: Increases damage done by Shadow spells and effects by up to (%d+)."])
							if value then
								gear_shadow = gear_shadow + tonumber(value)
							end
							_,_, value = strfind(text, L["Shadow Damage %+(%d+)"])
							if value then
								gear_shadow = gear_shadow + tonumber(value)
							end
							_,_, value = strfind(text, L["^%+(%d+) Shadow Spell Damage"])
							if value then
								gear_shadow = gear_shadow + tonumber(value)
							end
							
							_,_, value = strfind(text, setPattern)
							if value then
								SET_NAME = value
							end

							_, _, value = strfind(text, L["^Set: Increases damage and healing done by magical spells and effects by up to (%d+)%."])
							if value and SET_NAME and not tContains(SpellPower_Set_Bonus, SET_NAME) then
								tinsert(SpellPower_Set_Bonus, SET_NAME)
								gear_spell_power = gear_spell_power + tonumber(value)
							end
						end
					end
				end
			end
			-- SetHyperLink doesnt show temporary enhancements, have to use SetInventoryItem
			if BCS_Tooltip:SetInventoryItem(unit, UNITSLOT_MAIN_HAND) then
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						-- apparently gives healing too
						local found = strfind(text, L["^Brilliant Wizard Oil"])
						if found then
							gear_spell_power = gear_spell_power + 36
							break
						end
						found = strfind(text, L["^Lesser Wizard Oil"])
						if found then
							gear_spell_power = gear_spell_power + 16
							break
						end
						found = strfind(text, L["^Minor Wizard Oil"])
						if found then
							gear_spell_power = gear_spell_power + 8
							break
						end
						found = strfind(text, L["^Wizard Oil"])
						if found then
							gear_spell_power = gear_spell_power + 24
							break
						end
					end
				end
			end
			if unit == "player" then
				BCScache["gear"].damage_and_healing = gear_spell_power
				BCScache["gear"].only_damage = gear_spell_damage_only
				BCScache["gear"].arcane =  gear_arcane
				BCScache["gear"].fire =    gear_fire
				BCScache["gear"].frost =   gear_frost
				BCScache["gear"].holy =    gear_holy
				BCScache["gear"].nature =  gear_nature
				BCScache["gear"].shadow =  gear_shadow
			end
		elseif unit == "player" then -- We did not recalculate, so using cache
			gear_spell_power = BCScache["gear"].damage_and_healing
			gear_spell_damage_only = BCScache["gear"].only_damage
			gear_arcane = BCScache["gear"].arcane 
			gear_fire = BCScache["gear"].fire
			gear_frost = BCScache["gear"].frost
			gear_holy = BCScache["gear"].holy
			gear_nature = BCScache["gear"].nature
			gear_shadow = BCScache["gear"].shadow
		end

		if BCS.needScanTalents and unit == "player" then
			imp_inner_fire = nil
			spiritual_guidance = nil
			-- scan talents
			for tab=1, GetNumTalentTabs() do
				for talent=1, GetNumTalents(tab) do
					BCS_Tooltip:SetTalent(tab, talent)
					for line=1, BCS_Tooltip:NumLines() do
						local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
						if text then
							local _, _, _, _, rank = GetTalentInfo(tab, talent)
							-- Priest
							-- Spiritual Guidance
							local _,_, value = strfind(text, L["Increases spell damage and healing by up to (%d+)%% of your total Spirit."])
							if value and rank > 0 then
								spiritual_guidance = tonumber(value)
								break
							end
							-- Improved Inner Fire
							_,_, value = strfind(text, L["Increases the effects of your Inner Fire spell by (%d+)%%."])
							if value and rank > 0 then
								imp_inner_fire = tonumber(value)
								break
							end
						end
					end
				end
			end

			if spiritual_guidance ~= nil then
				local _, spirit = UnitStat(unit, STAT_SPIRIT)
				talents_spell_power = talents_spell_power + floor(((spiritual_guidance / 100) * spirit))
			end
			
			if unit == "player" then
				BCScache["talents"].damage_and_healing = talents_spell_power
			end
		elseif unit == "player" then -- We did not recalculate, so using cache
			talents_spell_power = BCScache["talents"].damage_and_healing
		end
		
		if BCS.needScanAuras and unit == "player" then
			-- buffs
			local _, _, spellPowerFromAura = BCS:GetPlayerAura(L["Magical damage dealt is increased by up to (%d+)."])
			if spellPowerFromAura then
				auras_spell_damage_only = auras_spell_damage_only + tonumber(spellPowerFromAura)
			end
			_, _, spellPowerFromAura = BCS:GetPlayerAura(L["Increases damage and healing done by magical spells and effects by up to (%d+)."])
			if spellPowerFromAura then
				auras_spell_power = auras_spell_power + tonumber(spellPowerFromAura)
			end
			-- Dreamtonic/Arcane Elixir
			_, _, spellPowerFromAura = BCS:GetPlayerAura(L["Magical damage dealt by spells and abilities is increased by up to (%d+)"])
			if spellPowerFromAura then
				auras_spell_damage_only = auras_spell_damage_only + tonumber(spellPowerFromAura)
			end
			-- Dreamshard Elixir
			_, _, spellPowerFromAura = BCS:GetPlayerAura(L["Spell damage is increased by up to (%d+)"])
			if spellPowerFromAura then
				auras_spell_damage_only = auras_spell_damage_only + tonumber(spellPowerFromAura)
			end
			-- Flask of Supreme Power
			_, _, spellPowerFromAura = BCS:GetPlayerAura(L["Spell damage increased by up to (%d+)"])
			if spellPowerFromAura then
				auras_spell_damage_only = auras_spell_damage_only + tonumber(spellPowerFromAura)
			end
			-- Danonzo's Tel'Abim Delight
			_, _, spellPowerFromAura = BCS:GetPlayerAura(L["Spell Damage increased by (%d+)"])
			if spellPowerFromAura then
				auras_spell_damage_only = auras_spell_damage_only + tonumber(spellPowerFromAura)
			end
			--Inner Fire
			_, _, spellPowerFromAura = BCS:GetPlayerAura(L["Increased damage done by magical spells and effects by (%d+)."])
			if spellPowerFromAura then
				spellPowerFromAura = tonumber(spellPowerFromAura)
				if imp_inner_fire then
					spellPowerFromAura = floor((spellPowerFromAura * (imp_inner_fire/100)) + (spellPowerFromAura))
				end
				auras_spell_damage_only = auras_spell_damage_only + spellPowerFromAura
			end
			
			if unit == "player" then
				BCScache["auras"].damage_and_healing = auras_spell_power
				BCScache["auras"].only_damage = auras_spell_damage_only
			end

		elseif unit == "player" then -- We did not recalculate, so using cache
			auras_spell_power = BCScache["auras"].damage_and_healing
			auras_spell_damage_only = BCScache["auras"].only_damage
		end
		local secondaryPower = 0
		local secondaryPowerName = ""
	
		if gear_arcane > secondaryPower then
			secondaryPower = gear_arcane
			secondaryPowerName = L.SPELL_SCHOOL_ARCANE
		end
		if gear_fire > secondaryPower then
			secondaryPower = gear_fire
			secondaryPowerName = L.SPELL_SCHOOL_FIRE
		end
		if gear_frost > secondaryPower then
			secondaryPower = gear_frost
			secondaryPowerName = L.SPELL_SCHOOL_FROST
		end
		if gear_holy > secondaryPower then
			secondaryPower = gear_holy
			secondaryPowerName = L.SPELL_SCHOOL_HOLY
		end
		if gear_nature > secondaryPower then
			secondaryPower = gear_nature
			secondaryPowerName = L.SPELL_SCHOOL_NATURE
		end
		if gear_shadow > secondaryPower then
			secondaryPower = gear_shadow
			secondaryPowerName = L.SPELL_SCHOOL_SHADOW
		end

		-- Spell Power and Spell Damage are kept separate so that Spell Healing can be added to Spell Power as desired.
		total_spell_power = gear_spell_power + talents_spell_power + auras_spell_power
		total_spell_damage = auras_spell_damage_only + gear_spell_damage_only

		return total_spell_power, secondaryPower, secondaryPowerName, total_spell_damage
	end
end

function BCS:GetSpellPower(school)
	return BCS:GetUnitSpellPower("player", school)
end

--this is stuff that gives ONLY healing, we count stuff that gives both damage and healing in GetSpellPower
function BCS:GetUnitHealingPower(unit)
	local healPower = 0
	local auras_heal_power = 0
	local gear_heal_power = 0
	local talents_heal_power = 0
	local healPower_Set_Bonus = {}
	--talents
	if BCS.needScanTalents and unit == "player" then
		local ironClad = nil
		local toughness = nil
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						-- Paladin
						-- Ironclad
						local _,_, value = strfind(text, L["Increases your healing power by (%d+)%% of your Armor."])
						if value and rank > 0 then
							ironClad = tonumber(value)
							break
						end
						-- Paladin
						-- Toughness
						local _,_, value = strfind(text, L["Increases your armor value from items by (%d+)%%."])
						if value and rank > 0 then
							toughness = tonumber(value)
							break
						end
					end
				end
			end
		end

		if ironClad ~= nil then
			local base = UnitArmor(unit)
			local _, agility = UnitStat(unit, STAT_AGILITY)
			local armorFromGear = base - (agility * 2)
			-- Iron Clad is calculated on raw armor without toughness bonus, base armor includes the bonus
			if toughness ~= nil then
				armorFromGear = armorFromGear / (1 + toughness/100)
			end
			talents_heal_power = floor(((ironClad / 100) * armorFromGear))
		end

		if unit == "player" then
			BCScache["talents"].healing = talents_heal_power
		end

	elseif unit == "player" then
		talents_heal_power = BCScache["talents"].healing
	end

	if BCS.needScanGear or unit ~= "player" then
		--scan gear
		for slot=1, 19 do
			if BCS_Tooltip:SetInventoryItem(unit, slot) then
				local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
				if eqItemLink then
					BCS_Tooltip:ClearLines()
					BCS_Tooltip:SetHyperlink(eqItemLink)
				end
				local SET_NAME
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						-- Atiesh (party healing version); See https://www.wowhead.com/classic/item=22631/atiesh-greatstaff-of-the-guardian
						local _,_, value = strfind(text, "Equip: Increases healing done by magical spells and effects of all party members within 30 yards by up to (%d+).")
						if value then
							--gear_heal_power = gear_heal_power + tonumber(value)
						end
						local _,_, value = strfind(text, L["Equip: Increases healing done by spells and effects by up to (%d+)."])
						if value then
							gear_heal_power = gear_heal_power + tonumber(value)
						end
						-- Atiesh (druid/priest)
						_,_, value = strfind(text, L["Equip: Increases your spell damage by up to %d+ and your healing by up to (%d+)."])
						if value then
							gear_heal_power = gear_heal_power + tonumber(value)
						end
						-- Enchant Weapon/Gloves/Bracers - Healing Power
						_,_, value = strfind(text, L["Healing Spells %+(%d+)"])
						if value then
							gear_heal_power = gear_heal_power + tonumber(value)
						end
						-- Zandalar Signet of Serenity (Shoulder enchant)
						_,_, value = strfind(text, L["^%+(%d+) Healing Spells"])
						if value then
							gear_heal_power = gear_heal_power + tonumber(value)
						end
						-- Beautiful Diamond Gemstone (Jewelcrafting)
						-- Resilience of the Scourge (Shoulder enchant)
						_,_, value = strfind(text, L["Healing %+(%d+)"])
						if value then
							gear_heal_power = gear_heal_power + tonumber(value)
						end
						-- Enchanted Armor Kit (Leatherwotking)
						-- Arcanum of Focus (Head/Legs enchant)
						-- already included in GetSpellPower

						_,_, value = strfind(text, setPattern)
						if value then
							SET_NAME = value
						end
						_, _, value = strfind(text, L["^Set: Increases healing done by spells and effects by up to (%d+)%."])
						if value and SET_NAME and not tContains(healPower_Set_Bonus, SET_NAME) then
							tinsert(healPower_Set_Bonus, SET_NAME)
							gear_heal_power = gear_heal_power + tonumber(value)
						end
					end
				end
			end
		end
		-- SetHyperLink doesnt show temporary enhancements, have to use SetInventoryItem
		if BCS_Tooltip:SetInventoryItem(unit, UNITSLOT_MAIN_HAND) then
			for line=1, BCS_Tooltip:NumLines() do
				local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
				local text = left:GetText()
				if text then
					local found = strfind(text, L["^Brilliant Mana Oil"])
					if found then
						gear_heal_power = gear_heal_power + 25
					end
				end
			end
		end

		if unit == "player" then
			BCScache["gear"].healing = gear_heal_power
		end

	elseif unit == "player" then
		gear_heal_power = BCScache["gear"].healing
	end

	-- buffs
	local treebonus = nil
	if BCS.needScanAuras then
		local _, _, healPowerFromAura = BCS:GetPlayerAura(L["Healing done by magical spells is increased by up to (%d+)."])
		if healPowerFromAura then
			auras_heal_power = auras_heal_power + tonumber(healPowerFromAura)
		end
		--Tree of Life (own)
		local found = BCS:GetPlayerAura(L["Tree of Life Form"]) and BCS:GetPlayerAura(L["Tree of Life Aura"])
		local _, spirit = UnitStat("player", 5)
		if found then
			treebonus = spirit * 0.2
		end
		--Sweet Surprise
		_, _, healPowerFromAura = BCS:GetPlayerAura(L["Increases healing done by magical spells by up to (%d+) for 3600 sec."])
		if healPowerFromAura then
			auras_heal_power = auras_heal_power + tonumber(healPowerFromAura)
		end
		--Unstable Power
		_, _, healPowerFromAura = BCS:GetPlayerAura(L["Healing increased by up to (%d+)."])
		if healPowerFromAura then
			auras_heal_power = auras_heal_power + tonumber(healPowerFromAura)
		end
		--The Eye of the Dead
		_, _, healPowerFromAura = BCS:GetPlayerAura(L["Healing spells increased by up to (%d+)."])
		if healPowerFromAura then
			auras_heal_power = auras_heal_power + tonumber(healPowerFromAura)
		end
		--Power of the Guardian
		_, _, healPowerFromAura = BCS:GetPlayerAura(L["Increases healing done by magical spells and effects by up to (%d+)."])
		if healPowerFromAura then
			auras_heal_power = auras_heal_power + tonumber(healPowerFromAura)
		end
		--Dreamshard Elixir
		_, _, healPowerFromAura = BCS:GetPlayerAura(L["Healing done is increased by up to (%d+)"])
		if healPowerFromAura then
			auras_heal_power = auras_heal_power + tonumber(healPowerFromAura)
		end
		if unit == "player" then
			BCScache["auras"].healing = auras_heal_power
		end
	elseif unit == "player" then
		auras_heal_power = BCScache["auras"].healing
	end

	healPower = gear_heal_power + auras_heal_power + talents_heal_power

	return healPower, treebonus, talents_heal_power
end

function BCS:GetHealingPower()
	return BCS:GetUnitHealingPower("player")
end

function BCS:GetUnitRegenMPPerSpirit(unit)
	local addvalue = 0
	local _, spirit = UnitStat(unit, STAT_SPIRIT)
	local _, class = UnitClass(unit)

	if class == "DRUID" then
		addvalue = (spirit / 5 + 15)
	elseif class == "HUNTER" then
		addvalue = (spirit / 5 + 15)
	elseif class == "MAGE" then
		addvalue = (spirit / 4 + 12.5)
	elseif class == "PALADIN" then
		addvalue = (spirit / 5 + 15)
	elseif class == "PRIEST" then
		addvalue = (spirit / 4 + 12.5)
	elseif class == "SHAMAN" then
		addvalue = (spirit / 5 + 17)
	elseif class == "WARLOCK" then
		addvalue = (spirit / 5 + 15)
	end

	return addvalue
end

local function GetRegenMPPerSpirit()
	return BCS:GetUnitRegenMPPerSpirit("player")
end

function BCS:GetUnitManaRegen(unit)
	local waterShield = nil
	local base = BCS:GetUnitRegenMPPerSpirit(unit)
	local casting = 0
	local mp5 = 0
	local auras_mp5 = 0
	local gear_mp5 = 0
	local auras_casting = 0
	local gear_casting = 0
	local talents_casting = 0
	local mp5_Set_Bonus = {}

	if BCS.needScanTalents and unit == "player" then
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						-- Priest (Meditation) / Druid (Reflection) / Mage (Arcane Meditation) / Shaman (Improved Water Shield)
						local _,_, value = strfind(text, L["Allows (%d+)%% of your Mana regeneration to continue while casting."])
						if value and rank > 0 then
							talents_casting = talents_casting + tonumber(value)
							waterShield = rank
							break
						end
					end
				end
			end
		end
		if unit == "player" then
			BCScache["talents"].casting = talents_casting
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		talents_casting = BCScache["talents"].casting
	end

	if BCS.needScanGear or unit ~= "player" then
		--scan gear
		for slot=1, 19 do
			if BCS_Tooltip:SetInventoryItem(unit, slot) then
				local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
				if eqItemLink then
					BCS_Tooltip:ClearLines()
					BCS_Tooltip:SetHyperlink(eqItemLink)
				end
				local SET_NAME
				for line=1, BCS_Tooltip:NumLines() do
					local text = getglobal(BCS_Prefix .. "TextLeft" .. line):GetText()
					if text then
						local _,_, value = strfind(text, L["^Mana Regen %+(%d+)"])
						if value then
							gear_mp5 = gear_mp5 + tonumber(value)
						end
						_,_, value = strfind(text, L["Equip: Restores (%d+) mana per 5 sec."])
						if value and not strfind(text, L["to all party members"]) then
							gear_mp5 = gear_mp5 + tonumber(value)
						end
						_,_, value = strfind(text, L["^Healing %+%d+ and (%d+) mana per 5 sec."])
						if value then
							gear_mp5 = gear_mp5 + tonumber(value)
						end
						_,_, value = strfind(text, L["^%+(%d+) mana every 5 sec."])
						if value then
							gear_mp5 = gear_mp5 + tonumber(value)
						end
						_,_, value = strfind(text, L["^Equip: Allows (%d+)%% of your Mana regeneration to continue while casting."])
						if value then
							gear_casting = gear_casting + tonumber(value)
						end

						_,_, value = strfind(text, setPattern)
						if value then
							SET_NAME = value
						end
						_,_, value = strfind(text, L["^Set: Allows (%d+)%% of your Mana regeneration to continue while casting."])
						if value and SET_NAME and not tContains(mp5_Set_Bonus, SET_NAME) then
							tinsert(mp5_Set_Bonus, SET_NAME)
							gear_casting = gear_casting + tonumber(value)
						end
						_,_, value = strfind(text, L["^Set: Restores (%d+) mana per 5 sec."])
						if value and SET_NAME and not tContains(mp5_Set_Bonus, SET_NAME) then
							tinsert(mp5_Set_Bonus, SET_NAME)
							gear_mp5 = gear_mp5 + tonumber(value)
						end
					end
				end
			end
		end
		-- SetHyperLink doesnt show temporary enhancements, have to use SetInventoryItem
		if BCS_Tooltip:SetInventoryItem(unit, UNITSLOT_MAIN_HAND) then
			for line=1, BCS_Tooltip:NumLines() do
				local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
				local text = left:GetText()
				if text then
					local found = strfind(text, L["^Brilliant Mana Oil"])
					if found then
						gear_mp5 = gear_mp5 + 12
					end
					found = strfind(text, L["^Lesser Mana Oil"])
					if found then
						gear_mp5 = gear_mp5 + 8
					end
					found = strfind(text, L["^Minor Mana Oil"])
					if found then
						gear_mp5 = gear_mp5 + 4
					end
				end
			end
		end
		if unit == "player" then
			BCScache["gear"].mp5 = gear_mp5
			BCScache["gear"].casting = gear_casting
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		gear_mp5= BCScache["gear"].mp5
		gear_casting= BCScache["gear"].casting
	end

	-- buffs
	if BCS.needScanAuras and unit == "player" then
		-- improved Shadowform
		for tab=1, GetNumSpellTabs() do
			local _, _, offset, numSpells = GetSpellTabInfo(tab);
			for s = offset + 1, offset + numSpells do
			local spell = GetSpellName(s, BOOKTYPE_SPELL);
				if spell == L["Improved Shadowform"] and BCS:GetPlayerAura(L["Shadowform"]) then
					auras_casting = auras_casting + 15
				end
			end
		end
		-- Warchief's Blessing
		local _, _, mp5FromAura = BCS:GetPlayerAura(L["Increases hitpoints by 300. 15%% haste to melee attacks. (%d+) mana regen every 5 seconds."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + 10
		end
		--Epiphany
		_, _, mp5FromAura = BCS:GetPlayerAura(L["Restores (%d+) mana per 5 sec."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + tonumber(mp5FromAura)
		end
		--Nightfin Soup
		_, _, mp5FromAura = BCS:GetPlayerAura(L["Regenerating (%d+) Mana every 5 seconds."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + tonumber(mp5FromAura)*2.5 -- had to double the mp5FromAura because the item is a true mp5 tick
		end
		--Mageblood Potion
		_, _, mp5FromAura = BCS:GetPlayerAura(L["Regenerate (%d+) mana per 5 sec."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + tonumber(mp5FromAura)
		end
		--Fizzy Energy Drink and Sagefin
		_, _, mp5FromAura = BCS:GetPlayerAura(L["Mana Regeneration increased by (%d+) every 5 seconds."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + tonumber(mp5FromAura)*2.5
		end
		--Second Wind
		_, _, mp5FromAura = BCS:GetPlayerAura(L["Restores (%d+) mana every 1 sec."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + tonumber(mp5FromAura)*5 -- had to multiply by 5 the mp5FromAura because the item is a sec per tick
		end
		--Power of the Guardian
		_, _, mp5FromAura = BCS:GetPlayerAura(L["Restores (%d+) mana per 5 seconds."])
		if mp5FromAura then
			auras_mp5 = auras_mp5 + tonumber(mp5FromAura)
		end
		--Aura of the blue dragon
		local _, _, castingFromAura = BCS:GetPlayerAura(L["(%d+)%% of your Mana regeneration continuing while casting."])
		if castingFromAura then
			auras_casting = auras_casting + tonumber(castingFromAura)
		end
		--Mage Armor
		_, _, castingFromAura = BCS:GetPlayerAura(L["(%d+)%% of your mana regeneration to continue while casting."])
		if castingFromAura then
			auras_casting = auras_casting + tonumber(castingFromAura)
		end
		--Sylvan Blessing
		_, _, castingFromAura = BCS:GetPlayerAura(L["Allows (%d+)%% of mana regeneration while casting."])
		if castingFromAura then
			auras_casting = auras_casting + tonumber(castingFromAura)
		end
		--Improved Water Shield
		if waterShield ~= nil then
			for i = 1, 32 do
				local icon, stacks = UnitBuff(unit, i)
				if icon and stacks and icon == "Interface\\Icons\\Ability_Shaman_WaterShield" then
					auras_casting = auras_casting + (tonumber(stacks) * waterShield)
				end
			end
		end
		--Innervate
		local value
		_, _, value, castingFromAura = BCS:GetPlayerAura(L["Mana regeneration increased by (%d+)%%.  (%d+)%% Mana regeneration may continue while casting."])
		if castingFromAura then
			base = base + (base * (tonumber(value) / 100))
			auras_casting = auras_casting + tonumber(castingFromAura)
		end

		if unit == "player" then
			BCScache["auras"].mp5 = auras_mp5
			BCScache["auras"].casting = auras_casting
		end
	elseif unit == "player" then -- We did not recalculate, so using cache
		auras_mp5 = BCScache["auras"].mp5
		auras_casting = BCScache["auras"].casting
	end

	casting = auras_casting + talents_casting + gear_casting
	mp5 = auras_mp5 + gear_mp5

	-- Human racial
	local _, race = UnitRace(unit)
	if race == "Human" then
		casting = casting + 5
	end

	if casting > 100 then
		casting = 100
	end

	return base, casting, mp5
end

function BCS:GetManaRegen()
	return BCS:GetUnitManaRegen("player")
end

--Weapon Skill code adapted from https://github.com/pepopo978/BetterCharacterStats
function BCS:GetWeaponSkill(skillName) -- Player only
	-- loop through skills
	local skillIndex = 1
	while true do
		local name, _, _, skillRank, _, skillModifier = GetSkillLineInfo(skillIndex)
		if not name then
			return 0
		end

		if name == skillName then
			return skillRank + skillModifier
		end

		skillIndex = skillIndex + 1
	end
end

function BCS:GetWeaponSkillForWeaponType(weaponType) -- Player only
	if weaponType == "Daggers" then
		return BCS:GetWeaponSkill("Daggers")
	elseif weaponType == "One-Handed Swords" then
		return BCS:GetWeaponSkill("Swords")
	elseif weaponType == "Two-Handed Swords" then
		return BCS:GetWeaponSkill("Two-Handed Swords")
	elseif weaponType == "One-Handed Axes" then
		return BCS:GetWeaponSkill("Axes")
	elseif weaponType == "Two-Handed Axes" then
		return BCS:GetWeaponSkill("Two-Handed Axes")
	elseif weaponType == "One-Handed Maces" then
		return BCS:GetWeaponSkill("Maces")
	elseif weaponType == "Two-Handed Maces" then
		return BCS:GetWeaponSkill("Two-Handed Maces")
	elseif weaponType == "Staves" then
		return BCS:GetWeaponSkill("Staves")
	elseif weaponType == "Polearms" then
		return BCS:GetWeaponSkill("Polearms")
	elseif weaponType == "Fist Weapons" then
		return BCS:GetWeaponSkill("Unarmed")
	elseif weaponType == "Bows" then
		return BCS:GetWeaponSkill("Bows")
	elseif weaponType == "Crossbows" then
		return BCS:GetWeaponSkill("Crossbows")
	elseif weaponType == "Guns" then
		return BCS:GetWeaponSkill("Guns")
	elseif weaponType == "Thrown" then
		return BCS:GetWeaponSkill("Thrown")
	elseif weaponType == "Wands" then
		return BCS:GetWeaponSkill("Wands")
	end
	-- no weapon equipped
	return BCS:GetWeaponSkill("Unarmed")
end

function BCS:GetItemTypeForSlot(slot) -- Player only
	local _, _, id = string.find(GetInventoryItemLink("player", GetInventorySlotInfo(slot)) or "", "(item:%d+:%d+:%d+:%d+)");
	if not id then
		return
	end

	local _, _, _, _, _, itemType = GetItemInfo(id);

	return itemType
end

function BCS:GetMHWeaponSkill() -- Player only
	if not BCS.needScanSkills then
		return BCScache["skills"].mh
	end
	local itemType = BCS:GetItemTypeForSlot("MainHandSlot")
	BCScache["skills"].mh = BCS:GetWeaponSkillForWeaponType(itemType)

	return BCScache["skills"].mh
end

function BCS:GetOHWeaponSkill() -- Player only
	if not BCS.needScanSkills then
		return BCScache["skills"].oh
	end

	local itemType = BCS:GetItemTypeForSlot("SecondaryHandSlot")
	BCScache["skills"].oh = BCS:GetWeaponSkillForWeaponType(itemType)

	return BCScache["skills"].oh
end

function BCS:GetRangedWeaponSkill() -- Player only
	if not BCS.needScanSkills then
		return BCScache["skills"].ranged
	end

	local itemType = BCS:GetItemTypeForSlot("RangedSlot")
	BCScache["skills"].ranged = BCS:GetWeaponSkillForWeaponType(itemType)

	return BCScache["skills"].ranged
end

--https://us.forums.blizzard.com/en/wow/t/block-value-formula/283718/18
function BCS:GetUnitBlockValue(unit)
	local blockValue = 0
	local _, strength = UnitStat(unit, STAT_STRENGTH)
	local mod = 0
	-- scan gear
	for slot=1, 19 do
		if BCS_Tooltip:SetInventoryItem(unit, slot) then
			local _, _, eqItemLink = strfind(GetInventoryItemLink(unit, slot), "(item:%d+:%d+:%d+:%d+)")
			if eqItemLink then
				BCS_Tooltip:ClearLines()
				BCS_Tooltip:SetHyperlink(eqItemLink)
			end
			for line=1, BCS_Tooltip:NumLines() do
				local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
				local text = left:GetText()
				if text then
					local _,_, value = strfind(text, L["(%d+) Block"])
					if value then
						blockValue = blockValue + tonumber(value)
					end
					_,_, value = strfind(text, L["Equip: Increases the block value of your shield by (%d+)."])
					if value then
						blockValue = blockValue + tonumber(value)
					end
					_,_, value = strfind(text, L["Block Value %+(%d+)"])
					if value then
						blockValue = blockValue + tonumber(value)
					end
				end
			end
		end
	end
	if unit == "player" then
		local enhancingTotems = nil
		-- scan talents
		for tab=1, GetNumTalentTabs() do
			for talent=1, GetNumTalents(tab) do
				BCS_Tooltip:SetTalent(tab, talent)
				for line=1, BCS_Tooltip:NumLines() do
					local left = getglobal(BCS_Prefix .. "TextLeft" .. line)
					local text = left:GetText()
					if text then
						local _, _, _, _, rank = GetTalentInfo(tab, talent)
						--warrior/paladin
						local _,_, value = strfind(text, L["amount of damage absorbed by your shield by (%d+)%%"])
						if value and rank > 0 then
							mod = mod + tonumber(value)
							break
						end
						--shaman
						--shield specialization
						_,_, value = strfind(text, L["increases the amount blocked by (%d+)%%"])
						if value and rank > 0 then
							mod = mod + tonumber(value)
							break
						end
						--enhancing totems
						_,_, value = strfind(text, L["increases block amount by (%d+)%%"])
						if value and rank > 0 then
							enhancingTotems = tonumber(value)
							break
						end
					end
				end
			end
		end
		-- buffs
		--Glyph of Deflection
		local _, _, value = BCS:GetPlayerAura(L["Block value increased by (%d+)."])
		if value then
			blockValue = blockValue + tonumber(value)
		end
		if enhancingTotems and BCS:GetPlayerAura(L["^Stoneskin$"]) then
			mod = mod + enhancingTotems
		end
	end

	mod = mod/100
	blockValue = blockValue + (strength/20 - 1)
	blockValue = floor(blockValue + blockValue * mod)

	if blockValue < 0 then blockValue = 0 end

	return blockValue
end

function BCS:GetBlockValue()
	return BCS:GetUnitBlockValue("player")
end

function BCS:GetMissChanceRaw(wepSkill) -- player only
	local _, ver = pcall(GetBuildInfo)
	local diff = wepSkill - 315
	local miss = 5
	local hitChance = BCS:GetUnitHitRating("player")

	if IsPlayingOnTurtleWoW() then
		miss = miss - (diff * 0.2) - hitChance
	else
		if diff < -10 then
			miss = miss - diff * 0.2;
		else
			miss = miss - diff * 0.1;
		end

		-- if skill diff < -10 then subtract one from +hit, if there is any +hit
		if (diff < -10) and (hitChance > 0) then
			hitChance = hitChance - 1
		end
		miss = miss - hitChance
	end
	return miss
end

function BCS:GetMissChance(wepSkill) -- player only
	return max(0, min(BCS:GetMissChanceRaw(wepSkill), 60))
end

function BCS:GetDualWieldMissChance(wepSkill) -- player only
	return max(0, min(BCS:GetMissChanceRaw(wepSkill) + 19, 60))
end

function BCS:GetGlanceChance(wepSkill) -- player only
	return 10 + 15 * 2;
end

function BCS:GetGlanceReduction(wepSkill) -- player only
	if IsPlayingOnTurtleWoW() then
		return 65 + (wepSkill - 300) * 2
	else
		local diff = 315 - wepSkill;
		local low = math.max(math.min(1.3 - 0.05 * diff, 0.91), 0.01);
		local high = math.max(math.min(1.2 - 0.03 * diff, 0.99), 0.2);
		return 100 * ((high - low) / 2 + low);
	end
end

function BCS:GetDodgeChance(wepSkill) -- player only
	return math.max(5 + (315 - wepSkill) * 0.1, 0)
end

function BCS:GetDualWieldCritCap(wepSkill) -- player only
	local cap = 100 - self:GetDualWieldMissChance(wepSkill) - self:GetGlanceChance(wepSkill) - self:GetDodgeChance(wepSkill);
	if (cap > 100) then
		cap = 100;
	end
	if (cap < 0) then
		cap = 0;
	end
	return cap;
end

function BCS:GetCritCap(wepSkill) -- player only
	local cap = 100 - self:GetMissChance(wepSkill) - self:GetGlanceChance(wepSkill) - self:GetDodgeChance(wepSkill);
	if (cap > 100) then
		cap = 100;
	end
	if (cap < 0) then
		cap = 0;
	end
	return cap;
end

function BCS:GetEffectiveBlockChance(leveldiff) -- player only
	local block = GetBlockChance() - ((5 * leveldiff) * 0.04)
	if block < 0 then
		block = 0
	end
	return block
end

function BCS:GetEffectiveParryChance(leveldiff) -- player only
	local parry = GetParryChance() - ((5 * leveldiff) * 0.04)
	if parry < 0 then
		parry = 0
	end
	return parry
end

function BCS:GetEffectiveDodgeChance(leveldiff) -- player only
	local dodge = GetDodgeChance(unit) - ((5 * leveldiff) * 0.04)
	if dodge < 0 then
		dodge = 0
	end
	return dodge
end
