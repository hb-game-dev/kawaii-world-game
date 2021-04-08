local random = math.random
-------------------------------------------------------------------------------
-- function to copy tables
-------------------------------------------------------------------------------
function villages.shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

function villages.round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
-------------------------------------------------------------------------------
-- function to find surface block y coordinate
-- returns surface postion
-------------------------------------------------------------------------------
local string_find = string.find
function villages.find_surface(pos)
	local p6 = villages.shallowCopy(pos)
	local cnt = 0
	local itter = 1 -- count up or down
	local cnt_max = 200
	-- check, in which direction to look for surface
	local surface_node = minetest.get_node_or_nil(p6)
	if surface_node and string_find(surface_node .name, "air") then
		itter = -1
	end
	-- go through nodes an find surface
	while cnt < cnt_max do
		cnt = cnt + 1
		minetest.forceload_block(p6)
		surface_node = minetest.get_node_or_nil(p6)

		if not surface_node then
			-- Load the map at pos and try again
			minetest.get_voxel_manip():read_from_map(p6, p6)
			surface_node = minetest.get_node(p6)
			if surface_node.name == "ignore" then
				return nil
			end
		end

		--
		-- Check Surface_node and Node above
		--
		if villages.surface_mat[surface_node.name] then
			local surface_node_plus_1 = minetest.get_node_or_nil({x = p6.x, y = p6.y + 1, z = p6.z})

			if surface_node_plus_1 and surface_node and
			(string_find(surface_node_plus_1.name, "air")    or
			 string_find(surface_node_plus_1.name, "snow")   or
			 string_find(surface_node_plus_1.name, "fern")   or
			 string_find(surface_node_plus_1.name, "flower") or
			 string_find(surface_node_plus_1.name, "bush")   or
			 string_find(surface_node_plus_1.name, "tree")   or
			 string_find(surface_node_plus_1.name, "grass")) then
				return p6, surface_node.name
			end
		end
		p6.y = p6.y + itter
	end
	return nil
end
-------------------------------------------------------------------------------
-- check distance for new building
-------------------------------------------------------------------------------
function villages.check_distance(building_pos, building_size)
	local distance
	for _, built_house in ipairs(villages.village_info) do
		distance = math.sqrt(
			((building_pos.x - built_house["pos"].x) * (building_pos.x - built_house["pos"].x)) +
			((building_pos.z - built_house["pos"].z) * (building_pos.z - built_house["pos"].z)))
		if distance < building_size or
			distance < built_house["hsize"] then
			return false
		end
	end
	return true
end

local mod_storage = minetest.get_mod_storage()
-------------------------------------------------------------------------------
-- save list of generated villages
-------------------------------------------------------------------------------
function villages.save()
	mod_storage:set_string("villages_in_world", minetest.serialize(villages_in_world))
end
-------------------------------------------------------------------------------
-- load list of generated villages
-------------------------------------------------------------------------------
function villages.load()
	return minetest.deserialize(mod_storage:get_string("villages_in_world")) or {}
end
-------------------------------------------------------------------------------
-- check distance to other villages
-------------------------------------------------------------------------------
function villages.check_distance_other_villages(center_new_chunk)
	for _, pos in ipairs(villages_in_world) do
		local distance = vector.distance(center_new_chunk, pos)
		if villages.debug then
			minetest.chat_send_all("Dist: " .. distance)
		end
		if distance < villages.min_dist_villages then
			return false
		end
	end
	return true
end
-------------------------------------------------------------------------------
-- fill chests
-------------------------------------------------------------------------------
function villages.fill_chest(pos)
	-- fill chest
	local inv = minetest.get_inventory({type = "node", pos = pos})
	if inv then
		-- always
		inv:add_item("main", "default:apple " .. random(3))
		-- low value items
		if random(2) == 1 then
			inv:add_item("main", "farming:bread " .. random(3))
			inv:add_item("main", "default:steel_ingot " .. random(3))
		end
		-- medium value items
		if random(3) == 1 then
			inv:add_item("main", "default:pick_steel " .. random(0, 1))
			inv:add_item("main", "default:axe_steel " .. random(0, 1))
			inv:add_item("main", "fire:flint_and_steel " .. random(0, 1))
			inv:add_item("main", "bucket:bucket_empty " .. random(0, 1))
			inv:add_item("main", "default:sword_steel " .. random(0, 1))
		end
	end
end
-------------------------------------------------------------------------------
-- initialize furnace, chests, bookshelves
-------------------------------------------------------------------------------
function villages.initialize_nodes()
	for i, _ in ipairs(villages.village_info) do
		for _, schem in ipairs(villages.schematic_table) do
			if villages.village_info[i]["name"] == schem["name"] then
				villages.building_all_info = schem
				break
			end
		end

		local width = villages.building_all_info["hwidth"]
		local depth = villages.building_all_info["hdepth"]
		local height = villages.building_all_info["hheight"]

		local p = villages.village_info[i]["pos"]
		for yi = 1, height do
		for xi = 0, width do
		for zi = 0, depth do
			local ptemp = {x = p.x + xi, y = p.y + yi, z = p.z + zi}
			local node = minetest.get_node(ptemp)
			if node.name == "default:furnace" or
				node.name == "default:chest" or
				node.name == "default:bookshelf" then
				minetest.registered_nodes[node.name].on_construct(ptemp)
			end
			-- when chest is found -> fill with stuff
			if node.name == "default:chest" then
				minetest.after(0, function()
					villages.fill_chest(ptemp)
				end)
			end
		end
		end
		end
	end
end
-------------------------------------------------------------------------------
-- randomize table
-------------------------------------------------------------------------------
function shuffle(tbl)
	local table = villages.shallowCopy(tbl)
	local size = #table
	for i = size, 1, -1 do
		local rand = random(size)
		table[i], table[rand] = table[rand], table[i]
	end
	return table
end
-------------------------------------------------------------------------------
-- evaluate heightmap
-------------------------------------------------------------------------------
function villages.evaluate_heightmap()
	-- max height and min height, initialize with impossible values for easier first time setting
	local max_y = -50000
	local min_y = 50000
	-- only evaluate the center square of heightmap 40 x 40
	local square_start = 1621
	local square_end = 1661
	for _ = 1, 40 do
		for i = square_start, square_end do
			-- skip buggy heightmaps, return high value
			if villages.heightmap[i] == nil then return end
			if villages.heightmap[i] == -31000 or
				villages.heightmap[i] == 31000 then
				return villages.max_height_difference + 1
			end
			if villages.heightmap[i] < min_y then
				min_y = villages.heightmap[i]
			end
			if villages.heightmap[i] > max_y then
				max_y = villages.heightmap[i]
			end
		end
		-- set next line
		square_start = square_start + 80
		square_end = square_end + 80
	end
	-- return the difference between highest and lowest pos in chunk
	local height_diff = max_y - min_y
	-- filter buggy heightmaps
	if height_diff < 0 then
		return villages.max_height_difference + 1
	end
	-- debug info
	if villages.debug then
		minetest.chat_send_all("Heightdiff: " .. height_diff)
	end
	return height_diff
end
-------------------------------------------------------------------------------
-- Set array to list
-------------------------------------------------------------------------------
function villages.Set(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end
