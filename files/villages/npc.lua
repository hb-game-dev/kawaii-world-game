-- Register special blocks for NPC spawn
minetest.register_node("villages:junglewood", {
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, not_in_creative_inventory = 1},
	drop = "default:junglewood",
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("villages:cobble", {
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2, not_in_creative_inventory = 1},
	drop = "default:cobble",
	sounds = default.node_sound_stone_defaults()
})
