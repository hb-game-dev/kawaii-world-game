laptop.recipe_compat = {
	-- Init all used vars to avoid crash if missed
	tin = '-unknown-', copper = '-unknown-', gold = '-unknown-',
	steel = '-unknown-', glass = '-unknown-', diamond = '-unknown-',
	silicon = '-unknown-', plastic = '-unknown-',
	ic = '-unknown-', energy_crystal_simple = '-unknown-',
}

local rc = laptop.recipe_compat

-- Fallback values from default mod
if minetest.get_modpath('default') then
	rc.tin = 'default:tin_ingot'
	rc.copper = 'default:copper_ingot'
	rc.gold = 'default:gold_ingot'
	rc.steel = 'default:steel_ingot'
	rc.glass = 'default:glass'
	rc.diamond = 'default:diamond'
end

if minetest.get_modpath('basic_materials') then
	rc.silicon = 'basic_materials:silicon'
	rc.plastic = 'basic_materials:plastic_sheet'
	rc.ic = 'basic_materials:ic'
	rc.energy_crystal_simple = 'basic_materials:energy_crystal_simple'
end