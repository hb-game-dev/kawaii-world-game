-------------------------------------------------------------------------------
-- generate paths between buildings
-------------------------------------------------------------------------------
function villages.paths()
	local starting_point
	local end_point
	local distance
	--for k, v in pairs(villages.village_info) do
	starting_point = villages.village_info[1]["pos"]
	for o, _ in pairs(villages.village_info) do
		end_point = villages.village_info[o]["pos"]
		if starting_point ~= end_point then
			-- loop until end_point is reched (distance == 0)
			while true do
				-- define surrounding pos to starting_point
				local north_p = {x = starting_point.x + 1, y = starting_point.y, z = starting_point.z}
				local south_p = {x = starting_point.x - 1, y = starting_point.y, z = starting_point.z}
				local west_p = {x = starting_point.x, y = starting_point.y, z = starting_point.z + 1}
				local east_p = {x = starting_point.x, y = starting_point.y, z = starting_point.z - 1}
				-- measure distance to end_point
				local dist_north_p_to_end = math.sqrt(
					((north_p.x - end_point.x) * (north_p.x - end_point.x)) +
					((north_p.z - end_point.z) * (north_p.z - end_point.z)))
				local dist_south_p_to_end = math.sqrt(
					((south_p.x - end_point.x) * (south_p.x - end_point.x)) +
					((south_p.z - end_point.z) * (south_p.z - end_point.z)))
				local dist_west_p_to_end = math.sqrt(
					((west_p.x - end_point.x) * (west_p.x - end_point.x)) +
					((west_p.z - end_point.z) * (west_p.z - end_point.z)))
				local dist_east_p_to_end = math.sqrt(
					((east_p.x - end_point.x) * (east_p.x - end_point.x)) +
					((east_p.z - end_point.z) * (east_p.z - end_point.z)))
				-- evaluate which pos is closer to the end_point
				if dist_north_p_to_end <= dist_south_p_to_end and
					dist_north_p_to_end <= dist_west_p_to_end and
					dist_north_p_to_end <= dist_east_p_to_end then
						starting_point = north_p
						distance = dist_north_p_to_end

				elseif dist_south_p_to_end <= dist_north_p_to_end and
					dist_south_p_to_end <= dist_west_p_to_end and
					dist_south_p_to_end <= dist_east_p_to_end then
						starting_point = south_p
						distance = dist_south_p_to_end

				elseif dist_west_p_to_end <= dist_north_p_to_end and
					dist_west_p_to_end <= dist_south_p_to_end and
					dist_west_p_to_end <= dist_east_p_to_end then
						starting_point = west_p
						distance = dist_west_p_to_end

				elseif dist_east_p_to_end <= dist_north_p_to_end and
					dist_east_p_to_end <= dist_south_p_to_end and
					dist_east_p_to_end <= dist_west_p_to_end then
						starting_point = east_p
						distance = dist_east_p_to_end
				end
				-- find surface of new starting point
				local surface_point = villages.find_surface(starting_point)
				-- replace surface node with default:gravel
				if surface_point then
					minetest.swap_node(surface_point,{name="default:gravel"})
					-- don't set y coordinate, surface might be too low or high
					starting_point.x = surface_point.x
					starting_point.z = surface_point.z
				end
				if distance <= 1 or
					starting_point == end_point then
					break
				end
			end
		end
	end
end
