ts_furniture = {}

local translator = minetest.get_translator
local S = translator and translator("ts_furniture") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

function ts_furniture.sit(pos, _, player)
	local name = player and player:get_player_name()

	if not player_api.player_attached[name] then
		if vector.length(player:get_player_velocity()) > 0 then
			return
		end

		for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.25)) do
			if obj:is_player() then
				local obj_name = obj:get_player_name()
				if obj_name ~= name then
					return
				end
			end
		end

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
		ts_furniture.stand(_, _, player)
	end
end

function ts_furniture.stand(_, _, player)
	local name = player and player:get_player_name()

	if player_api.player_attached[name] then
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		player:set_physics_override(1, 1, 1)
		player_api.player_attached[name] = false
		player_api.set_animation(player, "stand", 30)
	end
end

function ts_furniture.dig(pos, player)
	local name = player and player:get_player_name()

	if name then
		for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.25)) do
			if obj:is_player() then
				local obj_name = obj:get_player_name()
				if obj_name ~= name then
					return false
				end
			end
		end
	end

	return true
end

local stick = "default:stick"

local furnitures = {
	["chair"] = {
		description = "Chair",
		sitting = true,
		nodebox = {
			{ -0.3, -0.5,  0.2, -0.2,  0.5,  0.3 }, -- foot 1
			{  0.2, -0.5,  0.2,  0.3,  0.5,  0.3 }, -- foot 2
			{  0.2, -0.5, -0.3,  0.3, -0.1, -0.2 }, -- foot 3
			{ -0.3, -0.5, -0.3, -0.2, -0.1, -0.2 }, -- foot 4
			{ -0.3, -0.1, -0.3,  0.3,  0,    0.2 }, -- seating
			{ -0.2,  0.1,  0.25, 0.2,  0.4,  0.26}  -- conector 1-2
		},
		craft = function(recipe)
			return {
				{ "", stick},
				{recipe, recipe},
				{stick, stick}
			}
		end
	},
	["table"] = {
		description = "Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.4, -0.3 }, -- foot 1
			{  0.3, -0.5, -0.4,  0.4, 0.4, -0.3 }, -- foot 2
			{ -0.4, -0.5,  0.3, -0.3, 0.4,  0.4 }, -- foot 3
			{  0.3, -0.5,  0.3,  0.4, 0.4,  0.4 }, -- foot 4
			{ -0.5,  0.4, -0.5,  0.5, 0.5,  0.5 }  -- table top
		},
		craft = function(recipe)
			return {
				{recipe, recipe, recipe},
				{stick, "", stick},
				{stick, "", stick}
			}
		end
	},
	["small_table"] = {
		description = "Small Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.1, -0.3 }, -- foot 1
			{  0.3, -0.5, -0.4,  0.4, 0.1, -0.3 }, -- foot 2
			{ -0.4, -0.5,  0.3, -0.3, 0.1,  0.4 }, -- foot 3
			{  0.3, -0.5,  0.3,  0.4, 0.1,  0.4 }, -- foot 4
			{ -0.5,  0.1, -0.5,  0.5, 0.2,  0.5 }, -- table top
		},
		craft = function(recipe)
			return {
				{recipe, recipe, recipe},
				{stick, "", stick}
			}
		end
	},
	["tiny_table"] = {
		description = "Tiny Table",
		nodebox = {
			{ -0.5, -0.1, -0.5,  0.5,  0,   0.5 }, -- table top
			{ -0.4, -0.5, -0.5, -0.3, -0.1, 0.5 }, -- foot 1
			{  0.3, -0.5, -0.5,  0.4, -0.1, 0.5 }, -- foot 2
		},
		craft = function(recipe)
			local bench_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_bench"
			return {
				{bench_name, bench_name}
			}
		end
	},
	["bench"] = {
		description = "Bench",
		sitting = true,
		nodebox = {
			{ -0.5, -0.1, 0,  0.5,  0,   0.5 }, -- seating
			{ -0.4, -0.5, 0, -0.3, -0.1, 0.5 }, -- foot 1
			{  0.3, -0.5, 0,  0.4, -0.1, 0.5 }, -- foot 2
		},
		craft = function(recipe)
			return {
				{recipe, recipe},
				{stick, stick}
			}
		end
	},
	["bedsidetable"] = {
		description = "Bedside Table",
		nodebox = {
			{ -0.5, -0.5, -0.5, -0.4, 0.5,  0.5 },
			{  0.5, -0.5, -0.5,  0.4, 0.5,  0.5 },
			{ -0.5,  0.4, -0.5,  0.5, 0.5,  0.5 },
			{ -0.5,  0,   -0.5,  0.5, 0.1,  0.5 },
			{ -0.5, -0.5,  0.5,  0.5, 0.5,  0.4 }
		},
		craft = function(recipe)
			return {
				{recipe, recipe},
				{stick, stick},
				{stick, stick}
			}
		end
	},
	["endtable"] = {
		description = "End Table",
		nodebox = {
			{ -0.5, -0.5, -0.5, -0.4,  0.5, -0.4 },
			{ -0.5, -0.5,  0.5, -0.4,  0.5,  0.4 },
			{  0.5, -0.5, -0.5,  0.4,  0.5, -0.4 },
			{  0.5, -0.5,  0.5,  0.4,  0.5,  0.4 },
			{  0.5,  0.4,  0.5, -0.5,  0.5, -0.5 },
			{  0.5, -0.3,  0.5, -0.5, -0.2, -0.5 }
		},
		craft = function(recipe)
			return {
				{recipe, "", recipe},
				{stick, "", stick},
				{recipe, "", recipe}
			}
		end
	},
	["coffeetable"] = {
		description = "Coffee Table",
		nodebox = {
			{ -0.5, -0.5, -0.5, -0.4,  0,   -0.4 },
			{ -0.5, -0.5,  0.5, -0.4,  0,    0.4 },
			{  0.5, -0.5, -0.5,  0.4,  0,   -0.4 },
			{  0.5, -0.5,  0.5,  0.4,  0,    0.4 },
			{  0.5,  0.1,  0.5, -0.5,  0,   -0.5 },
			{  0.5, -0.3,  0.5, -0.5, -0.4, -0.5 }
		},
		craft = function(recipe)
			return {
				{recipe, "", recipe},
				{stick, "", stick}
			}
		end
	}
}

