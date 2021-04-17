local S = mobs_animals.S

mobs:register_mob("mobs_animals:panda", {
	description = S("Panda"),
	type = "animal",
	visual = "mesh",
	mesh = "mobs_panda.b3d",
	collisionbox = {-0.4, -0.45, -0.4, 0.4, 0.45, 0.4},
	animation = {
		speed_normal = 20,
		speed_run = 35,
		stand_start = 130,
		stand_end = 270,
		stand1_start = 0,
		stand1_end = 0,
		stand2_start = 1,
		stand2_end = 1,
		stand3_start = 2,
		stand3_end = 2,
		walk_start = 10,
		walk_end = 70,
		run_start = 10,
		run_end = 70,
		punch_start = 80,
		punch_end = 120,
		-- 0 = rest, 1 = hiding (covers eyes), 2 = surprised
	},
	textures = {"mobs_panda.png"},
	sounds = {
		random = "mobs_panda",
		attack = "mobs_panda",
	},
	jump = false,
	water_damage = 1,
	walk_chance = 5,
	walk_velocity = 0.5,
	run_velocity = 1.5,
	view_range = 8,
	follow = {
		"farming:blueberries", "farming:raspberries"
	},
	damage = 3,
	attacks_monsters = true,
	pathfinding = true,
	group_attack = false,
	hp_min = 10,
	hp_max = 24,
	fear_height = 6,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(3, 5), pos)
		end
		return {
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:leather"},
			{name = "mobs:leather", chance = 2}
		}
	end,
	replace_what = {
		"farming:blueberry_4", "farming:raspberry_4"
	},
	replace_with = "air",
	replace_rate = 20,	
	armor = 200,	
	
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 20, true, true) then return end
--		if mobs:protect(self, clicker) then return end
--		if mobs:capture_mob(self, clicker, 0, 5, 50, false, nil) then return end
	end,
})

mobs:spawn({
	name = "mobs_animals:panda",
	nodes = {
		"default:dirt_with_grass", "default:dirt_with_dry_grass",
	},
	chance = 30000, -- 15000
	min_height = 10,
	max_height = 80,
	day_toggle = true,
})


mobs:register_egg("mobs_animals:panda", S("Panda Egg"), "mobs_panda_egg.png")