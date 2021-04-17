local translator = minetest.get_translator
local S = translator and translator("homedecor_furniture") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local function stand(_, _, player)
	local name = player and player:get_player_name()

	if player_api.player_attached[name] then
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		player:set_physics_override(1, 1, 1)
		player_api.player_attached[name] = false
		player_api.set_animation(player, "stand", 30)
	end
end

local function sit(pos, player, double)
	local name = player and player:get_player_name()

	if not player_api.player_attached[name] then
		if vector.length(player:get_player_velocity()) > 0 then
			return
		end

		pos.y = pos.y - 0.1
		player:move_to(pos)
		player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
		player:set_physics_override(0, 0, 0)
		player_api.player_attached[name] = true
		minetest.after(0.1, function()
			if player then
				player_api.set_animation(player, "sit", 30)
			end
		end)
	else
		stand(nil, nil, player)
	end
end

local function dyeing(pos, node, clicker, itemstack)
	local player_name = clicker and clicker:get_player_name() or ""

	if minetest.is_protected(pos, player_name) then
		return false
	end

	local itemname = itemstack:get_name()
	local nname = "homedecor_furniture:" .. (node.name:split(":")[2]):split("_")[1]
	if itemname:find("dye:") then
		minetest.swap_node(pos, {
			name = nname .. "_" .. itemname:split(":")[2],
			param2 = node.param2
		})

		if not minetest.is_creative_enabled(player_name) then
			itemstack:take_item()
		end

		return true
	end

	return false
end

local function sofa_on_place(itemstack, placer, pointed_thing)
	if placer and placer:is_player() and pointed_thing.type == "node" then
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local node_def = minetest.registered_nodes[node.name]
		if node_def and node_def.on_rightclick and
				not placer:get_player_control().sneak then
			return node_def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local pos
		if node_def and node_def.buildable_to then
			pos = under
		else
			pos = pointed_thing.above
		end

		local player_name = placer and placer:get_player_name() or ""

		if minetest.is_protected(pos, player_name) then
			return itemstack
		end

		local pos_right = vector.new(pos)
		local dir = minetest.dir_to_facedir(placer:get_look_dir()) % 4 or 0
		if dir == 1 then
			pos_right.z = pos_right.z - 1
		elseif dir == 2 then
			pos_right.x = pos_right.x - 1
		elseif dir == 3 then
			pos_right.z = pos_right.z + 1
		else
			pos_right.x = pos_right.x + 1
		end
		for _, p in pairs({pos_right, pos}) do
			local rnode_def = minetest.registered_nodes[minetest.get_node(p).name]
			if rnode_def and rnode_def.buildable_to then
				minetest.remove_node(pos_right)
			end
			if not rnode_def or not rnode_def.buildable_to then
				return itemstack
			end
		end

		minetest.set_node(pos, {name = itemstack:get_name():gsub("_inv", ""), param2 = dir})
		minetest.sound_play({name = "default_place_node_hard"}, {pos = pos})

		if not minetest.is_creative_enabled(player_name) then
			itemstack:take_item()
		end
	end

	return itemstack
end

local dyes = dye.dyes

for i = 1, #dyes do
	local color, desc1 = unpack(dyes[i])

	local cinv = 0
	local cdesc = ""
	if color ~= "red" then
		cinv = 1
		cdesc = desc1 .. " "
	end

	minetest.register_node("homedecor_furniture:sofa_inv_" .. color, {
		description = cdesc .. S"Sofa",
		drawtype = "mesh",
		mesh = "homedecor_furniture_sofa_inv.b3d",
		tiles = {"homedecor_furniture_sofa.png", "wool_" .. color .. ".png"},
		visual_scale = 0.75,
		node_placement_prediction = "",
		groups = {sofa = 1, not_in_creative_inventory = cinv},
		on_place = sofa_on_place
	})
	
	local sofa_box = {
		type = "fixed",
		fixed = {
			{-5/16, -8/16, -8/16.4, 21/16, -1/16, 7/16},
			{-5/16, -1/16,  4/16,   21/16,  8/16, 7/16}
		}
	}

	minetest.register_node("homedecor_furniture:sofa_" .. color, {
		drawtype = "mesh",
		mesh = "homedecor_furniture_sofa.b3d",
		tiles = {"homedecor_furniture_sofa.png", "wool_" .. color .. ".png"},
		collision_box = sofa_box,
		selection_box = sofa_box,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		drop = "homedecor_furniture:sofa_inv_" .. color,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2,
			sofa = 1},

		on_rightclick = function(pos, node, clicker, itemstack)
			if not dyeing(pos, node, clicker, itemstack) then
				sit(pos, clicker, true)
			end
			return itemstack
		end,
		
		on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
	})

	minetest.register_craft({
		output = "homedecor_furniture:sofa_inv_" .. color,
		recipe = {
			{"wool:" .. color, "", "wool:" .. color},
			{"wool:" .. color, "group:wood", "wool:" .. color},
			{"wool:" .. color, "group:wood", "wool:" .. color}
		}
	})

	local armchair_box = {
		type = "fixed",
		fixed = {
			{-5/16, -8/16, -5/16.5, 5/16, -1/16, 7/16},
			{-5/16, -1/16,  4/16,   5/16,  8/16, 7/16}
		}
	}

	minetest.register_node("homedecor_furniture:chair_" .. color, {
		description = cdesc .. S"Armchair",
		drawtype = "mesh",
		mesh = "homedecor_furniture_armchair.b3d",
		tiles = {"homedecor_furniture_armchair.png", "wool_" .. color .. ".png"},
		collision_box = armchair_box,
		selection_box = armchair_box,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2,
			armchair = 1, not_in_creative_inventory = cinv},

		on_rightclick = function(pos, node, clicker, itemstack)
			if not dyeing(pos, node, clicker, itemstack) then
				sit(pos, clicker)
			end
			return itemstack
		end,
		
		on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
	})

	minetest.register_craft({
		output = "homedecor_furniture:chair_" .. color,
		recipe = {
			{"", "", ""},
			{"wool:" .. color, "", "wool:" .. color},
			{"wool:" .. color, "group:wood", "wool:" .. color}
		}
	})
	
	minetest.register_alias("lrfurn:armchair_" .. color, "homedecor_furniture:chair_" .. color)
	minetest.register_alias("3d_furniture:chair_" .. color, "homedecor_furniture:chair_" .. color)
	minetest.register_alias("3d_furniture:sofa_" .. color, "homedecor_furniture:sofa_" .. color)
end

minetest.register_craft({
	output = "homedecor_furniture:sofa_inv_red",
	recipe = {
		{"group:wool", "group:wool", "group:wool"},
		{"group:wool", "", "group:wool"},
		{"group:wool", "group:wood", "group:wool"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:sofa",
	burntime = 16
})

minetest.register_craft({
	output = "homedecor_furniture:chair_red",
	recipe = {
		{"", "group:wool", ""},
		{"group:wool", "", "group:wool"},
		{"", "group:wood", ""}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:armchair",
	burntime = 10
})

