mobs:register_mob("mobs_water:dolphin", {
	type = "animal",
    passive = true,
	hp_min = 20,
	hp_max = 25,
	armor = 150,
	collisionbox = {-0.75, -0.5, -0.75, 0.75, 0.5, 0.75},
	visual = "mesh",
	mesh = "mobs_water_dolphin.b3d",
	textures = {
		{"mobs_water_dolphin_pink.png"},
		{"mobs_water_dolphin_blue.png"},
		{"mobs_water_dolphin_white.png"}
	},
	sounds = {
	random = "dolphin",
    },
	drops = {
        {name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
    },
    stepheight = 0,
	walk_velocity = 4,
	run_velocity = 6,
	fly = true,
	fly_in = mobs_water.nodes,
	fall_speed = -5,
    fear_height = 5,
	water_damage = 0,
	lava_damage = 10,
	animation = {
		speed_normal = 15,
        speed_run = 15,
        stand_start = 66,
        stand_end = 90,
        walk_start = 0,
        walk_end = 40,
        run_start = 40,
        run_end = 60,
        punch_start = 40,
        punch_end = 40,
	}
--[[on_rightclick = function(self, clicker)
		mobs:capture_mob(self, clicker, 80, 100, 0, true, nil)
	end]]
})

mobs:spawn({
	name = "mobs_water:dolphin",
	nodes = mobs_water.source_nodes,
	neighbors = mobs_water.source_nodes,
	min_light = 1,
	chance = 10000,
    day_toggle = true
})

mobs:register_egg("mobs_water:dolphin", mobs_water.S"Dolphin Egg", "mobs_water_dolphin_egg.png")


