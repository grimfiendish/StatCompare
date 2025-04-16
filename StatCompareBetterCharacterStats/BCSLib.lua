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
	return value ~= nil and tostring(value) or (default ~= nil and default or "")
end
local function nvld(value, default)
	return value ~= nil and tonumber(value) or (default ~= nil and default or 0)
end

local function GetUnitSpellPower(unit)
	local base_spell_power = nvld(BCS:GetUnitSpellPower(unit))
	local spell_power_arcane = nvld(BCS:GetUnitSpellPower(unit, "Arcane"))
	local spell_power_fire   = nvld(BCS:GetUnitSpellPower(unit, "Fire"))
	local spell_power_frost  = nvld(BCS:GetUnitSpellPower(unit, "Frost"))
	local spell_power_holy   = nvld(BCS:GetUnitSpellPower(unit, "Holy"))
	local spell_power_nature = nvld(BCS:GetUnitSpellPower(unit, "Nature"))
	local spell_power_shadow = nvld(BCS:GetUnitSpellPower(unit, "Shadow"))
	
	local has_school_power = (spell_power_arcane>0 or spell_power_fire>0 or spell_power_frost>0 or spell_power_holy>0 or spell_power_nature>0 or spell_power_shadow>0) and true or false
	
	local retval = base_spell_power

	fmt="%s: %d"

	if has_school_power then
		retval = retval .. StatComparePaintText("X"," (")
	end
	if nvld(spell_power_arcane) > 0 then
		retval = retval.." "..StatComparePaintText("A",format(fmt, STATCOMPARE_ARCANE_SHORT, base_spell_power + spell_power_arcane))
	end
	if nvld(spell_power_fire) > 0 then
		retval = retval.." "..StatComparePaintText("I",format(fmt, STATCOMPARE_FIRE_SHORT, base_spell_power + spell_power_fire))
	end
	if nvld(spell_power_frost) > 0 then
		retval = retval.." "..StatComparePaintText("F",format(fmt, STATCOMPARE_FROST_SHORT, base_spell_power + spell_power_frost))
	end
	if nvld(spell_power_holy) > 0 then
		retval = retval.." "..StatComparePaintText("H",format(fmt, STATCOMPARE_HOLY_SHORT, base_spell_power + spell_power_holy))
	end
	if nvld(spell_power_nature) > 0 then
		retval = retval.." "..StatComparePaintText("N",format(fmt, STATCOMPARE_NATURE_SHORT, base_spell_power + spell_power_nature))
	end
	if nvld(spell_power_shadow) > 0 then
		retval = retval.." "..StatComparePaintText("S",format(fmt, STATCOMPARE_SHADOW_SHORT, base_spell_power + spell_power_shadow))
	end
	if has_school_power then
		retval = retval .. StatComparePaintText("X"," )")
	end
	return retval and retval or nil
	
	
end
local function GetUnitSpellPowerArcane(unit)
	return nil -- Moved this to one line of output via GetUnitSpellPower()
end
local function GetUnitSpellPowerFire(unit)
	return nil -- Moved this to one line of output via GetUnitSpellPower()
end
local function GetUnitSpellPowerFrost(unit)
	return nil -- Moved this to one line of output via GetUnitSpellPower()
end
local function GetUnitSpellPowerHoly(unit)
	return nil -- Moved this to one line of output via GetUnitSpellPower()
end
local function GetUnitSpellPowerNature(unit)
	return nil -- Moved this to one line of output via GetUnitSpellPower()
end
local function GetUnitSpellPowerShadow(unit)
	return nil -- Moved this to one line of output via GetUnitSpellPower()
end
local function GetUnitBlockValue(unit)
	return nvld(BCS:GetUnitBlockValue(unit))
end
local function GetUnitRangedCritChance(unit)
	local chance = BCS:GetUnitRangedCritChance(unit)
	if chance ~= nil and chance > 0 then
		chance = string.format("%.2f%%", chance)
	end
	return chance
end
local function GetUnitRangedHitRating(unit)
	local rating = BCS:GetUnitRangedHitRating(unit)
	if rating > 0 then return rating; end
end
local function GetUnitHealingPower(unit)
	local spellpower = BCS:GetUnitSpellPower(unit)
	local healingpower = BCS:GetUnitHealingPower(unit)
	local total = spellpower + healingpower
	if total > 0 then return total; end
end
local function GetUnitSpellCritChance(unit)
	local chance =BCS:GetUnitSpellCritChance(unit)
	if chance ~= nil and chance > 0 then
		chance = string.format("%.2f%%", chance)
	end
	return chance
end
local function GetUnitCritChance(unit)
	if unit == "player" then
		local chance = BCS:GetCritChance()
		if chance ~= nil and chance > 0 then
			chance = string.format("%.2f%%", chance)
		end
		return chance
	end
	return nil
end
local function GetUnitSpellHitRating(unit)
	local base_spell_hit, spell_hit_fire, spell_hit_frost, spell_hit_arcane, spell_hit_shadow, spell_hit_holy, spell_hit_nature = BCS:GetUnitSpellHitRating(unit)
	local total_hit = nvld(base_spell_hit) + nvld(spell_hit_fire) + nvld(spell_hit_frost) + nvld(spell_hit_arcane) + nvld(spell_hit_shadow) + nvld(spell_hit_holy)
	local retval = ""
	if base_spell_hit ~= nil and base_spell_hit > 0 then 
		retval = format("%d%%", nvld(base_spell_hit))
	end

	fmt="%s: %d%%"
	
	if base_spell_hit ~= total_hit then 
		retval = retval .. StatComparePaintText("X"," (")
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
	if nvld(spell_hit_nature) > 0 then
		retval = retval.." "..StatComparePaintText("H",format(fmt, STATCOMPARE_NATURE_SHORT, base_spell_hit + spell_hit_nature))
	end
	if nvld(spell_hit_shadow) > 0 then
		retval = retval.." "..StatComparePaintText("S",format(fmt, STATCOMPARE_SHADOW_SHORT, base_spell_hit + spell_hit_shadow))
	end
	if base_spell_hit ~= total_hit then
		retval = retval .. StatComparePaintText("X"," )")
	end
	return retval and retval or nil
