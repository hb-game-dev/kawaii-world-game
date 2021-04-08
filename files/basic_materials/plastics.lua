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

minetest.register_craftitem("basic_materials:plastic_sheet", {
	description = S("Plastic sheet"),
	inventory_image = "basic_materials_plastic_sheet.png",
})

minetest.register_craftitem("basic_materials:plastic_strip", {
	description = S("Plastic strips"),
	groups = { strip = 1 },
	inventory_image = "basic_materials_plastic_strip.png",
})

minetest.register_craftitem("basic_materials:empty_spool", {
	description = S("Empty wire spool"),
	inventory_image = "basic_materials_empty_spool.png"
})

-- crafts

minetest.register_craft({
	type = "cooking",
	output = "basic_materials:plastic_sheet",
	recipe = "basic_materials:paraffin",
})

minetest.register_craft({
	type = "fuel",
	recipe = "basic_materials:plastic_sheet",
	burntime = 30,
})

minetest.register_craft( {
    output = "basic_materials:plastic_strip 9",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
    },
})

minetest.register_craft( {
	output = "basic_materials:empty_spool 3",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "basic_materials:plastic_sheet", "" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
	},
})