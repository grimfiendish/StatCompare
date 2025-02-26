--BCSStatCompareLib
-- BetterCharacterStats has active development in 2025 on it and StatCompare is from 2007
-- so I modified BetterCharacterStats to be used as a stat library other addons could use.
-- This file translates BCS data into the StatCompare UI


-- TODO - add BCS into this directory and import helper first. 
-- TODO - test that helper works as expected (maybe add a flag, like "BCS.SupportsTargetStats"?)
-- TODO - * Real BCS:helper does not exist ---> use our BCS:helper
-- TODO - * Real BCS:helper exists but is old ---> use our BCS:helper
-- TODO - * Real BCS:helper exists and is same as ours ---> use Real BCS:helper
-- TODO - * Real BCS:helper exists and is newer than ours ---> use Real BCS:helper
-- TODO - * Real BCS:helper exists, is new, and ours doesn't exist for whatever reason ---> use Real BCS:helper
-- TODO - * Real BCS:helper exists, is old, and ours doesn't exist for whatever reason ---> panic

BCSLib = BCSLib or {}
BCS = BCS or {}

BCS_MIN_VERSION = "1.13.0"

local function nvl(value, default)
    return value ~= nil and value or default
end
local function nvls(value, default)
    return value ~= nil and tostring(value) or default or ""
end
local function nvld(value, default)
    return value ~= nil and tonumber(value) or default or 0
end

local function GetUnitSpellPower(unit)
	return BCS:GetUnitSpellPower(unit)
end
local function GetUnitSpellPowerArcane(unit)
	return BCS:GetUnitSpellPower(unit, "Arcane")
end
local function GetUnitSpellPowerFire(unit)
	return BCS:GetUnitSpellPower(unit, "Fire")
end
local function GetUnitSpellPowerFrost(unit)
	return BCS:GetUnitSpellPower(unit, "Frost")
end
local function GetUnitSpellPowerHoly(unit)
	return BCS:GetUnitSpellPower(unit, "Holy")
end
local function GetUnitSpellPowerNature(unit)
	return BCS:GetUnitSpellPower(unit, "Nature")
end
local function GetUnitSpellPowerShadow(unit)
	return BCS:GetUnitSpellPower(unit, "Shadow")
end
local function GetUnitBlockValue(unit)
	return BCS:GetUnitBlockValue(unit)
end
local function GetUnitRangedCritChance(unit)
	return BCS:GetUnitRangedCritChance(unit)
end
local function GetUnitRangedHitRating(unit)
	return BCS:GetUnitRangedHitRating(unit)
end
local function GetUnitHealingPower(unit)
	local spellpower = BCS:GetUnitSpellPower(unit)
	local healingpower = BCS:GetUnitHealingPower(unit)
	return spellpower + healingpower
end
local function GetUnitSpellCritChance(unit)
	return BCS:GetUnitSpellCritChance(unit)
end
local function GetUnitCritChance(unit)
	if unit == "player" then
		return BCS:GetCritChance() -- This is super weird. Why doesn't it look at gear? For now this only looks at spellbook so useless for targets...
	end
	return "TODO?"
end
local function GetUnitSpellHitRating(unit)
	local base_spell_hit, spell_hit_fire, spell_hit_frost, spell_hit_arcane, spell_hit_shadow, spell_hit_holy = BCS:GetUnitSpellHitRating(unit)
	local total_hit = nvld(base_spell_hit) + nvld(spell_hit_fire) + nvld(spell_hit_frost) + nvld(spell_hit_arcane) + nvld(spell_hit_shadow) + nvld(spell_hit_holy)
	local retval = format("%d%%", nvld(base_spell_hit))
	
	fmt="%s: %d%%"
	
	if base_spell_hit ~= total_hit then 
		retval = retval .. StatComparePaintText("X","( ")
	end
	if nvld(spell_hit_arcane) > 0 then
		retval = retval.." "..StatComparePaintText("A",format(fmt, STATCOMPARE_ARCANE_SHORT, base_spell_hit + spell_hit_arcane))
	end
	if nvld(spell_hit_fire) > 0 then
		retval = retval.." "..StatComparePaintText("I",format(fmt, STATCOMPARE_FIRE_SHORT, base_spell_hit + spell_hit_fire))
	end
	if nvld(spell_hit_frost) > 0 then
		retval = retval.." "..StatComparePaintText("F",format(fmt, STATCOMPARE_FROST_SHORT, base_spell_hit + spell_hit_frost))
	end
	if nvld(spell_hit_holy) > 0 then
		retval = retval.." "..StatComparePaintText("H",format(fmt, STATCOMPARE_HOLY_SHORT, base_spell_hit + spell_hit_holy))
	end
	if nvld(spell_hit_shadow) > 0 then
		retval = retval.." "..StatComparePaintText("S",format(fmt, STATCOMPARE_SHADOW_SHORT, base_spell_hit + spell_hit_shadow))
	end
	if base_spell_hit ~= total_hit then
		retval = retval .. StatComparePaintText("X"," )")
	end
	return retval