end
local function GetUnitManaRegen(unit)
	local baseManaRegen, castingManaRegen, mp5 = BCS:GetUnitManaRegen(unit)
	return nvld(mp5).. " MP/5" .. (castingManaRegen ~= nil and castingManaRegen > 0 and (" (" .. STATCOMPARE_WHILE_CASTING .." "..nvld(castingManaRegen) .. "%)") or "")
end
local function GetUnitRegenMPPerSpirit(unit)
	local baseManaRegen, castingManaRegen, mp5 = BCS:GetUnitManaRegen(unit)
	local mp2 = mp5 * 0.4
	if baseManaRegen then return format("%d MP/2",baseManaRegen + mp2) end
end

local STATCOMPARE_EFFECTS = {
	{ effect = "STR"                                                                                        },
	{ effect = "AGI"                                                                                        },
	{ effect = "STA"                                                                                        },
	{ effect = "INT"                                                                                        },
	{ effect = "SPI"                                                                                        },
	{ effect = "ARMOR"                                                                                      },
	{ effect = "ENARMOR"                                                                                    },
	{ effect = "DAMAGEREDUCE"                                                                               },

	{ effect = "ARCANERES"                                                                                  },
	{ effect = "FIRERES"                                                                                    },
	{ effect = "NATURERES"                                                                                  },
	{ effect = "FROSTRES"                                                                                   },
	{ effect = "SHADOWRES"                                                                                  },
	{ effect = "DETARRES"                                                                                   },
	{ effect = "ALLRES"                                                                                     },

	{ effect = "DEFENSE"                                                                                    },
	{ effect = "STEALTH"                                                                                    },
	{ effect = "MINING"                                                                                     },
	{ effect = "HERBALISM"                                                                                  },
	{ effect = "SKINNING"                                                                                   },
	{ effect = "FISHING"                                                                                    },

	{ effect = "ATTACKPOWER"                                                                                },
	{ effect = "BEARAP"                                                                                     },
	{ effect = "CATAP"                                                                                      },
	{ effect = "ATTACKPOWERUNDEAD"                                                                          },
	{ effect = "CRIT",                              callback = GetUnitCritChance                            },
	{ effect = "BLOCK",                             callback = GetUnitBlockValue                            },
	{ effect = "TOBLOCK"                                                                                    },
	{ effect = "DODGE"                                                                                      },
	{ effect = "PARRY"                                                                                      },
	{ effect = "TOHIT"                                                                                      },
	{ effect = "RANGEDATTACKPOWER"                                                                          },
	{ effect = "RANGEDCRIT",                        callback = GetUnitRangedCritChance                      },
	{ effect = "RANGEDHIT",                         callback = GetUnitRangedHitRating                       },

	{ effect = "DMG",                               callback = GetUnitSpellPower                            },
	{ effect = "DMGUNDEAD"                                                                                  },
	{ effect = "HEAL",                              callback = GetUnitHealingPower                          },
	{ effect = "FLASHHOLYLIGHTHEAL"                                                                         },
	{ effect = "LESSERHEALWAVE"                                                                             },
	{ effect = "CHAINLIGHTNING"                                                                             },
	{ effect = "EARTHSHOCK"                                                                                 },
	{ effect = "FLAMESHOCK"                                                                                 },
	{ effect = "FROSTSHOCK"                                                                                 },
	{ effect = "LIGHTNINGBOLT"                                                                              },
	{ effect = "NATURECRIT"                                                                                 },
	{ effect = "HOLYCRIT"                                                                                   },
	{ effect = "SPELLCRIT",                         callback = GetUnitSpellCritChance                       },
	{ effect = "SPELLTOHIT",                        callback = GetUnitSpellHitRating                        },
	{ effect = "ARCANEDMG",                         callback = GetUnitSpellPowerArcane                      },
	{ effect = "FIREDMG",                           callback = GetUnitSpellPowerFire                        },
	{ effect = "FROSTDMG",                          callback = GetUnitSpellPowerFrost                       },
	{ effect = "HOLYDMG",                           callback = GetUnitSpellPowerHoly                        },
	{ effect = "NATUREDMG",                         callback = GetUnitSpellPowerNature                      },
	{ effect = "SHADOWDMG",                         callback = GetUnitSpellPowerShadow                      },

	{ effect = "HEALTH"                                                                                     },
	{ effect = "HEALTHREG"                                                                                  },
	{ effect = "MANA"                                                                                       },
	{ effect = "MANAREG",                           callback = GetUnitManaRegen                             },
	{ effect = "MANAREGSPI",                        callback = GetUnitRegenMPPerSpirit                      },

	{ effect = "MANAREGCOMBAT"                                                                              }
};

function BCSLib:StatHasCallback(stat)
	return BCS and BCS.BCS_SUPPORTS_TARGET and BCSLib:GetCallback(stat) ~= nil
end

function BCSLib:GetCallback(stat)
	if BCS and BCS.BCS_SUPPORTS_TARGET and STATCOMPARE_EFFECTS then 
		for i,e in pairs(STATCOMPARE_EFFECTS) do
			if e.effect == stat and e["callback"] ~= nil then
				return e.callback
			end
		end
	end
	return nil
end

function BCSLib:GetStat(stat, unit)
	local callback = BCSLib:GetCallback(stat)
	if callback then return callback(unit); end
	return nil
end
