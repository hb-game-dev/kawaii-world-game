villages = {}
villages.modpath = minetest.get_modpath("villages");
villages.building_all_info = nil
villages.schematic_data = nil
villages.heightmap = nil
villages.suitable_place_found = nil

dofile(villages.modpath .. "/const.lua")
dofile(villages.modpath .. "/utils.lua")
dofile(villages.modpath .. "/foundation.lua")
dofile(villages.modpath .. "/buildings.lua")
dofile(villages.modpath .. "/paths.lua")
dofile(villages.modpath .. "/npc.lua")

-- load villages on server
villages_in_world = villages.load()
villages.grundstellungen()

-- on map generation, try to build a village
minetest.register_on_generated(function(minp, maxp)
	-- needed for manual and automated village building
	villages.heightmap = minetest.get_mapgen_object("heightmap")
	-- time between cration of two villages
	if os.difftime(os.time(), villages.last_village) < villages.min_timer then
		if villages.debug then
			minetest.chat_send_all(os.difftime(os.time(), villages.last_village))
		end
		return
	end

	if math.random(2) ~= 1 then
		return
	end

	-- don't build village underground
	if maxp.y < 0 then
		return
	end
	-- don't build villages too close to each other
	local center_of_chunk = {
		x = maxp.x - villages.half_map_chunk_size,
		y = maxp.y - villages.half_map_chunk_size,
		z = maxp.z - villages.half_map_chunk_size
	}
	local dist_ok = villages.check_distance_other_villages(center_of_chunk)
	if dist_ok == false then
		return
	end
	-- don't build villages on (too) uneven terrain
	local height_difference = villages.evaluate_heightmap(minp, maxp)
	if height_difference == nil then return end
	if height_difference > villages.max_height_difference then
		return
	end
	-- waiting necessary for chunk to load, otherwise, townhall is not in the middle, no map found behind townhall
	minetest.after(2, function()
		-- if nothing prevents the village -> do it

		-- fill villages.village_info with buildings and their data
		villages.suitable_place_found = false
		villages.suitable_place_found = villages.create_site_plan(maxp, minp)
		if not villages.suitable_place_found then
			return
		end

		-- set timestamp of actual village
		villages.last_village = os.time()

		-- evaluate villages.village_info and prepair terrain
		villages.terraform()

		-- evaluate villages.village_info and build paths between buildings
		villages.paths()

		-- evaluate villages.village_info and place schematics
		villages.place_schematics()

		-- evaluate villages.village_info and initialize furnaces and chests
		villages.initialize_nodes()
	end)
end)

-- manually place buildings, for debugging only
if villages.debug then
	minetest.register_craftitem("villages:tool", {
		description = "villages build tool",
		inventory_image = "default_tool_woodshovel.png",
		-- build village
		on_place = function(_, _, pointed_thing)
			local center_surface = pointed_thing.under
			if center_surface then
				local minp = {
					x = center_surface.x - villages.half_map_chunk_size,
					y = center_surface.y - villages.half_map_chunk_size,
					z = center_surface.z - villages.half_map_chunk_size
				}
				local maxp = {
					x = center_surface.x + villages.half_map_chunk_size,
					y = center_surface.y + villages.half_map_chunk_size,
					z = center_surface.z + villages.half_map_chunk_size
				}

				-- fill villages.village_info with buildings and their data
				local start_time = os.time()
				villages.suitable_place_found = villages.create_site_plan(maxp, minp)

				if not villages.suitable_place_found then
					return
				end

				-- evaluate villages.village_info and prepair terrain
				villages.terraform()

				-- evaluate villages.village_info and build paths between buildings
				villages.paths()

				-- evaluate villages.village_info and place schematics
				villages.place_schematics()

				-- evaluate villages.village_info and initialize furnaces and chests
				villages.initialize_nodes()

				local end_time = os.time()
				minetest.chat_send_all("Time: " .. end_time - start_time)
			end
		end
	})
end