end
local function GetUnitManaRegen(unit)
	return BCS:GetUnitManaRegen(unit)
end
local function GetUnitRegenMPPerSpirit(unit)
	return BCS:GetUnitRegenMPPerSpirit(unit)
end

local STATCOMPARE_EFFECTS = {
	{ effect = "STR"							},
	{ effect = "AGI"							},
	{ effect = "STA"							},
	{ effect = "INT"							},
	{ effect = "SPI"							},
	{ effect = "ARMOR"							},
	{ effect = "ENARMOR"						},
	{ effect = "DAMAGEREDUCE"					},

	{ effect = "ARCANERES"						},
	{ effect = "FIRERES"						},
	{ effect = "NATURERES"						},
	{ effect = "FROSTRES"						},
	{ effect = "SHADOWRES"						},
	{ effect = "DETARRES"						},
	{ effect = "ALLRES"							},

	{ effect = "DEFENSE"						},
	{ effect = "STEALTH"						},
	{ effect = "MINING"							},
	{ effect = "HERBALISM"						},
	{ effect = "SKINNING"						},
	{ effect = "FISHING"						},

	{ effect = "ATTACKPOWER"					},
	{ effect = "BEARAP"							},
	{ effect = "CATAP"							},
	{ effect = "ATTACKPOWERUNDEAD"				},
	{ effect = "CRIT",					callback = GetUnitCritChance		},
	{ effect = "BLOCK",					callback = GetUnitBlockValue				},
	{ effect = "TOBLOCK"						},
	{ effect = "DODGE"							},
	{ effect = "PARRY"							},
	{ effect = "TOHIT"							},
	{ effect = "RANGEDATTACKPOWER"				},
	{ effect = "RANGEDCRIT",			callback = GetUnitRangedCritChance			},
	{ effect = "RANGEDHIT",				callback = GetUnitRangedHitRating			},

	{ effect = "DMG",					callback = GetUnitSpellPower --[[ really? "DMG" is... SPELL dmg? or is it reused? --]]		},
	{ effect = "DMGUNDEAD"						},
	{ effect = "HEAL",					callback = GetUnitHealingPower				},
	{ effect = "FLASHHOLYLIGHTHEAL"				},
	{ effect = "LESSERHEALWAVE"					},
	{ effect = "CHAINLIGHTNING"					},
	{ effect = "EARTHSHOCK"						},
	{ effect = "FLAMESHOCK"						},
	{ effect = "FROSTSHOCK"						},
	{ effect = "LIGHTNINGBOLT"					},
	{ effect = "NATURECRIT"						},
	{ effect = "HOLYCRIT"						},
	{ effect = "SPELLCRIT",				callback = GetUnitSpellCritChance			},
	{ effect = "SPELLTOHIT",			callback = GetUnitSpellHitRating			},
	{ effect = "ARCANEDMG",				callback = GetUnitSpellPowerArcane			},
	{ effect = "FIREDMG",				callback = GetUnitSpellPowerFire			},
	{ effect = "FROSTDMG",				callback = GetUnitSpellPowerFrost			},
	{ effect = "HOLYDMG",				callback = GetUnitSpellPowerHoly			},
	{ effect = "NATUREDMG",				callback = GetUnitSpellPowerNature			},
	{ effect = "SHADOWDMG",				callback = GetUnitSpellPowerShadow			},

	{ effect = "HEALTH"							},
	{ effect = "HEALTHREG"						},
	{ effect = "MANA"							},
	{ effect = "MANAREG",				callback = GetUnitManaRegen					},
	{ effect = "MANAREGSPI",			callback = GetUnitRegenMPPerSpirit			},

	{ effect = "MANAREGCOMBAT"					}
};

function BCSLib:StatHasCallback(stat)
	if BCS and BCS.BCS_SUPPORTS_TARGET and STATCOMPARE_EFFECTS then return true else return false end
end

function BCSLib:GetStat(stat, unit)
	if BCS and BCS.BCS_SUPPORTS_TARGET and STATCOMPARE_EFFECTS then 
		for i,e in pairs(STATCOMPARE_EFFECTS) do
			if e.effect == stat and e["callback"] ~= nil then
				return e.callback(unit)
			end
		end
	end
	return nil
end

-- /script print(BCS:GetUnitSpellPower("target","Arcane"))
-- /script print(BCS:GetUnitSpellPower("target"))
-- /script print(BCS:GetUnitManaRegen("target"))