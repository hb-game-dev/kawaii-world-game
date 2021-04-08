-- Translation support
local translator = minetest.get_translator
local S = translator and translator("basic_materials") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

-- items

minetest.register_craftitem("basic_materials:silicon", {
	description = S("Silicon lump"),
	inventory_image = "basic_materials_silicon.png",
})

minetest.register_craftitem("basic_materials:ic", {
	description = S("Simple Integrated Circuit"),
	inventory_image = "basic_materials_ic.png",
})

minetest.register_craftitem("basic_materials:motor", {
	description = S("Simple Motor"),
	inventory_image = "basic_materials_motor.png",
})

minetest.register_craftitem("basic_materials:heating_element", {
	description = S("Heating element"),
	inventory_image = "basic_materials_heating_element.png",
})

minetest.register_craftitem("basic_materials:energy_crystal_simple", {
	description = S("Simple energy crystal"),
	inventory_image = "basic_materials_energy_crystal.png",
})

-- crafts

minetest.register_craft( {
	output = "basic_materials:silicon 4",
	recipe = {
		{ "default:sand", "default:sand" },
		{ "default:sand", "default:steel_ingot" },
	},
})

minetest.register_craft( {
	output = "basic_materials:ic 4",
	recipe = {
		{ "basic_materials:silicon", "basic_materials:silicon" },
		{ "basic_materials:silicon", "default:copper_ingot" },
	},
})

minetest.register_craft( {
    output = "basic_materials:motor 2",
    recipe = {
		{ "mesecons:wire_00000000_off", "basic_materials:copper_wire", "basic_materials:plastic_sheet" },
		{ "default:copper_ingot",          "default:steel_ingot",         "default:steel_ingot" },
		{ "mesecons:wire_00000000_off", "basic_materials:copper_wire", "basic_materials:plastic_sheet" }
    },
	replacements = {
		{ "basic_materials:copper_wire", "basic_materials:empty_spool" },
		{ "basic_materials:copper_wire", "basic_materials:empty_spool" },
	}
})

minetest.register_craft( {
    output = "basic_materials:heating_element 2",
    recipe = {
		{ "default:copper_ingot", "mesecons:wire_00000000_off", "default:copper_ingot" }
    },
})

minetest.register_craft({
	--type = "shapeless",
	output = "basic_materials:energy_crystal_simple 2",
	recipe = {
		{ "mesecons:wire_00000000_off", "default:torch", "mesecons:wire_00000000_off" },
		{ "default:diamond", "default:gold_ingot", "default:diamond" }
	},
})