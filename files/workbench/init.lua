-- Localization for better performance
local path = minetest.get_modpath("workbench")
local register_node = minetest.register_node
local rotate_node = minetest.rotate_node
local swap_node = minetest.swap_node

workbench = {}

local translator = minetest.get_translator
workbench.S = translator and translator("workbench") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		workbench.S = intllib.make_gettext_pair()
	end
end

-- Nodeboxes definitions
workbench.defs = {
	-- Name       Yield   X  Y   Z  W   H  L
	{"micropanel",	8,	{ 0, 0,  0, 16, 1, 8  }},
	{"microslab",	4,	{ 0, 0,  0, 16, 1, 16 }},
	{"thinstair",	4,	{ 0, 7,  0, 16, 1, 8   },
						{ 0, 15, 8, 16, 1, 8  }},
	{"cube",		4,	{ 0, 0,  0, 8,  8, 8  }},
	{"panel",		4,	{ 0, 0,  0, 16, 8, 8  }},
	{"slab",		2,	{ 0, 0,  0, 16, 8, 16 }},
	{"doublepanel",	2,	{ 0, 0,  0, 16, 8, 8   },
						{ 0, 8,  8, 16, 8, 8  }},
	{"halfstair",	2,	{ 0, 0,  0, 8,  8, 16  },
						{ 0, 8,  8, 8,  8, 8  }},
	{"outerstair",	1,	{ 0, 0,  0, 16, 8, 16  },
						{ 0, 8,  8, 8,  8, 8  }},
	{"innerstair",	1,	{ 0, 0,  0, 16, 8, 16  },
						{ 0, 8,  8, 16, 8, 8   },
						{ 0, 8,  0, 8,  8, 8  }},
	{"stair",		1,	{ 0, 0,  0, 16, 8, 16  },
						{ 0, 8,  8, 16, 8, 8  }},
	{"slope",		2						   }
}

local slope = {
	drawtype = "mesh",
	mesh = "workbench_slope.obj",
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5,    -0.5,    0.5, -0.1875, 0.5},
			{-0.5, -0.1875, -0.1875, 0.5,  0.1875, 0.5},
			{-0.5,  0.1875,  0.1875, 0.5,  0.5,    0.5}
		}
	}
}

-- Otherwise we had to use too far entry in the table, 7 right now
local defs_desc = {}
do
	local upper = string.upper
	for i = 1, #workbench.defs do
		local desc = workbench.defs[i][1]:gsub("^%l", upper)
		defs_desc[i] = workbench.S(desc)
	end
end

dofile(path .. "/craft_all.lua")
dofile(path .. "/workbench.lua")

-- Thanks to kaeza for this function
local function pixelbox(size, boxes)
	local fixed = {}
	for i, box in pairs(boxes) do
		local x, y, z, w, h, l = unpack(box)
		fixed[i] = {
			(x / size) - 0.5,
			(y / size) - 0.5,
			(z / size) - 0.5,
			((x + w) / size) - 0.5,
			((y + h) / size) - 0.5,
			((z + l) / size) - 0.5
		}
	end
	return {type = "fixed", fixed = fixed}
end

-- Handles rotation
local floor = math.floor
local function rotation_handler(pos, node, puncher)
	local player = puncher:get_player_name()
	local ctrl = puncher:get_player_control()
	if not player or not (ctrl.sneak or ctrl.aux1)
	or minetest.is_protected(pos, player) then
		return
	end

	local yaw = floor(puncher:get_look_horizontal())
	local param2 = node.param2
	local axisdir = floor(param2 / 4) + 1
	if axisdir > 5 then axisdir = 0 end
	param2 = axisdir * 4

	if yaw == 0 or yaw == 5 or yaw == 6 or yaw == 3 or yaw == 2 then -- 12h and 6h
		if (param2 > 10 and param2 < 20) then
			param2 = param2 + 1
		end
	elseif yaw == 4 or yaw == 1 then -- 3h and 9h
		if (param2 > 10 and param2 < 21) or param2 == 0 then
			param2 = param2 + 3
		end
	else return end
	node.param2 = param2
	swap_node(pos, node)
end

workbench.nodes = {}
local function register_nodes()
	local registered_nodes = minetest.registered_nodes

	-- Nodes allowed to be cut
	-- Only the regular, solid blocks without metas or explosivity can be cut
	for node, def in pairs(registered_nodes) do
		if (def.drawtype == "normal" or def.drawtype:sub(1, 5) == "glass" or def.drawtype:sub(1, 8) == "allfaces") and
		   (def.tiles and type(def.tiles[1]) == "string") and
			not def.on_rightclick and
			not def.allow_metadata_inventory_put and
			not def.on_metadata_inventory_put and
			not (def.groups.not_in_creative_inventory == 1) and
			not (def.groups.not_cuttable == 1) and
			not def.groups.colorglass and
			not def.mesecons
		then
			workbench.nodes[node] = true
		end
	end

	for i = 1, #workbench.defs do
		local d = workbench.defs[i]
		for node, _ in pairs(workbench.nodes) do
			local def = registered_nodes[node]
			local name = "stairs:" .. d[1] .. "_" .. node:gsub(":", "_")

			local tiles = def.tiles
			if def.drawtype:sub(1, 5) == "glass" then
				tiles = {def.tiles[1]}
			end

			local drop =  ""
			if def.drop ~= "" then
				drop = name
			end

			local groups = {stairs = 1}
			for k, v in pairs(def.groups) do
				if k ~= "wood" and k ~= "stone" and k ~= "wool" and
						k ~= "level" and k ~= "hardened_clay" then
					groups[k] = v
				end
			end

			local sdef = {
				description = def.description .. " "  .. defs_desc[i],
				tiles = tiles,
				paramtype = "light",
				paramtype2 = "facedir",
				drop = drop,
				groups = groups,
				light_source = def.light_source / 2,
				sunlight_propagates = true,
				walkable = def.walkable,
				is_ground_content = false,
				sounds = def.sounds,
				use_texture_alpha = def.use_texture_alpha,
				on_place = rotate_node,
				on_punch = rotation_handler
			}

			if d[1] == "slope" then
				sdef.drawtype = slope.drawtype
				sdef.mesh = slope.mesh
				sdef.collision_box = slope.collision_box
			else
				sdef.drawtype = "nodebox"
				sdef.node_box = pixelbox(16, {unpack(d, 3)})
			end

			register_node(":" .. name, sdef)
		end
	end
end

if minetest.register_on_mods_loaded then
	minetest.after(0, function()
		register_nodes()
	end)
else -- legacy MultiCraft Engine
	minetest.after(0, function()
		register_nodes()
	end)
end
