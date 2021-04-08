--
-- Doors
--

-- Apple Wood Doors --

doors.register("door_wood", {
	tiles = {{name = "doors_door_wood.png", backface_culling = true}},
	description = "Apple Wood Door",
	inventory_image = "doors_item_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"}
	}
})

doors.register("door_wood_glass", {
	tiles = {{name = "doors_door_wood_glass.png", backface_culling = true}},
	description = "Apple Wood Door with Glass",
	inventory_image = "doors_item_wood_glass.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 10,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"}
	}
})

doors.register("door_wood_room_medium", {
	tiles = {{name = "doors_door_wood_room_glass_medium.png", backface_culling = true}},
	description = "Apple Wood Interior Door",
	inventory_image = "doors_item_wood_room_glass_medium.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 6,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:wood", "default:wood"}
	}
})

doors.register("door_wood_room_big", {
	tiles = {{name = "doors_door_wood_room_glass_big.png", backface_culling = true}},
	description = "Apple Wood Interior Glass Door",
	inventory_image = "doors_item_wood_room_glass_big.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 3,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:wood", "default:glass"}
	}
})

-- Acacia Wood Doors --

doors.register("door_acacia_wood", {
	tiles = {{name = "doors_door_acacia_wood.png", backface_culling = true}},
	description = "Acacia Wood Door",
	inventory_image = "doors_item_acacia_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:acacia_wood", "default:acacia_wood"},
		{"default:acacia_wood", "default:acacia_wood"},
		{"default:acacia_wood", "default:acacia_wood"}
	}
})

doors.register("door_acacia_wood_glass", {
	tiles = {{name = "doors_door_acacia_wood_glass.png", backface_culling = true}},
	description = "Acacia Wood Door with Glass",
	inventory_image = "doors_item_acacia_wood_glass.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 10,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:acacia_wood", "default:acacia_wood"},
		{"default:acacia_wood", "default:acacia_wood"}
	}
})

doors.register("door_acacia_wood_room_glass", {
	tiles = {{name = "doors_door_acacia_wood_room_glass_medium.png", backface_culling = true}},
	description = "Acacia Wood Interior Door",
	inventory_image = "doors_item_acacia_wood_room_glass_medium.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 6,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:acacia_wood", "default:acacia_wood"}
	}
})

doors.register("door_acacia_wood_room_glass_big", {
	tiles = {{name = "doors_door_acacia_wood_room_glass_big.png", backface_culling = true}},
	description = "Acacia Wood Interior Glass Door",
	inventory_image = "doors_item_acacia_wood_room_glass_big.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 3,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:acacia_wood", "default:glass"}
	}
})

-- Birch Wood Doors --

doors.register("door_birch_wood", {
	tiles = {{name = "doors_door_birch_wood.png", backface_culling = true}},
	description = "Birch Wood Door",
	inventory_image = "doors_item_birch_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:birch_wood", "default:birch_wood"},
		{"default:birch_wood", "default:birch_wood"},
		{"default:birch_wood", "default:birch_wood"}
	}
})

doors.register("door_birch_wood_glass", {
	tiles = {{name = "doors_door_birch_wood_glass.png", backface_culling = true}},
	description = "Birch Wood Door with Glass",
	inventory_image = "doors_item_birch_wood_glass.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 10,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:birch_wood", "default:birch_wood"},
		{"default:birch_wood", "default:birch_wood"}
	}
})


doors.register("door_birch_wood_room_glass", {
	tiles = {{name = "doors_door_birch_wood_room_glass_medium.png", backface_culling = true}},
	description = "Birch Wood Interior Door",
	inventory_image = "doors_item_birch_wood_room_glass_medium.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 6,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:birch_wood", "default:birch_wood"}
	}
})

doors.register("door_birch_wood_room_glass_big", {
	tiles = {{name = "doors_door_birch_wood_room_glass_big.png", backface_culling = true}},
	description = "Birch Wood Interior Glass Door",
	inventory_image = "doors_item_birch_wood_room_glass_big.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 3,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:birch_wood", "default:glass"}
	}
})

-- Jungle Wood Doors --

doors.register("door_jungle_wood", {
	tiles = {{name = "doors_door_jungle_wood.png", backface_culling = true}},
	description = "Jungle Wood Door",
	inventory_image = "doors_item_jungle_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:junglewood", "default:junglewood"},
		{"default:junglewood", "default:junglewood"},
		{"default:junglewood", "default:junglewood"}
	}
})

doors.register("door_jungle_wood_glass", {
	tiles = {{name = "doors_door_jungle_wood_glass.png", backface_culling = true}},
	description = "Jungle Wood Door with Glass",
	inventory_image = "doors_item_jungle_wood_glass.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 10,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:junglewood", "default:junglewood"},
		{"default:junglewood", "default:junglewood"}
	}
})


