-- switch for debugging
villages.debug = false

-- timer between creation of two villages
villages.min_timer = 120
-- try to generate a village near the player’s spawn
villages.last_village = (os.time() - villages.min_timer) + 5

-- material to replace cobblestone with
villages.wallmaterial = {
	"default:junglewood",
	"default:pine_wood",
	"default:wood",
	"default:pine_wood",
	"default:acacia_wood",
	"default:stonebrick",
	"default:cobble",
	"default:redsandstone",
	"default:redsandstonesmooth",
	"default:sandstone"
}

villages.surface_mat = {}

--
-- possible surfaces where buildings can be built
--

function villages.grundstellungen()
	villages.surface_mat = villages.Set {
		"default:dirt_with_grass",
		"default:dry_dirt_with_grass",
		"default:dirt_with_snow",
		"default:dirt_with_dry_grass",
		"default:dirt_with_coniferous_litter",
		"default:sand",
		"default:silver_sand",
		"default:desert_sand",
		"default:snow_block"
	}
end

-- list of schematics
local schem_path = villages.modpath .. "/schematics/"
villages.schematic_table = {
	{name = "townhall", mts = schem_path .. "townhall.mts", hwidth = 10, hdepth = 11, hheight = 12, hsize = 15, max_num = 0, rplc = "n"},
	{name = "well", mts = schem_path .. "well.mts", hwidth = 5, hdepth = 5, hheight = 13, hsize = 11, max_num = 0.045, rplc = "n"},
	{name = "hut", mts = schem_path .. "hut.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.9, rplc = "y"},
	{name = "garden", mts = schem_path .. "garden.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.1, rplc = "n"},
	{name = "lamp", mts = schem_path .. "lamp.mts", hwidth = 3, hdepth = 3, hheight = 13, hsize = 10, max_num = 0.1, rplc = "n"},
	{name = "tower", mts = schem_path .. "tower.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.055, rplc = "n"},
	{name = "blacksmith", mts = schem_path .. "blacksmith.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.050, rplc = "n"}
}

-- temporary info for currentliy built village (position of each building)
villages.village_info = {}

-- min_distance between villages
villages.min_dist_villages = 500
if villages.debug then
	villages.min_dist_villages = 100
end

-- maximum allowed difference in height for building a villages
villages.max_height_difference = 12

villages.half_map_chunk_size = 40
villages.quarter_map_chunk_size = 20
