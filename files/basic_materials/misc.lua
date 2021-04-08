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

minetest.register_craftitem("basic_materials:oil_extract", {
	description = S("Oil extract"),
	inventory_image = "basic_materials_oil_extract.png",
})

minetest.register_craftitem("basic_materials:paraffin", {
	description = S("Unprocessed paraffin"),
	inventory_image = "basic_materials_paraffin.png",
})

minetest.register_craftitem("basic_materials:terracotta_base", {
	description = S("Uncooked Terracotta Base"),
	inventory_image = "basic_materials_terracotta_base.png",
})

-- nodes
minetest.register_node("basic_materials:concrete_block", {
	description = S("Concrete Block"),
	tiles = {"basic_materials_concrete_block.png",},
	groups = {cracky=1, level=2, concrete=1},
	sounds = default.node_sound_stone_defaults(),
})

-- crafts

minetest.register_craft({
	type = "shapeless",
	output = "basic_materials:oil_extract 2",
	recipe = {
		"group:leaves",
		"group:leaves",
		"group:leaves",
		"group:leaves",
		"group:leaves",
		"group:leaves"
	}
})

minetest.register_craft({
	type = "cooking",
	output = "basic_materials:paraffin",
	recipe = "basic_materials:oil_extract",
})

minetest.register_craft({
	type = "fuel",
	recipe = "basic_materials:oil_extract",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "basic_materials:paraffin",
	burntime = 30,
})

minetest.register_craft( {
	type = "shapeless",
	output = "basic_materials:terracotta_base 8",
	recipe = {
		"bucket:bucket_water",
		"default:clay_lump",
		"default:gravel",
	},
	replacements = { {"bucket:bucket_water", "bucket:bucket_empty"}, },
})

minetest.register_craft({
	output = 'basic_materials:concrete_block 6',
	recipe = {
		{'group:sand',                'default:cement', 'default:gravel'},
		{'basic_materials:steel_bar', 'bucket:bucket_water', 'basic_materials:steel_bar'},
		{'default:gravel',            'default:cement', 'group:sand'},
	},
	replacements = {{'bucket:bucket_water', 'bucket:bucket_empty'},},
})

minetest.register_craft({
	output = 'basic_materials:concrete_block 6',
	recipe = {
		{'group:sand',                'default:cement', 'default:gravel'},
		{'basic_materials:steel_bar', 'bucket:bucket_river_water', 'basic_materials:steel_bar'},
		{'default:gravel',            'default:cement', 'group:sand'},
	},
	replacements = {{"bucket:bucket_river_water", "bucket:bucket_empty"}}
})

minetest.register_alias("default:concrete", "basic_materials:concrete_block")