doors.register("door_jungle_wood_room_glass", {
	tiles = {{name = "doors_door_jungle_wood_room_glass_medium.png", backface_culling = true}},
	description = "Jungle Wood Interior Door",
	inventory_image = "doors_item_jungle_wood_room_glass_medium.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 6,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:junglewood", "default:junglewood"}
	}
})

doors.register("door_jungle_wood_room_glass_big", {
	tiles = {{name = "doors_door_jungle_wood_room_glass_big.png", backface_culling = true}},
	description = "Jungle Wood Interior Glass Door",
	inventory_image = "doors_item_jungle_wood_room_glass_big.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 3,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:junglewood", "default:glass"}
	}
})

-- Pine Wood Doors --

doors.register("door_pine_wood", {
	tiles = {{name = "doors_door_pine_wood.png", backface_culling = true}},
	description = "Pine Wood Door",
	inventory_image = "doors_item_pine_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:pine_wood", "default:pine_wood"},
		{"default:pine_wood", "default:pine_wood"},
		{"default:pine_wood", "default:pine_wood"}
	}
})

doors.register("door_pine_wood_glass", {
	tiles = {{name = "doors_door_pine_wood_glass.png", backface_culling = true}},
	description = "Pine Wood Door with Glass",
	inventory_image = "doors_item_pine_wood_glass.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 10,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:pine_wood", "default:pine_wood"},
		{"default:pine_wood", "default:pine_wood"}
	}
})


doors.register("door_pine_wood_room_glass", {
	tiles = {{name = "doors_door_pine_wood_room_glass_medium.png", backface_culling = true}},
	description = "Pine Wood Interior Door",
	inventory_image = "doors_item_pine_wood_room_glass_medium.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 6,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:pine_wood", "default:pine_wood"}
	}
})

doors.register("door_pine_wood_room_glass_big", {
	tiles = {{name = "doors_door_pine_wood_room_glass_big.png", backface_culling = true}},
	description = "Pine Wood Interior Glass Door",
	inventory_image = "doors_item_pine_wood_room_glass_big.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 3,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:pine_wood", "default:glass"}
	}
})

-- Cherry Blossom Wood Doors --

doors.register("door_cherry_blossom_wood", {
	tiles = {{name = "doors_door_cherry_blossom_wood.png", backface_culling = true}},
	description = "Cherry Blossom Wood Door",
	inventory_image = "doors_item_cherry_blossom_wood.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 14,
	recipe = {
		{"default:cherry_blossom_wood", "default:cherry_blossom_wood"},
		{"default:cherry_blossom_wood", "default:cherry_blossom_wood"},
		{"default:cherry_blossom_wood", "default:cherry_blossom_wood"}
	}
})

doors.register("door_cherry_blossom_wood_glass", {
	tiles = {{name = "doors_door_cherry_blossom_wood_glass.png", backface_culling = true}},
	description = "Cherry Blossom Wood Door with Glass",
	inventory_image = "doors_item_cherry_blossom_wood_glass.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 10,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:cherry_blossom_wood", "default:cherry_blossom_wood"},
		{"default:cherry_blossom_wood", "default:cherry_blossom_wood"}
	}
})


doors.register("door_cherry_blossom_wood_room_glass", {
	tiles = {{name = "doors_door_cherry_blossom_wood_room_glass_medium.png", backface_culling = true}},
	description = "Cherry Blossom Wood Interior Door",
	inventory_image = "doors_item_cherry_blossom_wood_room_glass_medium.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 6,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:cherry_blossom_wood", "default:cherry_blossom_wood"}
	}
})

doors.register("door_blossom_wood_room_glass_big", {
	tiles = {{name = "doors_door_cherry_blossom_wood_room_glass_big.png", backface_culling = true}},
	description = "Cherry Blossom Wood Interior Glass Door",
	inventory_image = "doors_item_cherry_blossom_wood_room_glass_big.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	fuel = 3,
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:cherry_blossom_wood", "default:glass"}
	}
})

-- Other Doors --

doors.register("door_steel", {
	tiles = {{name = "doors_door_steel.png", backface_culling = true}},
	description = "Steel Door",
	inventory_image = "doors_item_steel.png",
	protected = true,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"}
	}
})

doors.register("door_gold", {
	tiles = {{name = "doors_door_gold.png", backface_culling = true}},
	description = "Gold Door",
	inventory_image = "doors_item_gold.png",
	protected = true,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot"}
	}
})