local ignore_groups = {
	["wood"] = true,
	["stone"] = true
}

function ts_furniture.register_furniture(recipe, description, tiles, fpairs)
	local recipe_def = minetest.registered_items[recipe]
	if not recipe_def then
		return
	end

	local groups = {falling_node = 1}

	for k, v in pairs(recipe_def.groups) do
		if not ignore_groups[k] then
			groups[k] = v
		end
	end

	for name, def in pairs(fpairs) do
		local node_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_" .. name

		if def.sitting then
			def.on_rightclick = ts_furniture.sit
			def.on_punch = ts_furniture.stand
			def.can_dig = ts_furniture.dig
		end

		minetest.register_node(":" .. node_name, {
			description = S(description) .. " " .. S(def.description),
			drawtype = def.drawtype or "nodebox",
			mesh = def.mesh,
			paramtype = "light",
			paramtype2 = "facedir",
			sunlight_propagates = true,
			tiles = { tiles },
			groups = groups,
			node_box = {
				type = "fixed",
				fixed = def.nodebox
			},
			on_rightclick = def.on_rightclick,
			on_punch = def.on_punch,
			can_dig = def.can_dig
		})

		minetest.register_craft({
			output = node_name,
			recipe = def.craft(recipe)
		})
	end
end

ts_furniture.register_furniture("default:birch_wood", "Birch", "default_birch_wood.png", furnitures)
ts_furniture.register_furniture("default:pine_wood", "Pine", "default_pine_wood.png", furnitures)
ts_furniture.register_furniture("default:acacia_wood", "Acacia", "default_acacia_wood.png", furnitures)
ts_furniture.register_furniture("default:wood", "Wooden", "default_wood.png", furnitures)
ts_furniture.register_furniture("default:junglewood", "Jungle Wood", "default_junglewood.png", furnitures)
ts_furniture.register_furniture("default:cherry_blossom_wood", "Cherry Blossom", "default_cherry_blossom_wood.png", furnitures)
