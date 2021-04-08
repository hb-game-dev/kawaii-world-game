bonemeal = {}

local translator = minetest.get_translator
local S = translator and translator("bonemeal") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local min, max, random = math.min, math.max, math.random

-- default crops
local crops = {
	{"farming:wheat_", 8, "farming:seed_wheat"},
	{"farming_addons:carrot_", 4, "farming_addons:seed_carrot"},
	{"farming_addons:cocoa_", 3, "farming_addons:seed_cocoa"},
	{"farming_addons:corn_", 8, "farming_addons:seed_corn"},
	{"farming_addons:melon_", 8, "farming_addons:seed_melon"},
	{"farming_addons:potato_", 4, "farming_addons:seed_potato"},
	{"farming_addons:pumpkin_", 8, "farming_addons:seed_pumpkin"}
}

-- helper tables ("" denotes a blank item)
local green_grass = {
	"default:grass", "", ""
}

local dry_grass = {
	"default:dry_grass", "", ""
}

local flowers = {}
for node, def in pairs(minetest.registered_nodes) do
	if def.groups.flower then
		flowers[#flowers+1] = node
	end
end

-- default biomes deco
local deco = {
	{"default:dirt_with_dry_grass", dry_grass, flowers},
	{"default:sand", {}, {"default:dry_shrub", "", "", ""}},
	{"default:redsand", {}, {"default:dry_shrub", "", "", ""}},
--	{"default:silver_sand", {}, {"default:dry_shrub", "", "", ""}}
}

--
-- Local functions
--

-- Particles
local function particle_effect(pos)
	minetest.add_particlespawner({
		amount = 4,
		time = 0.15,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 4, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minexptime = 1,
		maxexptime = 1,
		minsize = 1,
		maxsize = 3,
		texture = "bonemeal_particle.png"
	})
end


-- crops check
local function check_crops(pos, nodename, strength)
	-- grow registered crops
	for n = 1, #crops do
		if nodename:find(crops[n][1])
		or nodename == crops[n][3] then
			-- separate mod and node name
			local crop = nodename:split(":")[2]

			-- get stage number or set to 0 for seed
			local cstage = tonumber(crop:split("_")[2]) or 0

			local node = crops[n][1] .. min(cstage + strength, crops[n][2])
			local param2 = 0

			-- check for place_param setting
			if cstage > 0 then
				param2 = minetest.get_node(pos).param2
			else
				local def = minetest.registered_nodes[node]
				if def and def.place_param2 then
					param2 = def.place_param2
				end
			end

			minetest.swap_node(pos, {name = node, param2 = param2})
			particle_effect(pos)
			return true
		end
	end
end

-- check soil for specific decoration placement
local function check_soil(pos, nodename, strength)
	-- set radius according to strength
	local side = strength - 1
	local tall = max(strength - 2, 0)
	local floor
	local groups = minetest.registered_items[nodename]
		and minetest.registered_items[nodename].groups or {}

	-- only place decoration on one type of surface
	if groups.soil then
		floor = {"group:soil"}
	elseif groups.sand then
		floor = {"group:sand"}
	else
		floor = {nodename}
	end

	-- get area of land with free space above
	local dirt = minetest.find_nodes_in_area_under_air(
		{x = pos.x - side, y = pos.y - tall, z = pos.z - side},
		{x = pos.x + side, y = pos.y + tall, z = pos.z + side}, floor)

	-- set default grass and decoration
	local grass = green_grass
	local decor = flowers

	-- choose grass and decoration to use on dirt patch
	for n = 1, #deco do
		-- do we have a grass match?
		if nodename == deco[n][1] then
			grass = deco[n][2]
			decor = deco[n][3]
		end
	end

	-- loop through soil
	local node
	for _, n in pairs(dirt) do
		if random(5) == 1 then
			if decor ~= nil and #decor > 0 then
				-- place random decoration (rare)
				node = decor[random(#decor)]
			end
		else
			if grass ~= nil and #grass > 0 then
				-- place random grass (common)
				node = grass[random(#grass)]
			end
		end

		local pos2 = n
		pos2.y = pos2.y + 1

		if node and node ~= "" then
			-- get crop param2 value
			local def = minetest.registered_nodes[node]
			def = def and def.place_param2

			-- if param2 not preset then get from existing node
			if not def then
				local oldnode = minetest.get_node_or_nil(pos2)
				def = oldnode and oldnode.param2 or 0
			end

			minetest.set_node(pos2, {name = node, param2 = def})
		end

		particle_effect(pos2)
	end
end


-- global functions

-- add to crop list to force grow
-- {crop name start_, growth steps, seed node (if required)}
-- e.g. {"farming:wheat_", 8, "farming:seed_wheat"}
function bonemeal.add_crop(list)
	for n = 1, #list do
		crops[#crops+1] = list[n]
	end
end

-- add grass and flower/plant decoration for specific dirt types
-- {dirt_node, {grass_nodes}, {flower_nodes}
-- e.g. {"default:dirt_with_dry_grass", dry_grass, flowers}
-- if an entry already exists for a given dirt type, it will add new entries and all empty
-- entries, allowing to both add decorations and decrease their frequency.
function bonemeal.add_deco(list)
	for l = 1, #list do
		for n = 1, #deco do
			-- update existing entry
			if list[l][1] == deco[n][1] then
				-- adding grass types
				for _, extra in pairs(list[l][2]) do
					if extra ~= "" then
						for _, entry in pairs(deco[n][2]) do
							if extra == entry then
								extra = false
								break
							end
						end
					end

					if extra then
						deco[n][2][#deco[n][2]+1] = extra
					end
				end

				-- adding decoration types
				for _, extra in ipairs(list[l][3]) do
					if extra ~= "" then
						for _, entry in pairs(deco[n][3]) do
							if extra == entry then
								extra = false
								break
							end
						end
					end

					if extra then
						deco[n][3][#deco[n][3]+1] = extra
					end
				end

				list[l] = false
				break
			end
		end

		if list[l] then
			deco[#deco+1] = list[l]
		end
	end
end


-- definitively set a decration scheme
-- this function will either add a new entry as is, or replace the existing one
function bonemeal.set_deco(list)
	for l = 1, #list do
		for n = 1, #deco do
			-- replace existing entry
			if list[l][1] == deco[n][1] then
				deco[n][2] = list[l][2]
				deco[n][3] = list[l][3]
				list[l] = false
				break
			end
		end

		if list[l] then
			deco[#deco+1] = list[l]
		end
	end
end


-- global on_use function for bonemeal
function bonemeal.on_use(pos, strength, node)
	local pos_under = pos.under

	-- get node pointed at
	node = node or minetest.get_node(pos_under)
	local name = node.name

	-- return if nothing there
	if name == "ignore" then
		return false
	end

	-- make sure strength is between 1 and 4
	strength = strength and max(min(strength, 4), 1) or 1

	-- sugarcane and cactus
	if name == "default:sugarcane" then
		default.grow_sugarcane(pos_under, node)
		particle_effect(pos_under)
		return true
	elseif name == "default:cactus" then
		default.grow_cactus(pos_under, node)
		particle_effect(pos_under)
		return true
	end

	-- check for tree growth if pointing at sapling
	if minetest.get_item_group(name, "sapling") > 0 then
		if default.can_grow(pos_under) then
			if random(6 - strength) == 1 then
				default.grow_sapling(pos_under, name)
			end
			return true
		end
	end

	-- light check depending on strength (strength of 4 = no light needed)
	local light_level = minetest.get_node_light(pos.above)
	if not light_level or light_level < (14 - (strength * 3)) then
		return false
	end

	-- grow grass and flowers
	if minetest.get_item_group(name, "soil") > 0
	or minetest.get_item_group(name, "sand") > 0
	or minetest.get_item_group(name, "can_bonemeal") > 0 then
		check_soil(pos_under, name, strength)
		return true
	end

	-- check for crop growth
	if check_crops(pos_under, name, strength) then
		return true
	end

	return false
end

--
-- Bone Meal
--

minetest.override_item("dye:white", {
	description = S("Bone Meal"),
	on_use = function(itemstack, user, pointed_thing)
		local player_name = user:get_player_name()
		-- did we point at a node and area isn't protected?
		if pointed_thing.type ~= "node" or
		minetest.is_protected(pointed_thing.under, player_name) then
			return itemstack
		end

		-- call global on_use function with strength of 3
		if bonemeal.on_use(pointed_thing,  3) then
			-- take item if not in creative
			if not minetest.is_creative_enabled(player_name) or
						not minetest.is_singleplayer() then
				itemstack:take_item()
			end
		end

		return itemstack
	end
})