doors.register("door_glass", {
	tiles = {{name = "doors_door_glass.png", backface_culling = true}},
	description = "Glass Interior Door",
	inventory_image = "doors_item_glass.png",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_fencegate_close", -- with good sounds lately hard
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"}
	}
})

doors.register("door_grill", {
	tiles = {{name = "doors_door_grill.png", backface_culling = true}},
	description = "Grilled Door",
	inventory_image = "doors_item_grill.png",
	protected = true,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{"default:grill_bar", "default:grill_bar"},
		{"default:grill_bar", "default:grill_bar"},
		{"default:grill_bar", "default:grill_bar"}
	}
})

-- Aliases

local doors_aliases = {
	{"acacia_b_1",		"doors:door_acacia_wood_a"},
	{"acacia_b_2",		"doors:door_acacia_wood_b"},
	{"acacia_t_1",		"air"},
	{"acacia_t_2",		"air"},
	{"birch_b_1",		"doors:door_birch_wood_a"},
	{"birch_b_2",		"doors:door_birch_wood_b"},
	{"birch_t_1",		"air"},
	{"birch_t_2",		"air"},
	{"dark_oak_b_1",	"doors:door_pine_wood_a"},
	{"dark_oak_b_2",	"doors:door_pine_wood_b"},
	{"dark_oak_t_1",	"air"},
	{"dark_oak_t_2",	"air"},
	{"jungle_b_1",		"doors:door_jungle_wood_a"},
	{"jungle_b_2",		"doors:door_jungle_wood_a"},
	{"jungle_t_1",		"air"},
	{"jungle_t_2",		"air"},
	{"wood_b_1",		"doors:door_wood_a"},
	{"wood_b_2",		"doors:door_wood_b"},
	{"wood_t_1",		"air"},
	{"wood_t_2",		"air"},
	{"steel_b_1",		"doors:door_steel_a"},
	{"steel_b_2",		"doors:door_steel_b"},
	{"steel_t_1",		"air"},
	{"steel_t_2",		"air"},
	{"wood_room_a",		"doors:door_wood_room_medium"},
	{"acacia",			"doors:door_acacia_wood"},
	{"birch",			"doors:door_birch_wood"},
	{"dark_oak",		"doors:door_pine_wood"},
	{"jungle",			"doors:door_jungle_wood"}
}

for i = 1, #doors_aliases do
	local old, new = unpack(doors_aliases[i])
	minetest.register_alias("doors:door_" .. old, new)
end

minetest.register_alias("doors:hidden", "air")


--
-- Trapdoors
--

doors.register_trapdoor("doors:trapdoor", {
	description = "Apple Wood Trapdoor",
	wield_image = "doors_trapdoor_wood.png^doors_trapdoor_wood_handle.png",
	tile_front = "doors_trapdoor_wood.png^doors_trapdoor_wood_handle.png",
	tile_bottom = "doors_trapdoor_wood.png",
	tile_side = "doors_trapdoor_wood_side.png",
	material = "default:wood",
	fuel = 7,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_acacia_wood", {
	description = "Acacia Wood Trapdoor",
	wield_image = "doors_trapdoor_acacia_wood.png^doors_trapdoor_wood_handle.png",
	tile_front = "doors_trapdoor_acacia_wood.png^doors_trapdoor_wood_handle.png",
	tile_bottom = "doors_trapdoor_acacia_wood.png",
	tile_side = "doors_trapdoor_acacia_wood_side.png",
	material = "default:acacia_wood",
	fuel = 7,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_birch_wood", {
	description = "Birch Wood Trapdoor",
	wield_image = "doors_trapdoor_birch_wood.png^doors_trapdoor_wood_handle.png",
	tile_front = "doors_trapdoor_birch_wood.png^doors_trapdoor_wood_handle.png",
	tile_bottom = "doors_trapdoor_birch_wood.png",
	tile_side = "doors_trapdoor_birch_wood_side.png",
	material = "default:birch_wood",
	fuel = 7,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_jungle_wood", {
	description = "Jungle Wood Trapdoor",
	wield_image = "doors_trapdoor_jungle_wood.png^doors_trapdoor_wood_handle.png",
	tile_front = "doors_trapdoor_jungle_wood.png^doors_trapdoor_wood_handle.png",
	tile_bottom = "doors_trapdoor_jungle_wood.png",
	tile_side = "doors_trapdoor_jungle_wood_side.png",
	material = "default:junglewood",
	fuel = 7,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_pine_wood", {
	description = "Pine Wood Trapdoor",
	wield_image = "doors_trapdoor_pine_wood.png^doors_trapdoor_wood_handle.png",
	tile_front = "doors_trapdoor_pine_wood.png^doors_trapdoor_wood_handle.png",
	tile_bottom = "doors_trapdoor_pine_wood.png",
	tile_side = "doors_trapdoor_pine_wood_side.png",
	material = "default:pine_wood",
	fuel = 7,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_cherry_blossom_wood", {
	description = "Cherry Blossom Wood Trapdoor",
	wield_image = "doors_trapdoor_cherry_blossom_wood.png^doors_trapdoor_wood_handle.png",
	tile_front = "doors_trapdoor_cherry_blossom_wood.png^doors_trapdoor_wood_handle.png",
	tile_bottom = "doors_trapdoor_cherry_blossom_wood.png",
	tile_side = "doors_trapdoor_cherry_blossom_wood_side.png",
	material = "default:cherry_blossom_wood",
	fuel = 7,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_steel", {
	description = "Steel Trapdoor",
	wield_image = "doors_trapdoor_steel.png^doors_trapdoor_steel_handle.png",
	tile_front = "doors_trapdoor_steel.png^doors_trapdoor_steel_handle.png",
	tile_bottom = "doors_trapdoor_steel.png",
	tile_side = "doors_trapdoor_steel_side.png",
	node_box_open = {
		type = "fixed",
		fixed = {-0.5, -0.5, 3/8, 0.5, 0.5, 0.5}
	},
	node_box_close = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -3/8, 0.5}
	},
	protected = true,
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	material = "default:steel_ingot",
	groups = {cracky = 1, level = 2, door = 1}
})

