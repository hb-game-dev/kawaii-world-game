mobs_water = {}

local translator = minetest.get_translator
mobs_water.S = translator and translator("mobs_water") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		mobs_water.S = intllib.make_gettext_pair()
	end
end

mobs_water.nodes = {
	"default:water_source", "default:water_flowing",
	"default:river_water_source", "default:river_water_flowing"
}

mobs_water.source_nodes = {
	"default:water_source", "default:river_water_source"
}

local path = minetest.get_modpath("mobs_water")
local names = {
    "dolphin",
    "shark"
}

for _, name in pairs(names) do
	dofile(path .. "/" .. name .. ".lua")
end

minetest.register_alias("mobs_water:aquarium_empty", "air")
minetest.register_alias("mobs_water:aquarium_fish_small", "air")
minetest.register_alias("mobs_water:aquarium_fish_medium", "air")
minetest.register_alias("default:pole", "air")