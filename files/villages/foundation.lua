-------------------------------------------------------------------------------
-- function to fill empty space below baseplate when building on a hill
-------------------------------------------------------------------------------
function villages.ground(pos) -- role model: Wendelsteinkircherl, Brannenburg
	local p2 = villages.shallowCopy(pos)
	local cnt = 0
	local mat = "default:dirt"
	p2.y = p2.y - 1
	while true do
		cnt = cnt + 1
		if cnt > 20 then break end
		if cnt > math.random(2, 4) then
			mat = "default:stone"
		end
		minetest.swap_node(p2, {name = mat})
		p2.y = p2.y - 1
	end
end
-------------------------------------------------------------------------------
-- function clear space above baseplate
-------------------------------------------------------------------------------
function villages.terraform()
	local fheight
	local fwidth
	local fdepth

	for i, _ in ipairs(villages.village_info) do
		-- pick right schematic_info to current built_house
		for _, schem in ipairs(villages.schematic_table) do
			if villages.village_info[i]["name"] == schem["name"] then
				villages.schematic_data = schem
				break
			end
		end
		local pos = villages.village_info[i]["pos"]
		if villages.village_info[i]["rotat"] == "0" or villages.village_info[i]["rotat"] == "180" then
			fwidth = villages.schematic_data["hwidth"]
			fdepth = villages.schematic_data["hdepth"]
		else
			fwidth = villages.schematic_data["hdepth"]
			fdepth = villages.schematic_data["hwidth"]
		end
		-- fheight = villages.schematic_data["hheight"] * 3	-- remove trees and leaves above
		fheight = villages.schematic_data["hheight"]	-- remove trees and leaves above
		-- now that every info is available -> create platform and clear space above
		for xi = 0, fwidth - 1 do
		for zi = 0, fdepth - 1 do
		for yi = 0, fheight * 3 do
			if yi == 0 then
				local p = {x = pos.x + xi, y = pos.y, z = pos.z + zi}
				villages.ground(p)
			else
				-- write ground
				local p = {x = pos.x + xi, y = pos.y + yi, z = pos.z + zi}
				minetest.forceload_block(p)
				local node = minetest.get_node_or_nil(p)
				if node then
					if node.name ~= "air" then
						minetest.swap_node(p, {name="air"})
					end
				end
			end
		end
		end
		end
	end
end