doors.register_trapdoor("doors:trapdoor_gold", {
	description = "Gold Trapdoor",
	wield_image = "doors_trapdoor_gold.png^doors_trapdoor_gold_handle.png",
	tile_front = "doors_trapdoor_gold.png^doors_trapdoor_gold_handle.png",
	tile_bottom = "doors_trapdoor_gold.png",
	tile_side = "doors_trapdoor_gold_side.png",
	node_box_open = {
		type = "fixed",
		fixed = {-0.5, -0.5, 3/8, 0.5, 0.5, 0.5}
	},
	node_box_close = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -3/8, 0.5}
	},
	protected = true,
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	material = "default:gold_ingot",
	groups = {cracky = 1, level = 2, door = 1}
})


--
-- Fencegates
--

doors.register_fencegate("doors:gate_wood", {
	description = "Apple Wood Fence Gate",
	texture = "default_wood.png",
	inventory_image = "doors_fencegate_wood.png",
	wield_image = "doors_fencegate_wood.png",
	material = "default:wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

doors.register_fencegate("doors:gate_acacia_wood", {
	description = "Acacia Wood Fence Gate",
	texture = "default_acacia_wood.png",
	inventory_image = "doors_fencegate_acacia_wood.png",
	wield_image = "doors_fencegate_acacia_wood.png",
	material = "default:acacia_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

doors.register_fencegate("doors:gate_birch_wood", {
	description = "Birch Wood Fence Gate",
	texture = "default_birch_wood.png",
	inventory_image = "doors_fencegate_birch_wood.png",
	wield_image = "doors_fencegate_birch_wood.png",
	material = "default:birch_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

doors.register_fencegate("doors:gate_jungle_wood", {
	description = "Jungle Wood Fence Gate",
	texture = "default_junglewood.png",
	inventory_image = "doors_fencegate_jungle_wood.png",
	wield_image = "doors_fencegate_jungle_wood.png",
	material = "default:junglewood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

doors.register_fencegate("doors:gate_pine_wood", {
	description = "Pine Wood Fence Gate",
	texture = "default_pine_wood.png",
	inventory_image = "doors_fencegate_pine_wood.png",
	wield_image = "doors_fencegate_pine_wood.png",
	material = "default:pine_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

doors.register_fencegate("doors:gate_cherry_blossom_wood", {
	description = "Cherry Blossom Fence Gate",
	texture = "default_cherry_blossom_wood.png",
	inventory_image = "doors_fencegate_cherry_blossom_wood.png",
	wield_image = "doors_fencegate_cherry_blossom_wood.png",
	material = "default:cherry_blossom_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fencegate_wood = 1}
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:fencegate_wood",
	burntime = 10
})

doors.register_fencegate("doors:gate_ice", {
	description = "Ice Fence Gate",
	texture = "default_ice.png",
	inventory_image = "doors_fencegate_ice.png",
	wield_image = "doors_fencegate_ice.png",
	material = "default:ice",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sound_open = "doors_steel_door_open"
})

minetest.register_alias("fences:fencegate_open", "doors:gate_wood_open")
minetest.register_alias("fences:fencegate", "doors:gate_wood")
minetest.register_alias("doors:gate_wood_closed", "doors:gate_wood")
